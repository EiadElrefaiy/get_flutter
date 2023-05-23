import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Payment extends StatefulWidget {
  Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool isLoading = false;
  String name = "";
  String phone = "";
  String money = "";
  var results;
  var payResults;
  final _formKey = GlobalKey<FormState>();
  int user_id = 0;
  Color color = Color.fromARGB(255, 255, 150, 102);

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;
        var url = "http://app.getcenter.info/api/v1/orders/get-orders";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ConnectionFaield()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ConnectionFaield()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  sendData() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;
        var url = "http://app.getcenter.info/api/v1/payments/add";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "user_id": user_id,
            "wallet_number": phone,
            "money": double.parse(money),
            "date": intl.DateFormat('yMd').format(DateTime.now()),
            "done": 0,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          payResults = jsonDecode(response.body);
          if (payResults['statues'] == false) {
            Fluttertoast.showToast(
                msg: payResults["msg"].toString(),
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.grey[800]);
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Payment()));

            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  int selectedRadio = 0;
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 120,
                                  color: Color.fromARGB(255, 255, 150, 102),
                                )),
                            Text(
                              payResults['msg'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 150, 102)),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                });
          }
        } else {
          Fluttertoast.showToast(
              msg: "خطأ في الاتصال",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } else {
        Fluttertoast.showToast(
            msg: "خطأ في الاتصال",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
            fontSize: 16,
            backgroundColor: Colors.grey[800]);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = Appbar();
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
        appBar: appBar,
        body: Center(
          child: isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 150, 102),
                    ), //show this if state is loading
                  ],
                )
              : SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 240, 240, 240),
                      height: screenHeight - (screenHeight / 17.5),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "سحب عمولة",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 150, 102),
                                      fontSize: 30),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "العمولة الحالية",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                    Text(
                                      "${results['total'][0]} جنيه",
                                      style: TextStyle(fontSize: 20),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 22,
                                          ),
                                          height: 2.5,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        color =
                                            Color.fromARGB(255, 255, 150, 102);
                                      });
                                      name = value;
                                    },
                                    cursorColor: color,
                                    style:
                                        TextStyle(fontSize: 18, color: color),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: -5, horizontal: 10),
                                      hintText: "الاسم ثلاثي باللغة العربية",
                                      hintStyle:
                                          TextStyle(fontSize: 18, color: color),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      errorStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return 'من فضلك ادخل البيانات';
                                      } else if (RegExp(
                                              r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                          .hasMatch(value)) {
                                        return 'خطأ في اسم المستخدم';
                                      }
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            color = Color.fromARGB(
                                                255, 255, 150, 102);
                                          });
                                          phone = value;
                                        },
                                        cursorColor: color,
                                        style: TextStyle(
                                            fontSize: 18, color: color),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: -5, horizontal: 10),
                                          hintText: "رقم التليفون",
                                          hintStyle: TextStyle(
                                              fontSize: 18, color: color),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: color, width: 2)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: color, width: 2)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: color, width: 2)),
                                          errorStyle: TextStyle(
                                            fontSize: 13,
                                            color: Colors.red,
                                          ),
                                        ),
                                        validator: ((value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              color = Colors.red;
                                            });
                                            return 'من فضلك ادخل البيانات';
                                          }
                                          bool numberCheck = value.length ==
                                                      11 &&
                                                  value.startsWith("0122") ||
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

                                          if (!RegExp(r'^[0-9]+$')
                                                  .hasMatch(value) ||
                                              numberCheck == false) {
                                            setState(() {
                                              color = Colors.red;
                                            });
                                            return 'خطأ في ادخال رقم التليفون';
                                          }
                                        }),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "هذا الرقم يجب ان يكون عليه محفظة الكترونية (فودافون كاش - اورانج كاش .. الخ)",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        color =
                                            Color.fromARGB(255, 255, 150, 102);
                                      });
                                      money = value;
                                    },
                                    cursorColor: color,
                                    style:
                                        TextStyle(fontSize: 18, color: color),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: -5, horizontal: 10),
                                      hintText: "المبلغ",
                                      hintStyle:
                                          TextStyle(fontSize: 18, color: color),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: color, width: 2)),
                                      errorStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          color = Colors.red;
                                        });
                                        return 'من فضلك ادخل البيانات';
                                      }
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Color.fromARGB(255, 255, 150, 102),
                                  child: Image.asset(
                                    "images/72bb7c52-7531-4fcd-84bc-f5d5da823f3c-removebg-preview.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          sendData();
                                        }
                                      },
                                      child: Text(
                                        "تأكيد العملية",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 19),
                                      )),
                                ),
                              ]),
                        ),
                      ))),
        ));
  }
}
