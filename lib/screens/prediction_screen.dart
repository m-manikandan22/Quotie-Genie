import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/pricing_engine.dart';
import '../services/settings_service.dart';
import '../services/database_helper.dart';

class PredictionScreen extends StatefulWidget {
  final bool hideAppBar;
  const PredictionScreen({super.key, this.hideAppBar = false});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _weightController = TextEditingController(text: '100');
  final _winRateController = TextEditingController(text: '0.5');
  
  bool _isFragile = false;
  bool _isPeakSeason = false;
  String _customerSegment = 'Standard';
  
  bool _isLoading = false;
  Map<String, dynamic>? _predictionResult;

  void _autofill(String useCase) {
    setState(() {
      if (useCase == 'A') { // Peak season
        _weightController.text = '500';
        _isFragile = true;
        _isPeakSeason = true;
        _customerSegment = 'Standard';
        _winRateController.text = '0.4';
      } else if (useCase == 'B') { // Enterprise
        _weightController.text = '1000';
        _isFragile = false;
        _isPeakSeason = false;
        _customerSegment = 'Enterprise';
        _winRateController.text = '0.9';
      }
    });
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    final inputData = {
      "weight": double.tryParse(_weightController.text) ?? 100.0,
      "fragile": _isFragile,
      "peak_season": _isPeakSeason,
      "customer_segment": _customerSegment,
      "historical_win_rate": double.tryParse(_winRateController.text) ?? 0.5,
      "region": SettingsService().region,
    };

    final result = await PricingEngine().predict(inputData);
    
    if (result.containsKey('error')) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.pythonError(result["error"].toString()) ?? 'Python Error: ${result["error"]}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } else {
      setState(() {
        _predictionResult = result;
      });
      
      // Save to history
      final historyData = {
        'timestamp': DateTime.now().toIso8601String(),
        'weight': inputData['weight'],
        'fragile': inputData['fragile'] == true ? 1 : 0,
        'peak_season': inputData['peak_season'] == true ? 1 : 0,
        'customer_segment': inputData['customer_segment'],
        'historical_win_rate': inputData['historical_win_rate'],
        'win_probability': result['win_probability'],
        'recommended_price': result['recommended_price'],
        'expected_margin': result['expected_margin'],
      };
      await DatabaseHelper().insertPrediction(historyData);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar ? null : AppBar(title: Text(AppLocalizations.of(context)?.newQuotePrediction ?? 'New Quote Prediction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Text(AppLocalizations.of(context)?.shipmentDetails ?? 'Shipment Details', style: Theme.of(context).textTheme.titleLarge),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.auto_awesome, size: 18),
                          label: Text(AppLocalizations.of(context)?.autofillPeakSeason ?? 'Autofill Peak Season', style: const TextStyle(fontSize: 12)),
                          onPressed: () => _autofill('A'),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.corporate_fare, size: 18),
                          label: Text(AppLocalizations.of(context)?.autofillEnterprise ?? 'Autofill Enterprise', style: const TextStyle(fontSize: 12)),
                          onPressed: () => _autofill('B'),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _weightController,
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)?.weightKg ?? 'Weight (kg)', border: const OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? (AppLocalizations.of(context)?.requiredField ?? 'Required') : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _winRateController,
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)?.historicalWinRate ?? 'Historical Win Rate', border: const OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? (AppLocalizations.of(context)?.requiredField ?? 'Required') : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _customerSegment,
                            decoration: InputDecoration(labelText: AppLocalizations.of(context)?.customerSegment ?? 'Customer Segment', border: const OutlineInputBorder()),
                            items: [
                              DropdownMenuItem(value: 'Standard', child: Text(AppLocalizations.of(context)?.standard ?? 'Standard')),
                              DropdownMenuItem(value: 'Enterprise', child: Text(AppLocalizations.of(context)?.enterprise ?? 'Enterprise')),
                              DropdownMenuItem(value: 'SMB', child: Text(AppLocalizations.of(context)?.smb ?? 'SMB')),
                            ],
                            onChanged: (v) => setState(() => _customerSegment = v!),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(AppLocalizations.of(context)?.fragileShipment ?? 'Fragile Shipment'),
                            value: _isFragile,
                            onChanged: (v) => setState(() => _isFragile = v),
                          ),
                          SwitchListTile(
                            title: Text(AppLocalizations.of(context)?.peakSeasonFlag ?? 'Peak Season Flag'),
                            value: _isPeakSeason,
                            onChanged: (v) => setState(() => _isPeakSeason = v),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton.icon(
                              onPressed: _isLoading ? null : _predict,
                              icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.analytics),
                              label: Text(_isLoading ? (AppLocalizations.of(context)?.predicting ?? 'Predicting...') : (AppLocalizations.of(context)?.predictPricing ?? 'Predict Pricing')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _predictionResult != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Text(AppLocalizations.of(context)?.predictionResults ?? 'Prediction Results', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            _buildResultCard(),
                          ],
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final margin = (_predictionResult!['expected_margin'] as num).toDouble();
    final price = (_predictionResult!['recommended_price'] as num).toDouble();
    final winProb = (_predictionResult!['win_probability'] as num).toDouble();
    
    final isProfitable = margin >= 0.15;
    final color = isProfitable ? Colors.green.shade100 : Colors.red.shade100;
    final iconColor = isProfitable ? Colors.green.shade800 : Colors.red.shade800;
    
    final currencySymbol = SettingsService().currency;
    final currencyFormatter = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 2);

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isProfitable ? Icons.check_circle : Icons.warning, color: iconColor, size: 40),
                const SizedBox(width: 16),
                Text(
                  isProfitable ? (AppLocalizations.of(context)?.profitableQuote ?? 'Profitable Quote') : (AppLocalizations.of(context)?.lowMarginRisk ?? 'Low Margin Risk'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: iconColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 40),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: 16,
              spacing: 16,
              children: [
                _buildStat(AppLocalizations.of(context)?.winProbability ?? 'Win Probability', '${(winProb * 100).toStringAsFixed(1)}%'),
                _buildStat(AppLocalizations.of(context)?.recommendedPrice ?? 'Recommended Price', currencyFormatter.format(price)),
                _buildStat(AppLocalizations.of(context)?.expectedMargin ?? 'Expected Margin', '${(margin * 100).toStringAsFixed(1)}%'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
