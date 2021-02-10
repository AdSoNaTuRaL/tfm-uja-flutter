import 'package:blissful/screens/home/home_screen.dart';
import 'package:blissful/screens/onboard/on_boarding_screen.dart';
import 'package:blissful/screens/orphanage/create_orphanage_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CreateOrphanage.routeName: (context) => CreateOrphanage(),
};
