// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get newQuotePrediction => 'Nouvelle prédiction de devis';

  @override
  String get predictionHistory => 'Historique des prédictions';

  @override
  String get settings => 'Paramètres';

  @override
  String get preferences => 'Préférences';

  @override
  String get language => 'Langue';

  @override
  String get currency => 'Devise';

  @override
  String get region => 'Région';

  @override
  String get savePreferences => 'Sauvegarder les préférences';

  @override
  String get shipmentDetails => 'Détails de l\'expédition';

  @override
  String get autofillPeakSeason => 'Remplissage saison haute';

  @override
  String get autofillEnterprise => 'Remplissage entreprise';

  @override
  String get weightKg => 'Poids (kg)';

  @override
  String get distanceKm => 'Distance (km)';

  @override
  String get vehicleType => 'Type de véhicule';

  @override
  String get category => 'Catégorie';

  @override
  String get deliveryTimeHrs => 'Délai de livraison (hrs)';

  @override
  String get weatherCondition => 'Météo';

  @override
  String get requiredField => 'Requis';

  @override
  String get historicalWinRate => 'Taux de victoire historique (0.0 à 1.0)';

  @override
  String get customerSegment => 'Segment de clientèle';

  @override
  String get standard => 'Standard';

  @override
  String get enterprise => 'Entreprise';

  @override
  String get smb => 'PME';

  @override
  String get fragileShipment => 'Expédition fragile';

  @override
  String get peakSeasonFlag => 'Indicateur de saison haute';

  @override
  String get predictPricing => 'Prédire le prix';

  @override
  String get predicting => 'Prédiction...';

  @override
  String get predictionResults => 'Résultats de la prédiction';

  @override
  String get profitableQuote => 'Devis rentable';

  @override
  String get lowMarginRisk => 'Risque de faible marge';

  @override
  String get winProbability => 'Probabilité de victoire';

  @override
  String get recommendedPrice => 'Prix recommandé';

  @override
  String get expectedMargin => 'Marge prévue';

  @override
  String get confidenceBand => 'Bande de confiance';

  @override
  String get lowPrice => 'Bas';

  @override
  String get optimalPrice => 'Optimal';

  @override
  String get highPrice => 'Haut';

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
  String get noHistoryFound => 'Aucun historique trouvé.';

  @override
  String get price => 'Prix';

  @override
  String get margin => 'Marge';

  @override
  String get winProb => 'Prob. de vic';

  @override
  String get segment => 'Segment';

  @override
  String get weight => 'Poids';

  @override
  String pythonError(String error) {
    return 'Erreur: $error';
  }
}
