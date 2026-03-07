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
