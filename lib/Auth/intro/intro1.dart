import 'package:flutter/material.dart';
import 'package:get_store/Auth/intro/main/mainview.dart';

class Intro1 extends StatelessWidget {
  const Intro1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Mainview(
      image_margin: 50,
      image: "images/vector1.png",
      boxFit: BoxFit.fill,
      title: "اختار لبسك",
      description: "هتقدر تشوف بضاعة كل محل اكنك جواه",
      height1: 50,
      button_title: "التالي",
      tabNumber: 1,
      height2: 90,
      point1_color: Color.fromARGB(255, 255, 150, 102),
      point2_color: Color.fromARGB(100, 100, 100, 100),
      point3_color: Color.fromARGB(100, 100, 100, 100),
    ));
  }
}
