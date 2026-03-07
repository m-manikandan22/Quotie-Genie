import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';

class HistoryScreen extends StatefulWidget {
  final bool hideAppBar;
  const HistoryScreen({super.key, this.hideAppBar = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = DatabaseHelper().getPredictions();
    });
  }

  Future<void> _deleteRecord(int id) async {
    await DatabaseHelper().deletePrediction(id);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: SettingsService().currency, decimalDigits: 2);

    return Scaffold(
      appBar: widget.hideAppBar ? null : AppBar(title: Text(AppLocalizations.of(context)?.predictionHistory ?? 'Prediction History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)?.noHistoryFound ?? 'No history found.'));
          }

          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final date = DateTime.parse(record['timestamp']);
              final formattedDate = DateFormat('MMM d, yyyy - h:mm a').format(date);
              
              final price = (record['recommended_price'] as num).toDouble();
              final margin = (record['expected_margin'] as num).toDouble();
              final winProb = (record['win_probability'] as num).toDouble();
              
              final isProfitable = margin >= 0.15;
              final iconColor = isProfitable ? Colors.green : Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: iconColor.withOpacity(0.2),
                    child: Icon(isProfitable ? Icons.trending_up : Icons.trending_down, color: iconColor),
                  ),
                  title: Text('${AppLocalizations.of(context)?.price ?? "Price"}: ${currencyFormatter.format(price)} (${AppLocalizations.of(context)?.margin ?? "Margin"}: ${(margin * 100).toStringAsFixed(1)}%)'),
                  subtitle: Text('${AppLocalizations.of(context)?.winProb ?? "Win Prob"}: ${(winProb * 100).toStringAsFixed(1)}% | $formattedDate\n${AppLocalizations.of(context)?.segment ?? "Segment"}: ${record["customer_segment"]} | ${AppLocalizations.of(context)?.weight ?? "Weight"}: ${record["weight"]}kg'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => _deleteRecord(record['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
