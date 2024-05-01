import 'dart:async';
import 'package:emerg_proj/screen/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emerg_proj/class/questionBank.dart';

String _username = "";
late int _score;
late int _correctAnswerCount; // Jumlah jawaban benar

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _currentRound;
  late int _secondsRemaining;
  int _question_no = 0;
  List<QuestionBank> _questions = [
    QuestionBank(
      "https://picsum.photos/id/237/200/300",
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/id/242/200/300',
      'https://picsum.photos/id/243/200/300',
      'https://picsum.photos/id/244/200/300',
      'https://picsum.photos/id/237/200/300',
    ),
    QuestionBank(
      "https://picsum.photos/id/238/200/300",
      'https://picsum.photos/id/247/200/300',
      'https://picsum.photos/id/263/200/300',
      'https://picsum.photos/id/235/200/300',
      'https://picsum.photos/id/238/200/300',
      'https://picsum.photos/id/238/200/300',
    ),
    QuestionBank(
      "https://picsum.photos/id/239/200/300",
      'https://picsum.photos/id/260/200/300',
      'https://picsum.photos/id/239/200/300',
      'https://picsum.photos/id/261/200/300',
      'https://picsum.photos/id/248/200/300',
      'https://picsum.photos/id/239/200/300',
    ),
    QuestionBank(
      "https://picsum.photos/id/240/200/300",
      'https://picsum.photos/id/249/200/300',
      'https://picsum.photos/id/250/200/300',
      'https://picsum.photos/id/240/200/300',
      'https://picsum.photos/id/251/200/300',
      'https://picsum.photos/id/240/200/300',
    ),
    QuestionBank(
      "https://picsum.photos/id/241/200/300",
      'https://picsum.photos/id/252/200/300',
      'https://picsum.photos/id/241/200/300',
      'https://picsum.photos/id/253/200/300',
      'https://picsum.photos/id/254/200/300',
      'https://picsum.photos/id/241/200/300',
    ),
  ];
  late QuestionBank _currentQuestion;
  late List<String> _options = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentRound = 0;
    _score = 0;
    _correctAnswerCount = 0; // Inisialisasi jumlah jawaban benar
    _startRound();
  }

  void _startRound() {
    _secondsRemaining = 3;
    _currentQuestion = _questions[_currentRound];
    _showImage();
  }

  void _showImage() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
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
    await prefs.setInt('highScore', _score);
    await prefs.setInt('correctAnswerCount', _correctAnswerCount);
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Result(score: _score,correctAnswers: _correctAnswerCount,)),
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
                              Image.network(
                                _currentQuestion.image,
                                width: 200,
                                height: 300,
                              ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[0]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.network(
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
                                        child: Image.network(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectAnswer(_options[2]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Image.network(
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
                                        child: Image.network(
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
