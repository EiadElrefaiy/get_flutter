import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/components/textFormFieldWithCalenderComponent.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';

import 'main/components/textformfieldCompnent.dart.dart';

class Register1 extends StatefulWidget {
  Register1({Key? key}) : super(key: key);

  @override
  State<Register1> createState() => _Register1State();
}

class _Register1State extends State<Register1> {
  bool checkedValue = false;
  TextEditingController dateinputText = TextEditingController();

  @override
  void initState() {
    dateinputText.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
        title: "تسجيل حساب",
        content: Column(
          children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textFormFieldNum: 1,
                  textInputType: TextInputType.text,
                )),
            SizedBox(
              height: 27,
            ),
            TestPickerWidget(
              textFormFieldNum: 2,
            ),
            SizedBox(
              height: 27,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textFormFieldNum: 3,
                  textInputType: TextInputType.number,
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
        btnClick: 1,
        RegisterOrLogin: "لدي حساب بالفعل");
  }
}
