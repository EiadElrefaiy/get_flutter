import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
class TestPickerWidget extends StatefulWidget {
  final textFormFieldNum;
  TestPickerWidget({Key? key, required this.textFormFieldNum})
      : super(key: key);

  @override
  _TestPickerWidgetState createState() => _TestPickerWidgetState();
}

class _TestPickerWidgetState extends State<TestPickerWidget> {
  Color mainColor = Color.fromARGB(255, 255, 150, 102);
  Color errorColor = Colors.red;
  final double borderRadius = 50;
  final double borderWidth = 2;
  final double textFontSize = 20;
  final double iconSize = 40;
  late Color existedColor;
  late String hintText;
  late IconData icon;
  
  late String stringDate;
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    stringDate = "";
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    existedColor = mainColor;
    if (widget.textFormFieldNum == 2) {
      hintText = "تاريخ الميلاد";
      icon = Icons.calendar_month;
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlinedInputBorder = new OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: mainColor, width: borderWidth));

    TextStyle textStyle = new TextStyle(
      fontSize: textFontSize,
      fontWeight: FontWeight.bold,
      color: existedColor,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
          textAlign: TextAlign.right,
          controller: dateinput,
          //editing controller of this TextField
          cursorColor: existedColor,
          style: textStyle,
          obscureText: false,
          decoration: InputDecoration(
            hintText: hintText,
            errorStyle: TextStyle(
              fontSize: textFontSize - 4,
              color: errorColor,
            ),
            prefixIcon: Icon(icon, size: iconSize, color: existedColor),
            hintStyle: textStyle,
            contentPadding:
                EdgeInsets.only(top: 10, right: 25, bottom: 10, left: 10),
            disabledBorder: outlinedInputBorder,
            enabledBorder: outlinedInputBorder,
            focusedBorder: outlinedInputBorder,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: errorColor, width: borderWidth)),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                width: borderWidth,
                color: errorColor,
              ),
            ),
          ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                    1900), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: mainColor, // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: mainColor, // body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: mainColor, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                });

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  intl.DateFormat('yyyy-MM-dd').format(pickedDate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              //you can implement different kind of Date Format here according to your requirement
              stringDate = formattedDate;
              setState(() {
                dateinput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {
              print("Date is not selected");
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                existedColor = errorColor;
              });
              return 'من فضلك ادخل البيانات';
            }
            else{
          setPrefs() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("birthdate", stringDate);
          }
          setPrefs();
            }
            return null;
          }),
    );
  }
}
