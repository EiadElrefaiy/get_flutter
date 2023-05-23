import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';
import 'package:get_store/prog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main/components/textformfieldCompnent.dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PhoneForget extends StatefulWidget {
  PhoneForget({Key? key}) : super(key: key);

  @override
  State<PhoneForget> createState() => _PhoneForgetState();
}

class _PhoneForgetState extends State<PhoneForget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      title: "نسيت كلمة السر؟",
      content: Column(
        children: [
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormFieldComponent(
                textFormFieldNum: 15,
                textInputType: TextInputType.number,
              )),
        ],
      ),
      buttonText: "ارسال",
      btnClick: 6,
      RegisterOrLogin: "تسجيل الدخول",
    );
  }
}
