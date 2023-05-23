import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/components/textFormFieldWithDropDownListComponent.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';

import 'main/components/textformfieldCompnent.dart.dart';

class Register2 extends StatefulWidget {
  Register2({Key? key}) : super(key: key);

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return MainView(
        title: "تسجيل حساب",
        content: Column(
          children: [
            TextFormFieldDropDown(
              textFormFieldNum: 4,
            ),
            SizedBox(
              height: 27,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textInputType: TextInputType.number,
                  textFormFieldNum: 5,
                )),
            SizedBox(
              height: 27,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textInputType: TextInputType.number,
                  textFormFieldNum: 6,
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
                      color: Color.fromARGB(255, 255, 150, 102),
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
              ],
            )
          ],
        ),
        buttonText: "التالي",
        btnClick: 2,
        RegisterOrLogin: "لدي حساب بالفعل");
  }
}
