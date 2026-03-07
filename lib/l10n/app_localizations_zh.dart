// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
