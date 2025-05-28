import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/local_storage_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final loaded = await LocalStorageService.loadScores();
    setState(() {
      scores = loaded.reversed.toList(); // most recent first
    });
  }

  Future<void> _clearScores() async {
    await LocalStorageService.clearScores();
    _loadScores();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.leaderboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearScores,
            tooltip: loc.resetLeaderboard,
          ),
        ],
      ),
      body: scores.isEmpty
          ? Center(child: Text(loc.noScores))
          : ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          final s = scores[index];
          return ListTile(
            title: Text("${loc.category}: ${s['category']} - ${s['difficulty']}"),
            subtitle: Text("${loc.score}: ${s['score']} / ${s['total']}"),
            trailing: Text(
              s['timestamp'].toString().split('T').first,
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
