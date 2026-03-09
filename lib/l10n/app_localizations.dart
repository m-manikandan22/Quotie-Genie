import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @newQuotePrediction.
  ///
  /// In en, this message translates to:
  /// **'New Quote Prediction'**
  String get newQuotePrediction;

  /// No description provided for @predictionHistory.
  ///
  /// In en, this message translates to:
  /// **'Prediction History'**
  String get predictionHistory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @shipmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Shipment Details'**
  String get shipmentDetails;

  /// No description provided for @autofillPeakSeason.
  ///
  /// In en, this message translates to:
  /// **'Autofill Peak Season'**
  String get autofillPeakSeason;

  /// No description provided for @autofillEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Autofill Enterprise'**
  String get autofillEnterprise;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get distanceKm;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @deliveryTimeHrs.
  ///
  /// In en, this message translates to:
  /// **'Delivery Time (hrs)'**
  String get deliveryTimeHrs;

  /// No description provided for @weatherCondition.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherCondition;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @historicalWinRate.
  ///
  /// In en, this message translates to:
  /// **'Historical Win Rate (0.0 to 1.0)'**
  String get historicalWinRate;

  /// No description provided for @customerSegment.
  ///
  /// In en, this message translates to:
  /// **'Customer Segment'**
  String get customerSegment;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @smb.
  ///
  /// In en, this message translates to:
  /// **'SMB'**
  String get smb;

  /// No description provided for @fragileShipment.
  ///
  /// In en, this message translates to:
  /// **'Fragile Shipment'**
  String get fragileShipment;

  /// No description provided for @peakSeasonFlag.
  ///
  /// In en, this message translates to:
  /// **'Peak Season Flag'**
  String get peakSeasonFlag;

  /// No description provided for @predictPricing.
  ///
  /// In en, this message translates to:
  /// **'Predict Pricing'**
  String get predictPricing;

  /// No description provided for @predicting.
  ///
  /// In en, this message translates to:
  /// **'Predicting...'**
  String get predicting;

  /// No description provided for @predictionResults.
  ///
  /// In en, this message translates to:
  /// **'Prediction Results'**
  String get predictionResults;

  /// No description provided for @profitableQuote.
  ///
  /// In en, this message translates to:
  /// **'Profitable Quote'**
  String get profitableQuote;

  /// No description provided for @lowMarginRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Margin Risk'**
  String get lowMarginRisk;

  /// No description provided for @winProbability.
  ///
  /// In en, this message translates to:
  /// **'Win Probability'**
  String get winProbability;

  /// No description provided for @recommendedPrice.
  ///
  /// In en, this message translates to:
  /// **'Recommended Price'**
  String get recommendedPrice;

  /// No description provided for @expectedMargin.
  ///
  /// In en, this message translates to:
  /// **'Expected Margin'**
  String get expectedMargin;

  /// No description provided for @confidenceBand.
  ///
  /// In en, this message translates to:
  /// **'Confidence Band'**
  String get confidenceBand;

  /// No description provided for @lowPrice.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowPrice;

  /// No description provided for @optimalPrice.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get optimalPrice;

  /// No description provided for @highPrice.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highPrice;

  /// No description provided for @initialQuote.
  ///
  /// In en, this message translates to:
  /// **'Initial Quote'**
  String get initialQuote;

  /// No description provided for @reframedQuote.
  ///
  /// In en, this message translates to:
  /// **'Reframed Quote'**
  String get reframedQuote;

  /// No description provided for @optimizedQuote.
  ///
  /// In en, this message translates to:
  /// **'Optimized Quote'**
  String get optimizedQuote;

  /// No description provided for @quoteNotCompetitive.
  ///
  /// In en, this message translates to:
  /// **'Quote May Not Be Competitive'**
  String get quoteNotCompetitive;

  /// No description provided for @reframeDescription.
  ///
  /// In en, this message translates to:
  /// **'Win probability is below 60% or margin is below 10%. Tap Reframe to let the optimizer find a better price.'**
  String get reframeDescription;

  /// No description provided for @reframeQuote.
  ///
  /// In en, this message translates to:
  /// **'Reframe Quote'**
  String get reframeQuote;

  /// No description provided for @optimizing.
  ///
  /// In en, this message translates to:
  /// **'Optimizing...'**
  String get optimizing;

  /// No description provided for @optimizationSummary.
  ///
  /// In en, this message translates to:
  /// **'Optimization Summary'**
  String get optimizationSummary;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @optimizerSteps.
  ///
  /// In en, this message translates to:
  /// **'Optimizer completed in {steps} step(s)'**
  String optimizerSteps(int steps);

  /// No description provided for @vehicleBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get vehicleBike;

  /// No description provided for @vehicleCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleCar;

  /// No description provided for @vehicleVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get vehicleVan;

  /// No description provided for @vehicleTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get vehicleTruck;

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @catElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get catElectronics;

  /// No description provided for @catFragile.
  ///
  /// In en, this message translates to:
  /// **'Fragile'**
  String get catFragile;

  /// No description provided for @catPerishable.
  ///
  /// In en, this message translates to:
  /// **'Perishable'**
  String get catPerishable;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// No description provided for @weatherFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherFoggy;

  /// No description provided for @aroundOptimal.
  ///
  /// In en, this message translates to:
  /// **'±10% around optimal price'**
  String get aroundOptimal;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No history found.'**
  String get noHistoryFound;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @margin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get margin;

  /// No description provided for @winProb.
  ///
  /// In en, this message translates to:
  /// **'Win Prob'**
  String get winProb;

  /// No description provided for @segment.
  ///
  /// In en, this message translates to:
  /// **'Segment'**
  String get segment;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @pythonError.
  ///
  /// In en, this message translates to:
  /// **'Python Error: {error}'**
  String pythonError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
