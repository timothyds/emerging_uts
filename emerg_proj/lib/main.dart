import 'package:emerg_proj/screen/coba.dart';
import 'package:emerg_proj/screen/cobalagi.dart';
import 'package:emerg_proj/screen/highscore.dart';
import 'package:emerg_proj/screen/layar.dart';
import 'package:emerg_proj/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//global var
String active_user = "";

//
void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    active_user="";
    prefs.remove("user_id");
    main();
  }
Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

void main() {
  //runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'login':(context)=>MyLogin(),
        'point':(context)=>HighScore(),
      },
      title: 'Memorimage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Memorimage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat datang di game Memorimage!!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Lihat dan ingat setiap gambar selama 3 detik lalu tebak gambar yang benar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text('Play Game'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: methodDrawer(),
    );
  }
  Drawer methodDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("Timothy"),
              accountEmail: Text(active_user),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
            title: Text('High score'),
            leading: Icon(Icons.score),
            onTap: (){
              Navigator.popAndPushNamed(context, 'point');
            },
          ),
          Divider(
            height: 20.0,
          ),
          ListTile(
            title: Text(active_user !="" ? "Logout" : "Login"),
            leading: Icon(Icons.login),
            onTap: (){
              active_user !="" ? doLogout():
              Navigator.popAndPushNamed(context, 'login');
            },
          ),
          
        ],
      ),
    );
  }
}
