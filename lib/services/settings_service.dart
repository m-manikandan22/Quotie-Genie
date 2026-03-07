import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;

  String _language = 'English';
  String _currency = '\$';
  String _region = 'United States';

  String get language => _language;
  String get currency => _currency;
  String get region => _region;

  Locale get locale {
    switch (_language) {
      case 'Spanish':
        return const Locale('es');
      case 'French':
        return const Locale('fr');
      case 'German':
        return const Locale('de');
      case 'Hindi':
        return const Locale('hi');
      case 'Chinese':
        return const Locale('zh');
      case 'Japanese':
        return const Locale('ja');
      case 'English':
      default:
        return const Locale('en');
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _language = _prefs.getString('language') ?? 'English';
    _currency = _prefs.getString('currency') ?? '\$';
    _region = _prefs.getString('region') ?? 'United States';
    notifyListeners();
  }

  Future<void> updateSettings({
    String? language,
    String? currency,
    String? region,
  }) async {
    if (language != null) {
      _language = language;
      await _prefs.setString('language', language);
    }
    if (currency != null) {
      _currency = currency;
      await _prefs.setString('currency', currency);
    }
    if (region != null) {
      _region = region;
      await _prefs.setString('region', region);
    }
    notifyListeners();
  }
}
