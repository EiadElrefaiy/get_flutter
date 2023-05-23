import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextFormFieldComponent extends StatefulWidget {
  final textFormFieldNum;
  final TextInputType textInputType;
  TextFormFieldComponent(
      {Key? key, required this.textFormFieldNum, required this.textInputType})
      : super(key: key);

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  Color mainColor = Color.fromARGB(255, 255, 150, 102);
  Color errorColor = Colors.red;
  final double borderRadius = 50;
  final double borderWidth = 2;
  final double textFontSize = 20;
  final double iconSize = 40;
  late bool hashText = false;
  late Color existedColor;
  late String hintText;
  late IconData icon;
  final myController = TextEditingController();
  String? password = "";
  String? repassword = "";
  String initial = "";
  String initialVal = "";
  List<Pass> passList = [];

  String _password = "";

  Future<String?> getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var val = await prefs.getString("pass");
    setState(() {
      _password = val!;
    });
    return _password;
  }

  Future<String> remember() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // TODO: implement initState
      if (widget.textFormFieldNum == 12) {
        return initial = prefs?.getString("rememberName") ?? "";
      } else if (widget.textFormFieldNum == 13) {
        return initial = prefs?.getString("rememberPass") ?? "";
      } else {
        return initial = "";
      }
    } catch (e) {
      print(e);
    }
    throw new FormatException();
  }

  @override
  void initState() {
    remember();
    print(initial);
    existedColor = mainColor;
    if (widget.textFormFieldNum == 1 || widget.textFormFieldNum == 12) {
      hintText = "اسم المستخدم";
      icon = Icons.person;
    }
    if (widget.textFormFieldNum == 3 || widget.textFormFieldNum == 15) {
      hintText = "رقم التليفون";
      icon = Icons.phone;
    }
    if (widget.textFormFieldNum == 5) {
      hintText = "الوزن";
      icon = Icons.monitor_weight;
    }
    if (widget.textFormFieldNum == 6) {
      hintText = "الطول";
      icon = Icons.height;
    }
    if (widget.textFormFieldNum == 9) {
      hintText = "العنوان";
      icon = Icons.house;
    }

    if (widget.textFormFieldNum == 10 ||
        widget.textFormFieldNum == 13 ||
        widget.textFormFieldNum == 16) {
      hintText = "كلمة السر";
      hashText = true;
      icon = Icons.lock;
    }
    if (widget.textFormFieldNum == 11 || widget.textFormFieldNum == 17) {
      hintText = "تأكيد كلمة السر";
      hashText = true;
      icon = Icons.lock;
    }
    if (widget.textFormFieldNum == 14) {
      hintText = "كود الدعوة";
      icon = Icons.group;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
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

    return FutureBuilder<String>(
        future: remember(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return TextFormField(
                initialValue: initial,
                keyboardType: widget.textInputType,
                cursorColor: existedColor,
                style: textStyle,
                obscureText: hashText,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorStyle: TextStyle(
                    fontSize: textFontSize - 4,
                    color: errorColor,
                  ),
                  prefixIcon: Icon(
                    icon,
                    size: iconSize,
                    color: existedColor,
                  ),
                  hintStyle: textStyle,
                  contentPadding:
                      EdgeInsets.only(top: 10, right: 25, bottom: 10, left: 10),
                  disabledBorder: outlinedInputBorder,
                  enabledBorder: outlinedInputBorder,
                  focusedBorder: outlinedInputBorder,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide:
                          BorderSide(color: errorColor, width: borderWidth)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      width: borderWidth,
                      color: errorColor,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      existedColor = errorColor;
                    });
                    return 'من فضلك ادخل البيانات';
                  } else if (widget.textFormFieldNum == 1) {
                    if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في اسم المستخدم';
                    } else {
                      setPrefs() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("name", value);
                        print(value);
                      }

                      setPrefs();
                    }
                  } else if (widget.textFormFieldNum == 3 ||
                      widget.textFormFieldNum == 15) {
                    bool numberCheck =
                        value.length == 11 && value.startsWith("0122") ||
                            value.startsWith("0127") ||
                            value.startsWith("0128") ||
                            value.startsWith("0120") ||
                            value.startsWith("0100") ||
                            value.startsWith("0106") ||
                            value.startsWith("0109") ||
                            value.startsWith("0101") ||
                            value.startsWith("0111") ||
                            value.startsWith("0114") ||
                            value.startsWith("0112") ||
                            value.startsWith("0155");

                    if (!RegExp(r'^[0-9]+$').hasMatch(value) ||
                        numberCheck == false) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في ادخال رقم التليفون';
                    } else {
                      setPrefs() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("phone", value);
                      }

                      setPrefs();
                    }
                  } else if (widget.textFormFieldNum == 5) {
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في ادخال الوزن';
                    } else {
                      setPrefs() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setDouble("weight", double.parse(value));
                      }

                      setPrefs();
                    }
                  } else if (widget.textFormFieldNum == 6) {
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في ادخال الطول';
                    } else {
                      setPrefs() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setDouble("height", double.parse(value));
                      }

                      setPrefs();
                    }
                  } else if (widget.textFormFieldNum == 9) {
                    setPrefs() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("address", value);
                    }

                    setPrefs();
                  } else if (widget.textFormFieldNum == 10) {
                    if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في ادخال كلمة السر';
                    } else if (value.length < 8) {
                      return 'يجب الا تقل كلمة السر عن 8 خانات';
                    } else {
                      setPrefs() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("password", value);
                      }

                      setPrefs();
                    }
                  } else if (widget.textFormFieldNum == 12) {
                    setPrefs() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("name_login", value);
                      print(prefs.getString("name_login"));
                    }

                    setPrefs();
                  } else if (widget.textFormFieldNum == 13 ||
                      widget.textFormFieldNum == 16) {
                    if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                      setState(() {
                        existedColor = errorColor;
                      });
                      return 'خطأ في ادخال كلمة السر';
                    }
                    setPrefs() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("pass_login", value);
                      print(prefs.getString("pass_login"));
                    }

                    setPrefs();
                  } else if (widget.textFormFieldNum == 14) {
                    setPrefs() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("friend_invitation_id", value);
                      print(value);
                    }

                    setPrefs();
                  }
                  return null;
                });
          } else {
            return Container();
          }
        });
  }
}

class Pass {
  String password;
  Pass(this.password);
}
