import 'package:Neat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Neat/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';

int initScreen = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt("initScreen", 1);
  runApp(Neat());
}

class Neat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neat',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          bodyText1: TextStyle(color: nTextColor),
          bodyText2: TextStyle(color: nTextColor),
        ),
        primarySwatch: Colors.blue,
      ),
      home: initScreen != 1 ? OnBoarding() : Home(),
    );
  }
}
