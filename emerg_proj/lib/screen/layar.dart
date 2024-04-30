import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _currentRound;
  late int _secondsRemaining;
  List<String> _images = [
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/238/200/300',
    'https://picsum.photos/id/239/200/300',
    'https://picsum.photos/id/240/200/300',
    'https://picsum.photos/id/241/200/300',
  ];
  late String _correctAnswer;
  late List<String> _options;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentRound = 0;
    _startRound();
  }

  void _startRound() {
    _secondsRemaining = 3;
    _correctAnswer = _images[_currentRound];
    _options = _getOptions();
    _showImage();
  }

  List<String> _getOptions() {
    List<String> options = [_correctAnswer];
    while (options.length < 4) {
      String randomImage = _images[Random().nextInt(_images.length)];
      if (!options.contains(randomImage)) {
        options.add(randomImage);
      }
    }
    options.shuffle();
    return options;
  }

  void _showImage() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _currentRound++;
          if (_currentRound < _images.length) {
            _startRound();
          } else {
            _showOptions();
          }
        }
      });
    });
  }

  void _showOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Which image did you see?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _options.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  if (_options[index] == _correctAnswer) {
                    _showResultDialog(true);
                  } else {
                    _showResultDialog(false);
                  }
                },
                child: Image.network(
                  _options[index],
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
          content: isCorrect ? Text('You got it right!') : Text('Try again!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  if (_currentRound < _images.length) {
                    _startRound();
                  }
                } else {
                  _showOptions();
                }
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Center(
        child: _currentRound < _images.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Memorize the image:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Image.network(
                    _images[_currentRound],
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
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
