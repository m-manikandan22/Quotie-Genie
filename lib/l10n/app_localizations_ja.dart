// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get newQuotePrediction => 'New Quote Prediction';

  @override
  String get predictionHistory => 'Prediction History';

  @override
  String get settings => 'Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get region => 'Region';

  @override
  String get savePreferences => 'Save Preferences';

  @override
  String get shipmentDetails => 'Shipment Details';

  @override
  String get autofillPeakSeason => 'Autofill Peak Season';

  @override
  String get autofillEnterprise => 'Autofill Enterprise';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get distanceKm => '距離 (km)';

  @override
  String get vehicleType => '車両タイプ';

  @override
  String get category => 'カテゴリ';

  @override
  String get deliveryTimeHrs => '配送時間 (時間)';

  @override
  String get weatherCondition => '天気';

  @override
  String get requiredField => 'Required';

  @override
  String get historicalWinRate => 'Historical Win Rate (0.0 to 1.0)';

  @override
  String get customerSegment => 'Customer Segment';

  @override
  String get standard => 'Standard';

  @override
  String get enterprise => 'Enterprise';

  @override
  String get smb => 'SMB';

  @override
  String get fragileShipment => 'Fragile Shipment';

  @override
  String get peakSeasonFlag => 'Peak Season Flag';

  @override
  String get predictPricing => 'Predict Pricing';

  @override
  String get predicting => 'Predicting...';

  @override
  String get predictionResults => 'Prediction Results';

  @override
  String get profitableQuote => 'Profitable Quote';

  @override
  String get lowMarginRisk => 'Low Margin Risk';

  @override
  String get winProbability => 'Win Probability';

  @override
  String get recommendedPrice => 'Recommended Price';

  @override
  String get expectedMargin => 'Expected Margin';

  @override
  String get confidenceBand => '信頼バンド';

  @override
  String get lowPrice => '小';

  @override
  String get optimalPrice => '最適';

  @override
  String get highPrice => '高';

  @override
  String get initialQuote => 'Initial Quote';

  @override
  String get reframedQuote => 'Reframed Quote';

  @override
  String get optimizedQuote => 'Optimized Quote';

  @override
  String get quoteNotCompetitive => 'Quote May Not Be Competitive';

  @override
  String get reframeDescription =>
      'Win probability is below 60% or margin is below 10%. Tap Reframe to let the optimizer find a better price.';

  @override
  String get reframeQuote => 'Reframe Quote';

  @override
  String get optimizing => 'Optimizing...';

  @override
  String get optimizationSummary => 'Optimization Summary';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String optimizerSteps(int steps) {
    return 'Optimizer completed in $steps step(s)';
  }

  @override
  String get vehicleBike => 'Bike';

  @override
  String get vehicleCar => 'Car';

  @override
  String get vehicleVan => 'Van';

  @override
  String get vehicleTruck => 'Truck';

  @override
  String get catGeneral => 'General';

  @override
  String get catElectronics => 'Electronics';

  @override
  String get catFragile => 'Fragile';

  @override
  String get catPerishable => 'Perishable';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get weatherFoggy => 'Foggy';

  @override
  String get aroundOptimal => '±10% around optimal price';

  @override
  String get noHistoryFound => 'No history found.';

  @override
  String get price => 'Price';

  @override
  String get margin => 'Margin';

  @override
  String get winProb => 'Win Prob';

  @override
  String get segment => 'Segment';

  @override
  String get weight => 'Weight';

  @override
  String pythonError(String error) {
    return 'Python Error: $error';
  }
}
