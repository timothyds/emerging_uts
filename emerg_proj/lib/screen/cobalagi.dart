import 'dart:async';
import 'package:emerg_proj/screen/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emerg_proj/class/questionBank.dart';

String _username = "";
late int _score;
late int _correctAnswerCount;

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _currentRound;
  late int _secondsRemaining;
  int _question_no = 0;
  bool _isVisible = true;
  List<QuestionBank> _questions = [
    QuestionBank(
      "assets/images/c-1-1.png",
      "assets/images/c-1-2.png",
      "assets/images/c-1-1.png",
      "assets/images/c-1-3.png",
      "assets/images/c-1-4.png",
      "assets/images/c-1-1.png",
    ),
    QuestionBank(
      "assets/images/c-2-3.png",
      "assets/images/c-2-2.png",
      "assets/images/c-2-3.png",
      "assets/images/c-2-4.png",
      "assets/images/c-2-1.png",
      "assets/images/c-2-3.png",
    ),
    QuestionBank(
      "assets/images/c-3-1.png",
      "assets/images/c-3-4.png",
      "assets/images/c-3-3.png",
      "assets/images/c-3-1.png",
      "assets/images/c-3-2.png",
      "assets/images/c-3-1.png",
    ),
    QuestionBank(
      "assets/images/c-4-3.png",
      "assets/images/c-4-4.png",
      "assets/images/c-4-3.png",
      "assets/images/c-4-2.png",
      "assets/images/c-4-1.png",
      "assets/images/c-4-3.png",
    ),
    QuestionBank(
      "assets/images/c-5-4.png",
      "assets/images/c-5-3.png",
      "assets/images/c-5-2.png",
      "assets/images/c-5-1.png",
      "assets/images/c-5-4.png",
      "assets/images/c-5-4.png",
    ),
  ];
  
  late QuestionBank _currentQuestion;
  late List<String> _options = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _questions.shuffle();
    _currentRound = 0;
    _score = 0;
    _correctAnswerCount = 0;
    _startRound();
  }

  void _startRound() {
    _secondsRemaining = 3;
    _currentQuestion = _questions[_currentRound];
    _showImage();
  }

  void _showImage() {
    _isVisible = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          if (_secondsRemaining == 1) {
          _isVisible = false;
        }
        } else {
          _timer.cancel();
          if (_currentRound < _questions.length - 1) {
            _currentRound++;
            _startRound();
          } else {
            _showOptions();
          }
        }
      });
    });
  }

  void _showOptions() {
    setState(() {
      _options = [
        _questions[_question_no].option_a,
        _questions[_question_no].option_b,
        _questions[_question_no].option_c,
        _questions[_question_no].option_d,
      ];
      _options.shuffle();
    });
  }

  void _selectAnswer(String selectedAnswer) {
    if (selectedAnswer == _questions[_question_no].answer) {
      _score += 100;
      _correctAnswerCount++;
    }
    _question_no++;
    if (_question_no < _questions.length) {
      _showOptions();
    } else {
      _saveScore();
    }
  }
  void _saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUsername = prefs.getString('user_id');
    int currentHighScore = prefs.getInt('highScore') ?? 0;
    List<String>? playerKeys = prefs.getStringList('playerKeys') ?? [];
    int? existingPlayerIndex = playerKeys
        .indexWhere((key) => prefs.getString('$key:username') == lastUsername);
    if (existingPlayerIndex != -1) {
      String existingPlayerKey = playerKeys[existingPlayerIndex];
      int existingPlayerScore = prefs.getInt('$existingPlayerKey:score') ?? 0;
      if (_score > existingPlayerScore) {
        prefs.remove(existingPlayerKey);
        prefs.setString('$existingPlayerKey:username', lastUsername ?? '');
        prefs.setInt('$existingPlayerKey:score', _score);
      }
    } else {
      String playerKey = DateTime.now().millisecondsSinceEpoch.toString();
      prefs.setString('$playerKey:username', lastUsername ?? '');
      prefs.setInt('$playerKey:score', _score);
      playerKeys.add(playerKey);
      prefs.setStringList('playerKeys', playerKeys);
    }
    if (_score > currentHighScore) {
      await prefs.setInt('highScore', _score);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          score: _score,
          correctAnswers: _correctAnswerCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _currentRound < _questions.length
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _secondsRemaining > 0
                        ? Column(
                            children: [
                              Text(
                                'Memorize the image:',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                              AnimatedOpacity(
                                  opacity: _isVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 500),
                                  child: Image.asset(
                                    _currentQuestion.image,
                                    width: 200,
                                    height: 300,
                                  )),
                              SizedBox(height: 10),
                              Text(
                                '$_secondsRemaining seconds remaining',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : _options.isNotEmpty
                            ? Column(
                                children: [
                                  Text(
                                    'Which image have you seen before?',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[0]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.asset(
                                          _options[0],
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[1]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.asset(
                                          _options[1],
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[2]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.asset(
                                          _options[2],
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[3]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.asset(
                                          _options[3],
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
