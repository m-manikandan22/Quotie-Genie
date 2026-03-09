import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/pricing_engine.dart';
import '../services/settings_service.dart';
import '../services/currency_converter.dart';
import '../services/database_helper.dart';

class PredictionScreen extends StatefulWidget {
  final bool hideAppBar;
  const PredictionScreen({super.key, this.hideAppBar = false});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Input controllers ──────────────────────────────────────────────────
  final _weightController = TextEditingController(text: '100');
  final _distanceController = TextEditingController(text: '100');
  final _deliveryTimeController = TextEditingController(text: '24');

  String _vehicleType = 'Car';
  String _category = 'General';
  String _weather = 'Clear';
  String _customerSegment = 'Standard';
  bool _isFragile = false;
  bool _isPeakSeason = false;

  // ── State ──────────────────────────────────────────────────────────────
  bool _isPredicting = false;
  bool _isReframing = false;
  Map<String, dynamic>? _initialResult;
  Map<String, dynamic>? _reframedResult;

  static const double _winThreshold = kMinWinProbability;
  static const double _marginThreshold = kMinMargin;

  // ── Currency helpers ───────────────────────────────────────────────────
  String get _sym => SettingsService().currency;

  double _convert(double inr) => CurrencyConverter.fromINR(inr, _sym);

  String _fmt(double inr) {
    final converted = _convert(inr);
    // Use compact decimal digits for currencies with large rates (e.g. JPY)
    final decimals = _sym == '¥' ? 0 : 2;
    return NumberFormat.currency(
      symbol: _sym,
      decimalDigits: decimals,
    ).format(converted);
  }

  AppLocalizations? get _l10n => AppLocalizations.of(context);

