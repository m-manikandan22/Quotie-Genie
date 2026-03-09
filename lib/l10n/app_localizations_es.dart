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
  String get distanceKm => 'Distancia (km)';

  @override
  String get vehicleType => 'Tipo de vehículo';

  @override
  String get category => 'Categoría';

  @override
  String get deliveryTimeHrs => 'Tiempo de entrega (hrs)';

  @override
  String get weatherCondition => 'Condición meteorológica';

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
  String get confidenceBand => 'Banda de confianza';

  @override
  String get lowPrice => 'Bajo';

  @override
  String get optimalPrice => 'Óptimo';

  @override
  String get highPrice => 'Alto';

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
