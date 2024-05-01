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
    // checkPoint().then((value) {
    //   setState(() {
    //     _point = value;
    //     _isLoading = false;
    //   });
    // });
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    List<Map<String, dynamic>> leaderboard = await checkPoint();
    setState(() {
      _leaderboard = leaderboard;
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> checkPoint() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> leaderboard = [];

  // Mengambil nilai username dan highScore dari SharedPreferences
  List<String> userList = prefs.getStringList('user') ?? [];
  String user = userList.isNotEmpty ? userList[0] : ""; // Ambil nilai pertama jika ada
  dynamic point = userList.length > 1 ? int.tryParse(userList[1]) : 0; // Konversi nilai ke integer jika mungkin
  // Menambahkan pasangan username dan highScore ke dalam list leaderboard
  leaderboard.add({'user': user, 'point': point});

  return leaderboard;
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
