// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get newQuotePrediction => 'Nueva predicción de cotización';

  @override
  String get predictionHistory => 'Historial de predicciones';

  @override
  String get settings => 'Configuraciones';

  @override
  String get preferences => 'Preferencias';

  @override
  String get language => 'Idioma';

  @override
  String get currency => 'Moneda';

  @override
  String get region => 'Región';

  @override
  String get savePreferences => 'Guardar preferencias';

  @override
  String get shipmentDetails => 'Detalles de envío';

  @override
  String get autofillPeakSeason => 'Autocompletar temporada alta';

  @override
  String get autofillEnterprise => 'Autocompletar corporativo';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get requiredField => 'Requerido';

  @override
  String get historicalWinRate => 'Tasa de ganancia histórica (0.0 a 1.0)';

  @override
  String get customerSegment => 'Segmento de clientes';

  @override
  String get standard => 'Estándar';

  @override
  String get enterprise => 'Empresa';

  @override
  String get smb => 'PyME';

  @override
  String get fragileShipment => 'Envío frágil';

  @override
  String get peakSeasonFlag => 'Bandera de temporada alta';

  @override
  String get predictPricing => 'Predecir precios';

  @override
  String get predicting => 'Prediciendo...';

  @override
  String get predictionResults => 'Resultados de la predicción';

  @override
  String get profitableQuote => 'Cotización rentable';

  @override
  String get lowMarginRisk => 'Riesgo de bajo margen';

  @override
  String get winProbability => 'Probabilidad de ganar';

  @override
  String get recommendedPrice => 'Precio recomendado';

  @override
  String get expectedMargin => 'Margen esperado';

  @override
  String get noHistoryFound => 'No se encontró historial.';

  @override
  String get price => 'Precio';

  @override
  String get margin => 'Margen';

  @override
  String get winProb => 'Prob. de ganar';

  @override
  String get segment => 'Segmento';

  @override
  String get weight => 'Peso';

  @override
  String pythonError(String error) {
    return 'Error: $error';
  }
}
