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
  List<Map<String, dynamic>> _leaderboard = [];
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

  Future<Map<String, dynamic>> checkPoint() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('lastUsername') ?? "";
    final point = prefs.getInt('highScore') ?? 0;
    setState(() {
      _leaderboard.add({'user': user, 'point': point});
    });
    return {'user': user, 'point': point};
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
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("High Score"),
                    ),
                  ],
                  rows: _leaderboard
                      .map(
                        (score) => DataRow(
                          cells: [
                            DataCell(Text(score['user'])),
                            DataCell(Text(score['point'].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
    );
  }
}
