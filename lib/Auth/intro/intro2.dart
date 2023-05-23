import 'dart:ui';

import 'package:flutter/material.dart';

import 'main/mainview.dart';

class Intro2 extends StatelessWidget {
  const Intro2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Mainview(
            image_margin: 100,
            image: "images/vector2.png",
            boxFit: BoxFit.fill,
            title: "التوصيل",
            description: "اختار لبسك واعمل اوردر وهنوصلوا لباب بيتك",
            height1: 10,
            button_title: "التالي",
            tabNumber: 2,
            height2: 90,
            point1_color: Color.fromARGB(100, 100, 100, 100),
            point2_color: Color.fromARGB(255,255,150,102),
            point3_color: Color.fromARGB(100, 100, 100, 100),
             )
            );
  }
}