  @override
  void dispose() {
    _weightController.dispose();
    _distanceController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  // ── Localized dropdown items ───────────────────────────────────────────
  List<DropdownMenuItem<String>> _vehicleItems(AppLocalizations? l) => [
    DropdownMenuItem(value: 'Bike', child: Text(l?.vehicleBike ?? 'Bike')),
    DropdownMenuItem(value: 'Car', child: Text(l?.vehicleCar ?? 'Car')),
    DropdownMenuItem(value: 'Van', child: Text(l?.vehicleVan ?? 'Van')),
    DropdownMenuItem(value: 'Truck', child: Text(l?.vehicleTruck ?? 'Truck')),
  ];

  List<DropdownMenuItem<String>> _categoryItems(AppLocalizations? l) => [
    DropdownMenuItem(value: 'General', child: Text(l?.catGeneral ?? 'General')),
    DropdownMenuItem(
      value: 'Electronics',
      child: Text(l?.catElectronics ?? 'Electronics'),
    ),
    DropdownMenuItem(value: 'Fragile', child: Text(l?.catFragile ?? 'Fragile')),
    DropdownMenuItem(
      value: 'Perishable',
      child: Text(l?.catPerishable ?? 'Perishable'),
    ),
  ];

  List<DropdownMenuItem<String>> _weatherItems(AppLocalizations? l) => [
    DropdownMenuItem(value: 'Clear', child: Text(l?.weatherClear ?? 'Clear')),
    DropdownMenuItem(value: 'Rainy', child: Text(l?.weatherRainy ?? 'Rainy')),
    DropdownMenuItem(value: 'Foggy', child: Text(l?.weatherFoggy ?? 'Foggy')),
  ];

  List<DropdownMenuItem<String>> _segmentItems(AppLocalizations? l) => [
    DropdownMenuItem(value: 'Standard', child: Text(l?.standard ?? 'Standard')),
    DropdownMenuItem(
      value: 'Enterprise',
      child: Text(l?.enterprise ?? 'Enterprise'),
    ),
    DropdownMenuItem(value: 'SMB', child: Text(l?.smb ?? 'SMB')),
  ];

  // ── Auto-fill presets ──────────────────────────────────────────────────
  void _autofill(String useCase) {
    setState(() {
      if (useCase == 'A') {
        _weightController.text = '500';
        _distanceController.text = '350';
        _deliveryTimeController.text = '12';
        _isFragile = true;
        _isPeakSeason = true;
        _customerSegment = 'Standard';
        _vehicleType = 'Truck';
        _category = 'Fragile';
        _weather = 'Rainy';
      } else {
        _weightController.text = '1000';
        _distanceController.text = '200';
        _deliveryTimeController.text = '48';
        _isFragile = false;
        _isPeakSeason = false;
        _customerSegment = 'Enterprise';
        _vehicleType = 'Truck';
        _category = 'General';
        _weather = 'Clear';
      }
    });
  }

  Map<String, dynamic> get _inputData => {
    'weight': double.tryParse(_weightController.text) ?? 100.0,
    'distance': double.tryParse(_distanceController.text) ?? 100.0,
    'delivery_time': double.tryParse(_deliveryTimeController.text) ?? 24.0,
    'vehicle': _vehicleType,
    'category': _category,
    'weather': _weather,
    'customer_segment': _customerSegment,
    'fragile': _isFragile,
    'peak_season': _isPeakSeason,
    'region': SettingsService().region,
  };

  // ── Predict initial quote ──────────────────────────────────────────────
  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isPredicting = true;
      _initialResult = null;
      _reframedResult = null;
    });
    final result = await PricingEngine().predict(_inputData);
    if (result.containsKey('error') && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${result["error"]}')));
    } else {
      setState(() => _initialResult = result);
      await _saveToHistory(result);
    }
    setState(() => _isPredicting = false);
  }

  // ── Reframe quote ──────────────────────────────────────────────────────
  Future<void> _reframe() async {
    if (_initialResult == null) return;
    setState(() {
      _isReframing = true;
      _reframedResult = null;
    });
    final result = await PricingEngine().reframe(
      _inputData,
      (_initialResult!['recommended_price'] as num).toDouble(),
      (_initialResult!['predicted_cost'] as num).toDouble(),
    );
    if (result.containsKey('error') && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${result["error"]}')));
    } else {
      setState(() => _reframedResult = result);
      await _saveToHistory(result);
    }
    setState(() => _isReframing = false);
  }

  Future<void> _saveToHistory(Map<String, dynamic> result) async {
    await DatabaseHelper().insertPrediction({
      'timestamp': DateTime.now().toIso8601String(),
      'weight': _inputData['weight'],
      'fragile': _isFragile ? 1 : 0,
      'peak_season': _isPeakSeason ? 1 : 0,
      'customer_segment': _customerSegment,
      'historical_win_rate': 0.0,
      'win_probability': result['win_probability'],
      'recommended_price': result['recommended_price'],
      'expected_margin': result['expected_margin'],
    });
  }

  bool _isWeakQuote(Map<String, dynamic> r) =>
      (r['win_probability'] as num).toDouble() < _winThreshold ||
      (r['expected_margin'] as num).toDouble() < _marginThreshold;

  // ══════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final l = _l10n;
    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: Text(l?.newQuotePrediction ?? 'New Quote Prediction'),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(l),
                const SizedBox(height: 16),
                _buildInputForm(l),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _initialResult != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildSectionTitle(
                              l?.initialQuote ?? 'Initial Quote',
                            ),
                            const SizedBox(height: 12),
                            _buildResultCard(l, _initialResult!),
                            if (_isWeakQuote(_initialResult!)) ...[
                              const SizedBox(height: 16),
                              _buildWeakQuoteWarning(l),
                            ],
                            if (_reframedResult != null) ...[
                              const SizedBox(height: 32),
                              _buildSectionTitle(
                                _reframedResult!['reframe_status'] ==
                                        'constrained'
                                    ? (l?.reframedQuote ?? 'Reframed Quote')
                                    : (l?.reframedQuote ?? 'Reframed Quote'),
                              ),
                              const SizedBox(height: 12),
                              if (_reframedResult!['reframe_status'] ==
                                  'constrained')
                                _buildConstrainedWarningCard(
                                  l,
                                  _reframedResult!,
                                )
                              else
                                _buildResultCard(
                                  l,
                                  _reframedResult!,
                                  isReframed: true,
                                ),
                              const SizedBox(height: 16),
                              _buildComparisonRow(l),
                            ],
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(AppLocalizations? l) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        Text(
          l?.shipmentDetails ?? 'Shipment Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: Text(
                l?.autofillPeakSeason ?? 'Autofill Peak',
                style: const TextStyle(fontSize: 12),
              ),
              onPressed: () => _autofill('A'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.corporate_fare, size: 18),
              label: Text(
                l?.autofillEnterprise ?? 'Autofill Enterprise',
                style: const TextStyle(fontSize: 12),
              ),
              onPressed: () => _autofill('B'),
            ),
          ],
        ),
      ],
    );
  }

  // ── Input form ─────────────────────────────────────────────────────────
  Widget _buildInputForm(AppLocalizations? l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildRow([
                _buildNumberField(
                  _weightController,
                  l?.weightKg ?? 'Weight (kg)',
                  Icons.scale_outlined,
                ),
                _buildNumberField(
                  _distanceController,
                  l?.distanceKm ?? 'Distance (km)',
                  Icons.straighten_outlined,
                ),
              ]),
              const SizedBox(height: 16),
              _buildRow([
                _buildDropdown(
                  value: _vehicleType,
                  label: l?.vehicleType ?? 'Vehicle Type',
                  icon: Icons.local_shipping_outlined,
                  items: _vehicleItems(l),
                  onChanged: (v) => setState(() => _vehicleType = v!),
                ),
                _buildDropdown(
                  value: _category,
                  label: l?.category ?? 'Category',
                  icon: Icons.category_outlined,
                  items: _categoryItems(l),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ]),
              const SizedBox(height: 16),
              _buildRow([
                _buildNumberField(
                  _deliveryTimeController,
                  l?.deliveryTimeHrs ?? 'Delivery Time (hrs)',
                  Icons.timer_outlined,
                ),
                _buildDropdown(
                  value: _weather,
                  label: l?.weatherCondition ?? 'Weather',
                  icon: Icons.cloud_outlined,
                  items: _weatherItems(l),
                  onChanged: (v) => setState(() => _weather = v!),
                ),
              ]),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _customerSegment,
                label: l?.customerSegment ?? 'Customer Segment',
                icon: Icons.business_outlined,
                items: _segmentItems(l),
                onChanged: (v) => setState(() => _customerSegment = v!),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: Text(
                        l?.fragileShipment ?? 'Fragile',
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: _isFragile,
                      onChanged: (v) => setState(() => _isFragile = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: Text(
                        l?.peakSeasonFlag ?? 'Peak Season',
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: _isPeakSeason,
                      onChanged: (v) => setState(() => _isPeakSeason = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isPredicting ? null : _predict,
                  icon: _isPredicting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.analytics),
                  label: Text(
                    _isPredicting
                        ? (l?.predicting ?? 'Predicting...')
                        : (l?.predictPricing ?? 'Predict Quote'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Weak quote warning + Reframe button ───────────────────────────────
  Widget _buildWeakQuoteWarning(AppLocalizations? l) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade800,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l?.quoteNotCompetitive ??
                            'Quote May Not Be Competitive',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l?.reframeDescription ??
                            'Win probability < 60% or margin < 10%. Tap Reframe to find a better price.',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange.shade700, width: 1.5),
                  foregroundColor: Colors.orange.shade900,
                ),
                onPressed: _isReframing ? null : _reframe,
                icon: _isReframing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.orange.shade700,
                        ),
                      )
                    : const Icon(Icons.tune),
                label: Text(
                  _isReframing
                      ? (l?.optimizing ?? 'Optimizing...')
                      : (l?.reframeQuote ?? 'Reframe Quote'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Result card ────────────────────────────────────────────────────────
  Widget _buildResultCard(
    AppLocalizations? l,
    Map<String, dynamic> result, {
    bool isReframed = false,
  }) {
    final double margin = (result['expected_margin'] as num).toDouble();
    final double priceINR = (result['recommended_price'] as num).toDouble();
    final double winProb = (result['win_probability'] as num).toDouble();
    final double lowINR = (result['low_price'] as num).toDouble();
    final double highINR = (result['high_price'] as num).toDouble();

    final bool isCompetitive =
        winProb >= _winThreshold && margin >= _marginThreshold;
    final bool isProfitable = margin >= 0.15;

    Color cardColor;
    Color iconColor;
    IconData headerIcon;
    String headerText;

    if (isReframed && isCompetitive) {
      cardColor = Colors.green.shade100;
      iconColor = Colors.green.shade800;
      headerIcon = Icons.check_circle;
      headerText = l?.optimizedQuote ?? 'Optimized Quote';
    } else if (isProfitable) {
      cardColor = Colors.green.shade100;
      iconColor = Colors.green.shade800;
      headerIcon = Icons.check_circle;
      headerText = l?.profitableQuote ?? 'Profitable Quote';
    } else {
      cardColor = Colors.red.shade100;
      iconColor = Colors.red.shade800;
      headerIcon = Icons.warning;
      headerText = l?.lowMarginRisk ?? 'Low Margin Risk';
    }

    return Column(
      children: [
        Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(headerIcon, color: iconColor, size: 36),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        headerText,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 36),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    _buildStat(
                      l?.winProbability ?? 'Win Probability',
                      '${(winProb * 100).toStringAsFixed(1)}%',
                      winProb >= _winThreshold
                          ? Colors.green.shade800
                          : Colors.red.shade700,
                    ),
                    _buildStat(
                      l?.recommendedPrice ?? 'Recommended Price',
                      _fmt(priceINR), // ← currency-converted
                      Colors.black87,
                    ),
                    _buildStat(
                      l?.expectedMargin ?? 'Expected Margin',
                      '${(margin * 100).toStringAsFixed(1)}%',
                      margin >= kMinMargin
                          ? Colors.green.shade800
                          : Colors.red.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildConfidenceBand(l, lowINR, priceINR, highINR, iconColor),
      ],
    );
  }

  // ── Before / After comparison ──────────────────────────────────────────
  Widget _buildComparisonRow(AppLocalizations? l) {
    if (_initialResult == null || _reframedResult == null) {
      return const SizedBox();
    }
    final oldINR = (_initialResult!['recommended_price'] as num).toDouble();
    final newINR = (_reframedResult!['recommended_price'] as num).toDouble();
    final oldWin = (_initialResult!['win_probability'] as num).toDouble();
    final newWin = (_reframedResult!['win_probability'] as num).toDouble();
    final oldMargin = (_initialResult!['expected_margin'] as num).toDouble();
    final newMargin = (_reframedResult!['expected_margin'] as num).toDouble();
    final steps = _reframedResult!['iterations'] as int;
    final bool isConstrained =
        _reframedResult!['reframe_status'] == 'constrained';

    final Color afterColor = isConstrained
        ? Colors.orange.shade700
        : Colors.green.shade700;

    final double marginDelta = newMargin - oldMargin;
    final String marginDeltaStr =
        '${marginDelta >= 0 ? '+' : ''}${(marginDelta * 100).toStringAsFixed(1)}%';
    final Color marginDeltaColor = marginDelta >= 0
        ? Colors.green.shade700
        : Colors.red.shade700;

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l?.optimizationSummary ?? 'Optimization Summary',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompCol(
                  l?.before ?? 'Before',
                  _fmt(oldINR),
                  '${(oldWin * 100).toStringAsFixed(0)}% win',
                  Colors.red.shade700,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                _buildCompCol(
                  l?.after ?? 'After',
                  _fmt(newINR),
                  '${(newWin * 100).toStringAsFixed(0)}% win',
                  afterColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Margin delta badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.trending_down, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Margin: ${(oldMargin * 100).toStringAsFixed(1)}% → '
                  '${(newMargin * 100).toStringAsFixed(1)}%  ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  marginDeltaStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: marginDeltaColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l?.optimizerSteps(steps) ??
                  'Optimizer completed in $steps step(s)',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ── Constrained Warning Card ───────────────────────────────────────────
  /// Shown when the optimizer cannot achieve both win-prob ≥ 60% and
  /// margin ≥ 10% simultaneously.  Displays the best-available quote
  /// alongside a clear amber warning and manual-negotiation advice.
  Widget _buildConstrainedWarningCard(
    AppLocalizations? l,
    Map<String, dynamic> result,
  ) {
    final double price = (result['recommended_price'] as num).toDouble();
    final double winProb = (result['win_probability'] as num).toDouble();
    final double margin = (result['expected_margin'] as num).toDouble();
    final bool marginOk = margin >= kMinMargin;
    final bool winOk = winProb >= kMinWinProbability;

    return Card(
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade700, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber.shade800,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Reframe Not Possible',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Competitive pricing would reduce margin below the '
              '${(kMinMargin * 100).toStringAsFixed(0)}% safe threshold.',
              style: TextStyle(color: Colors.amber.shade800, fontSize: 13),
            ),
            const Divider(height: 28),
            // ── Best available stats ─────────────────────────────────────
            Text(
              'Best Available Quote',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: 16,
              spacing: 16,
              children: [
                _buildStat(
                  l?.winProbability ?? 'Win Probability',
                  '${(winProb * 100).toStringAsFixed(1)}%',
                  winOk ? Colors.green.shade800 : Colors.red.shade700,
                ),
                _buildStat(
                  l?.recommendedPrice ?? 'Best Price',
                  _fmt(price),
                  Colors.black87,
                ),
                _buildStat(
                  l?.expectedMargin ?? 'Margin',
                  '${(margin * 100).toStringAsFixed(1)}%',
                  marginOk ? Colors.green.shade800 : Colors.red.shade700,
                ),
              ],
            ),
            const Divider(height: 28),
            // ── Manual negotiation advice ───────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.handshake_outlined,
                    color: Colors.amber.shade900,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Consider manual negotiation with the customer '
                      'to agree on a mutually acceptable price.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompCol(String label, String price, String win, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          price,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          win,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Confidence Band ────────────────────────────────────────────────────
  Widget _buildConfidenceBand(
    AppLocalizations? l,
    double lowINR,
    double optimalINR,
    double highINR,
    Color accentColor,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, size: 18, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  l?.confidenceBand ?? 'Confidence Band',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bandLabel(
                  l?.lowPrice ?? 'Low',
                  _fmt(lowINR),
                  Colors.orange.shade700,
                  CrossAxisAlignment.start,
                ),
                _bandLabel(
                  l?.optimalPrice ?? 'Optimal',
                  _fmt(optimalINR),
                  accentColor,
                  CrossAxisAlignment.center,
                ),
                _bandLabel(
                  l?.highPrice ?? 'High',
                  _fmt(highINR),
                  Colors.blueGrey.shade600,
                  CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade200,
                      accentColor.withValues(alpha: 0.7),
                      Colors.blueGrey.shade200,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                l?.aroundOptimal ?? '±10% around optimal price',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Small helpers ──────────────────────────────────────────────────────
  Widget _buildSectionTitle(String t) =>
      Text(t, style: Theme.of(context).textTheme.titleLarge);

  Widget _buildRow(List<Widget> children) {
    return Row(
      children:
          children
              .expand((w) => [Expanded(child: w), const SizedBox(width: 16)])
              .toList()
            ..removeLast(),
    );
  }

  Widget _buildNumberField(
    TextEditingController ctrl,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      validator: (v) =>
          v!.isEmpty ? (_l10n?.requiredField ?? 'Required') : null,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        isDense: true,
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _bandLabel(
    String label,
    String value,
    Color color,
    CrossAxisAlignment align,
  ) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
