import 'package:flutter/material.dart';
import 'package:Neat/size_config.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    this.image,
    this.text,
    Key key,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          'neat',
          style: TextStyle(
            fontSize: getProportionateScreenHeight(48),
            color: Color(0xFFFb7484),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(
          flex: 2,
        ),
        Image.asset(
          image,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(295),
        ),
      ],
    );
  }
}
