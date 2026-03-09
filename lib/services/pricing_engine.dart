import 'ml_inference_service.dart';

/// Feature encoding helpers — must match encoding used during model training.
class _Encode {
  static double vehicle(String v) {
    switch (v) {
      case 'Bike':
        return 0;
      case 'Car':
        return 1;
      case 'Van':
        return 2;
      case 'Truck':
        return 3;
      default:
        return 1;
    }
  }

  static double weather(String w) {
    switch (w) {
      case 'Clear':
        return 0;
      case 'Rainy':
        return 1;
      case 'Foggy':
        return 2;
      default:
        return 0;
    }
  }

  static double category(String c) {
    switch (c) {
      case 'General':
        return 0;
      case 'Electronics':
        return 1;
      case 'Fragile':
        return 2;
      case 'Perishable':
        return 3;
      default:
        return 0;
    }
  }
}

/// Business rule thresholds.
const double kMinWinProbability = 0.60;
const double kMinMargin = 0.10;

/// ─────────────────────────────────────────────────────────────────────────
/// Pricing Engine
///
/// Two public methods:
///   [predict]  — generates the initial quote (price, win_prob, margin)
///   [reframe]  — runs the constraint-aware optimizer to improve a weak quote
///
/// Optimizer strategy:
///   Scans the full feasible price range (from initial price, stepping down 3%
///   each iteration, stopping at the minimum-margin floor). Picks the candidate
///   with the highest score = win_probability × margin.
///
///   reframe_status in the returned map:
///     'success'     → best candidate satisfies BOTH constraints
///     'constrained' → margin floor was hit before win probability target;
///                     returns the best available quote with a warning flag
///     ''            → initial quote (not a reframe call)
/// ─────────────────────────────────────────────────────────────────────────
class PricingEngine {
  static final PricingEngine _instance = PricingEngine._internal();
  factory PricingEngine() => _instance;
  PricingEngine._internal();

  final _ml = MLInferenceService();

  // ── Public API ────────────────────────────────────────────────────────

