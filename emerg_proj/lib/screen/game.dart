import 'dart:async';
import 'package:emerg_proj/class/questionBank.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<QuestionBank> _questions = [];
  int _question_no = 0;
  int _point = 0;
  int _initialValue = 10;
  int _hitung = 10;
  late Timer _timer; // add “late” to initialize it later in initState()
  String _activeUser = "";
  void activeUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _activeUser = prefs.getString("user_id") ?? "";
    });
  }

  void savePoint() async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();
    final int? topPoint = prefs.getInt('point');
    (topPoint == null || _point > topPoint)
        ? (prefs.setInt("point", _point), prefs.setString('user', _activeUser))
        : null;
  }

  @override
  void initState() {
    super.initState();
    // _questions.add(QuestionBank(
    //     "https://w7.pngwing.com/pngs/744/257/png-transparent-momo-aang-avatar-aang-television-mammal-carnivoran.png",
    //     "Dari film animasi apa karakter diatas? ",
    //     'Avatar the last airbender',
    //     'Exhuma',
    //     'Kungfu panda',
    //     'Up',
    //     'Avatar the last airbender'));
    
    randQuestion();
    activeUser();
    startTimer();
  }

  void randQuestion() {
    List<QuestionBank> qstion = [
      QuestionBank(
          "https://w7.pngwing.com/pngs/744/257/png-transparent-momo-aang-avatar-aang-television-mammal-carnivoran.png",
          "Dari film animasi apa karakter diatas? ",
          'Avatar the last airbender',
          'Exhuma',
          'Kungfu panda',
          'Up',
          'Avatar the last airbender'),
      QuestionBank(
          "https://i.etsystatic.com/11275576/r/il/78bf9b/1710937033/il_570xN.1710937033_6ht4.jpg",
          "Siapa nama karakter diatas?",
          'Mace Windu',
          'Han Solo',
          'Anakin',
          'Yoda',
          'Han Solo'),
      QuestionBank(
          "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhH2yWB_8O_FOFSoE_13TJjLpWrEf0TQiquMlRvYAlidHHPkJ8lqLt9EcvIR_1C8ELS3k0vTzoaekLMh_H37YQYlxQvQ0pPw70kJl6bU-bMuW0MPaOZpTkSzxVKil2432mIQYHyun5GQ19s/w1200-h630-p-k-no-nu/timmy-teddy.jpg",
          "Siapa nama karakter tersebut?",
          'Shaun',
          'Alex',
          'Woody',
          'Timmy',
          'Timmy'),
      QuestionBank(
          "https://qph.cf2.quoracdn.net/main-qimg-e1b38f68a8c0da977261367a06a6fefe",
          "Siapakah titan yang dilawan Levi di anime Attack on Titan?",
          'Beast Titan',
          'Colossal Titan',
          'Cart Titan',
          'War Hammer Titan',
          'Beast Titan'),
      QuestionBank(
          "https://ew.com/thmb/HBBWKIwSST5-1n76oHbPi2Rxghs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/judy-hopps_0-d84e62a9424749fcb78da6e2b4635048.jpg",
          "Dari film animasi apa karakter Judy Hopps?",
          'Elemental',
          'Toy Story',
          'Zootopia',
          'Finding Nemo',
          'Zootopia'),
      QuestionBank(
          "https://i.pinimg.com/originals/1d/75/83/1d75837a985b2c5b515c0a11056d14a4.jpg",
          "Siapa nama anak kecil yang bersama Sully dan Mike?",
          'Boo',
          'Archie',
          'Yosi',
          'Satya',
          'Boo'),
      QuestionBank(
          "https://c4.wallpaperflare.com/wallpaper/652/193/189/dog-parrots-fruit-rio-wallpaper-preview.jpg",
          "Siapa nama karakter anjing di film Rio?",
          'Enzo',
          'Hernandez',
          'Diego',
          'Luis',
          'Luis'),
      QuestionBank(
          "https://cdn.kinocheck.com/i/wr6hf3mar5.jpg",
          "Dari series apa karakter tersebut?",
          'Stranger things',
          'Peaky Blinders',
          'Sex Education',
          'Money Heist',
          'Peaky Blinders'),
      QuestionBank(
          "https://m.media-amazon.com/images/M/MV5BNTQxNzU4NTY2OF5BMl5BanBnXkFtZTcwNzQ2NTI3Ng@@._V1_.jpg",
          "Siapa nama karakter utama di film tersebut?",
          'Simba',
          'Bambi',
          'Nebula',
          'Kimi',
          'Simba'),
      QuestionBank(
          "https://c4.wallpaperflare.com/wallpaper/753/237/178/harry-potter-and-the-deathly-hallows-part-2-wallpaper-preview.jpg",
          "Siapa musuh utama dari Harry Potter?",
          'Voldemort',
          'Draco Malfoy',
          'Bellatrix Lestrange',
          'Serverus Snape',
          'Voldemort'),
    ];
    qstion.shuffle();
    _questions = qstion.take(5).toList();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_hitung > 0) {
          _hitung--;
        } else {
          // _question_no++;
          // if (_question_no > _questions.length - 1)

          finishQuiz();

          // _hitung = _initialValue;

          // _timer.cancel();
          // showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //           title: Text('Time up!'),
          //           content: Text('Quiz is Finished!'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () => Navigator.pop(context, 'OK'),
          //               child: const Text('OK'),
          //             ),
          //           ],
          //         ));
          _hitung = 10;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Quiz'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Column(children: <Widget>[
            Text(formatTime(_hitung),
                style: const TextStyle(
                  fontSize: 24,
                )),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _timer.isActive ? _timer.cancel() : startTimer();
                  });
                },
                child: Text(_timer.isActive ? "Stop" : "Start")),
            Divider(
              height: 20.0,
            ),
            Container(
              height: 220.0,
              width: 220.0,
              child: Image.network(_questions[_question_no].image),
            ),
            Text(_questions[_question_no].narration),
            TextButton(
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_a);
                },
                child: Text("A. " + _questions[_question_no].option_a)),
            TextButton(
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_b);
                },
                child: Text("B. " + _questions[_question_no].option_b)),
            TextButton(
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_c);
                },
                child: Text("C. " + _questions[_question_no].option_c)),
            TextButton(
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_d);
                },
                child: Text("D. " + _questions[_question_no].option_d)),
          ])),
        ));
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _questions[_question_no].answer) {
        _point += 100;
      }
      _question_no++;
      if (_question_no > _questions.length - 1) finishQuiz();
      _hitung = _initialValue;
    });
  }

  finishQuiz() {
    _timer.cancel();
    _question_no = 0;
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Quiz'),
              content: Text('Your point = $_point'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
    savePoint();
  }
}
