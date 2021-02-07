import 'package:blissful/constants.dart';
import 'package:blissful/components/splash_content.dart';
import 'package:blissful/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      'title': 'Lleve felicidad al mundo',
      'description': 'Visite orfanatos y cambie el día de muchos niños.',
      'image': 'assets/images/ilustra01.png',
    },
    {
      'title': 'Haga un niño feliz',
      'description': 'Elija un orfanato en el mapa y haga una visita.',
      'image': 'assets/images/ilustra02.png',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]['image'],
                  title: splashData[index]['title'],
                  description: splashData[index]['description'],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  Spacer(flex: 1),
                  SizedBox(
                    width: getProportionateScreenWidth(56),
                    height: getProportionateScreenHeight(56),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: bPrimaryColorLight,
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_right_alt_rounded,
                        color: bPrimaryColor,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: bAnimationDuration,
      margin: EdgeInsets.only(right: 5.0),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? bSecondaryColor : Color(0xFFD8d8d8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
