import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
late Map<String, dynamic> _point;
bool _isLoading = true;

// void main() {
//   //runApp(const MyApp());
//   WidgetsFlutterBinding.ensureInitialized();
//   checkPoint().then((int result) {
//       pointNow = result;
//     }
//   );
// }
class HighScore extends StatefulWidget {
  const HighScore({super.key});

  @override
  State<HighScore> createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
   @override
  void initState() {
    super.initState();
    checkPoint().then((value) {
      setState(() {
        _point = value;
        _isLoading = false;
      });
    });
  }
  Future<Map<String,dynamic>> checkPoint() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? "";
    final point = prefs.getInt('point') ?? 0;
    return {'user':user, 'point':point};
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Top User: ${_point['user']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Top Point: ${_point['point']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ),
    );
  }
}