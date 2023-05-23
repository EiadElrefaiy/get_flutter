import 'dart:ui';

import 'package:flutter/material.dart';

import 'main/mainview.dart';

class Intro3 extends StatelessWidget {
  const Intro3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Mainview(
      image_margin: 100,
      image: "images/vector3.png",
      boxFit: BoxFit.fill,
      title: "زود دخلك",
      description:
          "تقدر تخلي صحابك ومعارفك ينزلوا التطبيق ويسجلوا بكود الدعوة الخاص بيك وهينزلك عمولة 5 جنيه على كل اوردر هيتطلب عن طريقهم",
      height1: 30,
      button_title: "ابدأ",
      tabNumber: 3,
      height2: 40,
      point1_color: Color.fromARGB(100, 100, 100, 100),
      point2_color: Color.fromARGB(100, 100, 100, 100),
      point3_color: Color.fromARGB(255, 255, 150, 102),
    ));
  }
}
