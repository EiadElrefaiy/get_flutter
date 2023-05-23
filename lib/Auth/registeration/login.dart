import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/forgetPhone.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';
import 'package:get_store/prog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main/components/textformfieldCompnent.dart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checkedValue = false;

  falseDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("remember", checkedValue);
  }

  @override
  void initState() {
    // TODO: implement initState
    falseDefault();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      title: "تسجيل الدخول",
      content: Column(
        children: [
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormFieldComponent(
                textFormFieldNum: 12,
                textInputType: TextInputType.text,
              )),
          SizedBox(
            height: 27,
          ),
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormFieldComponent(
                textFormFieldNum: 13,
                textInputType: TextInputType.text,
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => PhoneForget())));
                },
                child: Text(
                  "نسيت كلمة السر؟",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 150, 102),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Text(
                    "تذكر كلمة السر",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 150, 102),
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Color.fromARGB(255, 255, 150, 102),
                    value: checkedValue,
                    onChanged: (newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        checkedValue = newValue!;
                        if (checkedValue == true) {
                          prefs.setBool("remember", true);
                        } else {
                          prefs.setBool("remember", false);
                        }
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      buttonText: "دخول",
      btnClick: 5,
      RegisterOrLogin: "انشاء حساب",
    );
  }
}
