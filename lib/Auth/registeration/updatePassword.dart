import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';
import 'package:get_store/prog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main/components/textformfieldCompnent.dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      title: "كلمة السر الجديدة",
      content: Column(
        children: [
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormFieldComponent(
                textFormFieldNum: 16,
                textInputType: TextInputType.number,
              )),
        ],
      ),
      buttonText: "حفظ",
      btnClick: 7,
      RegisterOrLogin: "تسجيل الدخول",
    );
  }
}
