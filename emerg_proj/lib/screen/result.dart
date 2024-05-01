import 'package:emerg_proj/screen/cobalagi.dart';
import 'package:emerg_proj/screen/highscore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  final int score;
  final int correctAnswers;

  Result({required this.score, required this.correctAnswers});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late String _title;

  @override
  void initState() {
    super.initState();
    _setTitle();
    _updateHighScore();
  }

  void _setTitle() {
    if (widget.correctAnswers == 5) {
      _title = "Maestro dell'Indovinello";
    } else if (widget.correctAnswers == 4) {
      _title = "Esperto dell'Indovinello";
    } else if (widget.correctAnswers == 3) {
      _title = "Abile Indovinatore";
    } else if (widget.correctAnswers == 2) {
      _title = "Principiante dell'Indovinello";
    } else if (widget.correctAnswers == 1) {
      _title = "Neofita dell'Indovinello";
    } else {
      _title = "Sfortunato Indovinatore";
    }
  }

  void _updateHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? highScore = prefs.getInt('highScore') ?? 0;
    if (widget.score > highScore) {
      prefs.setInt('highScore', widget.score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: ${widget.score}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Correct Answers: ${widget.correctAnswers} of 5',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Your Title: $_title',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close Result screen
                Navigator.pop(context); // Close Game screen
              },
              child: Text('Main Menu'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close Result screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text('Play Again'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close Result screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HighScore()),
                );
              },
              child: Text('High Scores'),
            ),
          ],
        ),
      ),
    );
  }
}
