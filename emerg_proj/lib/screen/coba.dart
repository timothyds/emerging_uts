// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:emerg_proj/class/questionBank.dart';

// String _username = "";
// late int _score;

// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   late int _currentRound;
//   late int _secondsRemaining;
//   // late int _score;
//   List<QuestionBank> _questions = [
//     QuestionBank(
//       "https://picsum.photos/id/237/200/300",
//       'https://picsum.photos/id/237/200/300',
//       'https://picsum.photos/id/242/200/300',
//       'https://picsum.photos/id/243/200/300',
//       'https://picsum.photos/id/244/200/300',
//       'https://picsum.photos/id/237/200/300',
//     ),
//     QuestionBank(
//       "https://picsum.photos/id/238/200/300",
//       'https://picsum.photos/id/247/200/300',
//       'https://picsum.photos/id/246/200/300',
//       'https://picsum.photos/id/245/200/300',
//       'https://picsum.photos/id/238/200/300',
//       'https://picsum.photos/id/238/200/300',
//     ),
//     QuestionBank(
//       "https://picsum.photos/id/239/200/300",
//       'https://picsum.photos/id/246/200/300',
//       'https://picsum.photos/id/239/200/300',
//       'https://picsum.photos/id/247/200/300',
//       'https://picsum.photos/id/248/200/300',
//       'https://picsum.photos/id/239/200/300',
//     ),
//     QuestionBank(
//       "https://picsum.photos/id/240/200/300",
//       'https://picsum.photos/id/249/200/300',
//       'https://picsum.photos/id/250/200/300',
//       'https://picsum.photos/id/240/200/300',
//       'https://picsum.photos/id/251/200/300',
//       'https://picsum.photos/id/240/200/300',
//     ),
//     QuestionBank(
//       "https://picsum.photos/id/241/200/300",
//       'https://picsum.photos/id/252/200/300',
//       'https://picsum.photos/id/241/200/300',
//       'https://picsum.photos/id/253/200/300',
//       'https://picsum.photos/id/254/200/300',
//       'https://picsum.photos/id/241/200/300',
//     ),
//   ];
//   late QuestionBank _currentQuestion;
//   late List<String> _options;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _currentRound = 0;
//     _score = 0;
//     _startRound();
//   }

//   void _startRound() {
//     _secondsRemaining = 3;
//     _currentQuestion = _questions[_currentRound];
//     _options = [
//       _currentQuestion.option_a,
//       _currentQuestion.option_b,
//       _currentQuestion.option_c,
//       _currentQuestion.option_d,
//     ];
//     _options.shuffle();
//     _showImage();
//   }

//   void _showImage() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_secondsRemaining > 0) {
//           _secondsRemaining--;
//         } else {
//           _timer.cancel();
//           if (_currentRound < _questions.length - 1) {
//             _currentRound++;
//             _startRound();
//           } else {
//             _showOptions();
//           }
//         }
//       });
//     });
//   }

//   void _showOptions() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select the correct image:'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: List.generate(
//               _options.length,
//               (index) => InkWell(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   if (_options[index] == _currentQuestion.answer) {
//                     _score += 100;
//                   }
//                   if (_currentRound < _questions.length - 1) {
//                     _currentRound++;
//                     _startRound();
//                   } else {
//                     _saveScore();
//                   }
//                 },
//                 child: Image.network(
//                   _options[index],
//                   width: 100,
//                   height: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _saveScore() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? username = prefs.getString('user_id');
//     int? highScore = prefs.getInt('highScore') ?? 0;
//     if (username != null) {
//       _username = username;
//     }
//     // if (_score > highScore) {
//     //   prefs.setString('lastUsername', _username);
//     //   prefs.setInt('highScore', _score);
//     // }
//     prefs.setString('lastUsername', _username);
//     prefs.setInt('highScore', _score);
//     // Navigate to results screen or do any other actions
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Game'),
//       ),
//       body: Center(
//         child: _currentRound < _questions.length
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Memorize the image:',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   Image.network(
//                     _currentQuestion.image,
//                     width: 200,
//                     height: 300,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     '$_secondsRemaining seconds remaining',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               )
//             : Container(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }
