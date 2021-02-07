import 'package:blissful/constants.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.title,
    this.image,
    this.description,
  }) : super(key: key);
  final String title, image, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Image.asset(
          image,
          height: getProportionateScreenHeight(265),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(46.0, 46.0, 46.0, 8.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.0,
              fontSize: getProportionateScreenWidth(48),
              color: bTextColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(46.0, 0, 46.0, 0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
            ),
          ),
        )
      ],
    );
  }
}
