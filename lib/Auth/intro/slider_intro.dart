import 'package:flutter/material.dart';
import 'package:get_store/Auth/intro/intro1.dart';
import 'package:get_store/Auth/intro/intro2.dart';
import 'package:get_store/Auth/intro/intro3.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/prog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderIntro extends StatefulWidget {
  SliderIntro({Key? key}) : super(key: key);

  @override
  State<SliderIntro> createState() => _SliderState();
}

class _SliderState extends State<SliderIntro> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: TabBarView(children: [
          Intro1(),
          Intro2(),
          Intro3(),
        ]),
      )),
    );
  }
}
