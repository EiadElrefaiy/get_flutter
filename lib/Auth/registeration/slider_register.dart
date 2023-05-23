import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/Register1.dart';
import 'package:get_store/Auth/registeration/register2.dart';
import 'package:get_store/Auth/registeration/register3.dart';
import 'package:get_store/Auth/registeration/register4.dart';

class SliderRegister extends StatefulWidget {
  SliderRegister({Key? key}) : super(key: key);

  @override
  State<SliderRegister> createState() => _SliderState();
}

class _SliderState extends State<SliderRegister> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          Register1(),
          Register2(),
          Register3(),
          Register4(),
        ]),
      )),
    );
  }
}
