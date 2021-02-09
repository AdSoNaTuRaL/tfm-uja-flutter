import 'package:blissful/components/body.dart';
import 'package:blissful/size_config.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  static String routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
