import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatefulWidget {
  const HighScore({Key? key}) : super(key: key);

  @override
  State<HighScore> createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
  late List<Map<String, dynamic>> _leaderboard;

  @override
  void initState() {
    super.initState();
    _leaderboard = [];
    _loadLeaderboard();
  }

  void _loadLeaderboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? playerKeys = prefs.getStringList('playerKeys');

    if (playerKeys != null) {
      for (String key in playerKeys) {
        String username = prefs.getString('$key:username') ?? '';
        int score = prefs.getInt('$key:score') ?? 0;
        _leaderboard.add({'username': username, 'score': score});
      }
      _leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
      _leaderboard = _leaderboard.take(3).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Center(
        child: _leaderboard.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> playerData = _leaderboard[index];
                  return Card(
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(playerData['username'].toString()),
                      trailing: Text(playerData['score'].toString()),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
