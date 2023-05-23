import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';

import 'main/components/textformfieldCompnent.dart.dart';

class Register4 extends StatefulWidget {
  Register4({Key? key}) : super(key: key);

  @override
  State<Register4> createState() => _Register4State();
}

class _Register4State extends State<Register4> {
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return MainView(
        title: "تسجيل حساب",
        content: Column(
          children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textInputType: TextInputType.number,
                  textFormFieldNum: 14,
                )),
            SizedBox(
              height: 27,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textInputType: TextInputType.text,
                  textFormFieldNum: 10,
                )),
            SizedBox(
              height: 27,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 150, 102),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            )
          ],
        ),
        buttonText: "تم",
        btnClick: 4,
        RegisterOrLogin: "لدي حساب بالفعل");
  }
}
