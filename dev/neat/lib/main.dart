import 'package:Neat/app_localizations.dart';
import 'package:Neat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Neat/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';

int firstTime = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  firstTime = preferences.getInt('onBoardingAlreadyBeenSeen');
  await preferences.setInt("onBoardingAlreadyBeenSeen", 1);
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
      supportedLocales: [
        Locale('en', 'US'), // Default Language
        Locale('es', 'ES'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      home: firstTime != 1 ? OnBoarding() : Home(),
    );
  }
}
