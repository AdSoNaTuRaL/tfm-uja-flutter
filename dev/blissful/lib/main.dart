import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blissful/constants.dart';
import 'package:blissful/routes.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt("initScreen");
  await preferences.setInt("initScreen", 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blissful',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          bodyText1: TextStyle(color: bTextColor),
          bodyText2: TextStyle(color: bTextColor),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: SplashScreen(),
      initialRoute: initScreen == 0 || initScreen == null ? "/splash" : "/home",
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
