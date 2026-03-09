import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'prediction_screen.dart';
import 'history_screen.dart';
import '../services/settings_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PredictionScreen(hideAppBar: true),
    const HistoryScreen(hideAppBar: true),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label:
                AppLocalizations.of(context)?.predictPricing.split(' ').first ??
                'Predict',
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label:
                AppLocalizations.of(
                  context,
                )?.predictionHistory.split(' ').last ??
                'History',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)?.settings ?? 'Settings',
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _lang;
  late String _curr;
  late String _reg;

  final languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Hindi',
    'Chinese',
    'Japanese',
  ];
  final currencies = ['\$', '€', '£', '¥', '₹', 'A\$', 'C\$'];
  final regions = [
    'United States',
    'Europe',
    'UK',
    'Japan',
    'India',
    'Australia',
    'Canada',
  ];

  @override
  void initState() {
    super.initState();
    final s = SettingsService();
    _lang = s.language;
    _curr = s.currency;
    _reg = s.region;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)?.preferences ?? 'Preferences',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: languages.contains(_lang) ? _lang : 'English',
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.language ?? 'Language',
              border: const OutlineInputBorder(),
            ),
            items: languages
                .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                .toList(),
            onChanged: (v) => setState(() => _lang = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: currencies.contains(_curr) ? _curr : '\$',
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.currency ?? 'Currency',
              border: const OutlineInputBorder(),
            ),
            items: currencies
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _curr = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: regions.contains(_reg) ? _reg : 'United States',
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)?.region ?? 'Region',
              border: const OutlineInputBorder(),
            ),
            items: regions
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (v) => setState(() => _reg = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              SettingsService().updateSettings(
                language: _lang,
                currency: _curr,
                region: _reg,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)?.savePreferences ?? 'Saved',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)?.savePreferences ??
                  'Save Preferences',
            ),
          ),
        ],
      ),
    );
  }
}