  /// Generate the initial quote for a shipment.
  ///
  /// Returns a map with:
  ///   `recommended_price`, `win_probability`, `expected_margin`,
  ///   `low_price`, `high_price`, `predicted_cost`, `status`,
  ///   `reframe_status` (empty string for initial quotes), `best_score`
  Future<Map<String, dynamic>> predict(Map<String, dynamic> input) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    try {
      return _ml.modelsLoaded ? _mlPredict(input) : _formulaPredict(input);
    } catch (e) {
      return {'error': 'Calculation error: $e'};
    }
  }

  /// Constraint-Aware Optimizer — finds the best price that maximises
  /// score = win_probability × margin, subject to:
  ///   • margin ≥ kMinMargin   (hard floor — never violated)
  ///   • win_probability ≥ kMinWinProbability  (soft target)
  ///
  /// Returns `reframe_status`:
  ///   'success'     → both constraints satisfied by the best candidate
  ///   'constrained' → margin floor reached before win prob target;
  ///                   best available quote is still returned so the UI
  ///                   can show it alongside a warning
  Future<Map<String, dynamic>> reframe(
    Map<String, dynamic> input,
    double initialPrice,
    double predictedCost,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      return _ml.modelsLoaded
          ? _mlReframe(input, initialPrice, predictedCost)
          : _formulaReframe(input, initialPrice, predictedCost);
    } catch (e) {
      return {'error': 'Reframe error: $e'};
    }
  }

  // ── ML PATH ───────────────────────────────────────────────────────────

  Map<String, dynamic> _mlPredict(Map<String, dynamic> input) {
    final double distance = (input['distance'] ?? 100.0).toDouble();
    final double weight = (input['weight'] ?? 100.0).toDouble();
    final double deliveryTime = (input['delivery_time'] ?? 24.0).toDouble();
    final double vehicleEnc = _Encode.vehicle(input['vehicle'] ?? 'Car');
    final double weatherEnc = _Encode.weather(input['weather'] ?? 'Clear');
    final double categoryEnc = _Encode.category(input['category'] ?? 'General');

    final List<double> priceFeatures = [
      distance,
      vehicleEnc,
      weatherEnc,
      categoryEnc,
      weight,
      deliveryTime,
    ];
    final double? predictedCost = _ml.predictPrice(priceFeatures);
    if (predictedCost == null) return _formulaPredict(input);

    final double price = predictedCost * 1.20;

    final List<double> winFeatures = [
      distance,
      categoryEnc,
      weight,
      deliveryTime,
      price,
    ];
    final double winProb = _ml.predictWin(winFeatures) ?? 0.5;
    final double margin = (price - predictedCost) / price;

    return _buildResult(
      price: price,
      winProb: winProb,
      margin: margin,
      predictedCost: predictedCost,
      status: 'ml',
    );
  }

  Map<String, dynamic> _mlReframe(
    Map<String, dynamic> input,
    double initialPrice,
    double predictedCost,
  ) {
    final double distance = (input['distance'] ?? 100.0).toDouble();
    final double weight = (input['weight'] ?? 100.0).toDouble();
    final double deliveryTime = (input['delivery_time'] ?? 24.0).toDouble();
    final double categoryEnc = _Encode.category(input['category'] ?? 'General');

    // ── Best-score optimizer ──────────────────────────────────────────
    double bestPrice = initialPrice;
    double bestWinProb = 0.0;
    double bestMargin = 0.0;
    double bestScore = -double.infinity;
    int bestIter = 0;
    int iterations = 0;
    bool constraintsMet = false;
    bool anyCandidateSeen = false;

    double candidate = initialPrice;

    for (int i = 0; i < 20; i++) {
      iterations++;
      candidate = candidate * 0.97;
      final double margin = (candidate - predictedCost) / candidate;

      // Hard floor — never go below minimum margin
      if (margin < kMinMargin) break;

      anyCandidateSeen = true;

      final double winProb =
          _ml.predictWin([
            distance,
            categoryEnc,
            weight,
            deliveryTime,
            candidate,
          ]) ??
          bestWinProb;

      final double score = winProb * margin;

      if (score > bestScore) {
        bestScore = score;
        bestPrice = candidate;
        bestWinProb = winProb;
        bestMargin = margin;
        bestIter = iterations;
      }

      if (winProb >= kMinWinProbability && margin >= kMinMargin) {
        constraintsMet = true;
        // Keep scanning in case a slightly lower price scores better
        // (i.e., score continues to improve).  Stop only when win prob
        // is already strong and score starts falling.
        if (winProb >= kMinWinProbability + 0.05) break;
      }
    }

    // If no candidate passed the margin floor at all, keep initial values
    if (!anyCandidateSeen) {
      bestPrice = initialPrice;
      bestMargin = (initialPrice - predictedCost) / initialPrice;
      bestWinProb = 0.0;
    }

    final String reframeStatus = constraintsMet ? 'success' : 'constrained';

    return _buildResult(
      price: bestPrice,
      winProb: bestWinProb,
      margin: bestMargin,
      predictedCost: predictedCost,
      status: 'ml_reframed',
      iterations: bestIter,
      reframeStatus: reframeStatus,
      bestScore: bestScore < 0 ? 0 : bestScore,
    );
  }

  // ── FORMULA FALLBACK PATH ─────────────────────────────────────────────

  Map<String, dynamic> _formulaPredict(Map<String, dynamic> input) {
    final double weight = (input['weight'] ?? 100.0).toDouble();
    final double distance = (input['distance'] ?? 100.0).toDouble();
    final bool fragile = input['fragile'] ?? false;
    final bool peakSeason = input['peak_season'] ?? false;
    final String customerSegment = input['customer_segment'] ?? 'Standard';
    final String region = input['region'] ?? 'United States';
    final String category = input['category'] ?? 'General';

    double predictedCost = weight * 10.0 + distance * 0.5;
    if (fragile || category == 'Fragile') predictedCost *= 1.15;
    if (category == 'Electronics') predictedCost *= 1.10;
    if (category == 'Perishable') predictedCost *= 1.08;

    double price;
    double winProb;
    double margin;

    if (peakSeason) {
      price = predictedCost * 1.20;
      winProb = 0.82;
      margin = 0.22;
    } else if (customerSegment == 'Enterprise') {
      price = predictedCost * 1.10;
      winProb = 0.88;
      margin = 0.10;
    } else if (customerSegment == 'SMB') {
      price = predictedCost * 1.18;
      winProb = 0.55;
      margin = 0.16;
    } else {
      price = predictedCost * 1.20;
      winProb = 0.42;
      margin = 0.18;
    }

    // Region pricing adjustments
    if (region == 'Europe' || region == 'UK') {
      price *= 1.25;
      margin += 0.05;
    } else if (region == 'Japan' || region == 'Australia') {
      price *= 1.40;
      margin += 0.08;
    } else if (region == 'India' || region == 'China') {
      price *= 0.85;
      winProb = (winProb + 0.1).clamp(0.0, 1.0);
    } else if (region == 'Canada') {
      price *= 1.05;
    }

    return _buildResult(
      price: price,
      winProb: winProb,
      margin: margin,
      predictedCost: predictedCost,
      status: 'formula',
    );
  }

  Map<String, dynamic> _formulaReframe(
    Map<String, dynamic> input,
    double initialPrice,
    double predictedCost,
  ) {
    // ── Best-score optimizer (formula simulation) ─────────────────────
    // In formula mode, win probability improves ~5% per 3% price drop.
    final double baseWinProb = _formulaBaseWinProb(
      input['customer_segment'] ?? 'Standard',
    );

    double bestPrice = initialPrice;
    double bestWinProb = 0.0;
    double bestMargin = 0.0;
    double bestScore = -double.infinity;
    int bestIter = 0;
    int iterations = 0;
    bool constraintsMet = false;
    bool anyCandidateSeen = false;

    double candidate = initialPrice;
    double simulatedWinProb = baseWinProb;

    for (int i = 0; i < 20; i++) {
      iterations++;
      candidate = candidate * 0.97;
      final double margin = (candidate - predictedCost) / candidate;

      // Hard floor — never go below minimum margin
      if (margin < kMinMargin) break;

      anyCandidateSeen = true;
      simulatedWinProb = (simulatedWinProb + 0.05).clamp(0.0, 1.0);

      final double score = simulatedWinProb * margin;

      if (score > bestScore) {
        bestScore = score;
        bestPrice = candidate;
        bestWinProb = simulatedWinProb;
        bestMargin = margin;
        bestIter = iterations;
      }

      if (simulatedWinProb >= kMinWinProbability && margin >= kMinMargin) {
        constraintsMet = true;
        if (simulatedWinProb >= kMinWinProbability + 0.05) break;
      }
    }

    if (!anyCandidateSeen) {
      bestPrice = initialPrice;
      bestMargin = (initialPrice - predictedCost) / initialPrice;
      bestWinProb = baseWinProb;
    }

    final String reframeStatus = constraintsMet ? 'success' : 'constrained';

    return _buildResult(
      price: bestPrice,
      winProb: bestWinProb,
      margin: bestMargin,
      predictedCost: predictedCost,
      status: 'formula_reframed',
      iterations: bestIter,
      reframeStatus: reframeStatus,
      bestScore: bestScore < 0 ? 0 : bestScore,
    );
  }

  /// Returns the baseline win probability for a customer segment in formula mode.
  double _formulaBaseWinProb(String segment) {
    switch (segment) {
      case 'Enterprise':
        return 0.88;
      case 'SMB':
        return 0.55;
      default:
        return 0.42; // Standard
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  Map<String, dynamic> _buildResult({
    required double price,
    required double winProb,
    required double margin,
    required double predictedCost,
    required String status,
    int iterations = 0,
    String reframeStatus = '',
    double bestScore = 0.0,
  }) {
    return {
      'status': status,
      'recommended_price': double.parse(price.toStringAsFixed(2)),
      'win_probability': double.parse(winProb.toStringAsFixed(4)),
      'expected_margin': double.parse(margin.toStringAsFixed(4)),
      'predicted_cost': double.parse(predictedCost.toStringAsFixed(2)),
      'low_price': double.parse((price * 0.90).toStringAsFixed(2)),
      'high_price': double.parse((price * 1.10).toStringAsFixed(2)),
      'iterations': iterations,
      'reframe_status': reframeStatus,
      'best_score': double.parse(bestScore.toStringAsFixed(4)),
    };
  }
}
