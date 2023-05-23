import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/Auth/registeration/updatePassword.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class SmsVerification extends StatefulWidget {
  final String signUpOrForget;
  SmsVerification({Key? key, required this.signUpOrForget}) : super(key: key);

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  late FocusNode myFocusNode1;
  late FocusNode myFocusNode2;
  late FocusNode myFocusNode3;
  late FocusNode myFocusNode4;
  late FocusNode myFocusNode5;
  late FocusNode myFocusNode6;
  late FocusNode myFocusNode7;

  String? username = "";
  String? date_of_birth = "";
  String? phone = "";
  int? gender = 0;
  double? weight = 0;
  double? height = 0;
  String? state = "";
  String? center = "";
  String? address = "";
  String? password = "";
  String? friend_invitation_id = "";
  String? invitation_id = "";

  String? verificationCode = "";

  bool isLoading = false;
  bool isSmsSending = false;
  bool isInvaledCode = false;

  var code = ["", "", "", "", "", ""];

  getPrefs() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString("name");
      date_of_birth = prefs.getString("birthdate");
      phone = prefs.getString("phone");
      gender = prefs.getInt("gender");
      weight = prefs.getDouble("weight");
      height = prefs.getDouble("height");
      state = prefs.getString("state");
      center = prefs.getString("center");
      address = prefs.getString("address");
      password = prefs.getString("password");
      friend_invitation_id = prefs.getString("friend_invitation_id");

      Random random = new Random();
      int randomNumber = 0;
      for (int i = 1; i <= 14; i++) {
        randomNumber = random.nextInt(10); // from 0 upto 9 included
        invitation_id = invitation_id! + randomNumber.toString();
      }

      print("username: " + "$username");
      print("birthdate: " + "$date_of_birth");
      print("phone: " + "$phone");
      print("gender: " + "$gender");
      print("weight: " + "$weight");
      print("height: " + "$height");
      print("state: " + "$state");
      print("center: " + "$center");
      print("address: " + "$address");
      print("password: " + "$password");
      print("friend_invitation_id: " + "$friend_invitation_id");
      print("invitation_id: " + "$invitation_id");
      VerifiyCode();
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }

  addUsers() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/users/add";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "name": "$username",
            "date_of_birth": "$date_of_birth",
            "mobile_number": "$phone",
            "gender": gender,
            "state": "$state",
            "center": "$center",
            "address": "$address",
            "password": "$password",
            "friend_invitation_id": "$friend_invitation_id",
            "invitation_id": "$invitation_id",
            "money": 0,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);

          print(responseBody);

          clearPrefs() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
          }

          clearPrefs();
          return responseBody;
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

  TwilioPhoneVerify _twilioPhoneVerify = new TwilioPhoneVerify(
      accountSid:
          'ACc27766a962f3bb94fe36d159f77c1333', // replace with Account SID
      authToken: '3026350bc627429bf25685ccd4b5f4f8', // replace with Auth Token
      serviceSid:
          'VA07a5dbfd484d24e54bb8c5f0364e029a' // replace with Service SID
      );

  SendCode(String SignUpOrForget) async {
    setState(() {
      isSmsSending = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      var twilioResponse = await _twilioPhoneVerify.sendSmsCode('+2$phone');
      bool? successful = twilioResponse.successful;
      if (successful == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => SmsVerification(
                  signUpOrForget: SignUpOrForget,
                ))));
      } else {
        setState(() {
          isSmsSending = false;
        });
        print("error in verification");
      }
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }

  VerifiyCode() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      for (int i = 0; i <= code.length - 1; i++) {
        verificationCode = verificationCode! + code[i];
      }
      var twilioResponse = await _twilioPhoneVerify.verifySmsCode(
          phone: '+2$phone', code: '$verificationCode');
      bool? successful = twilioResponse.successful;
      if (successful == true) {
        if (twilioResponse.verification?.status ==
            VerificationStatus.approved) {
          if (widget.signUpOrForget == "signUp") {
            addUsers();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => UpdatePassword())));
          }
        } else {
          setState(() {
            isInvaledCode = true;
          });
          //print('Invalid code');
        }
      } else {
        //print(twilioResponse.errorMessage);
        setState(() {
          isInvaledCode = true;
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
  }

  login(String name, String password) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url = "http://app.getcenter.info/api/v1/users/login-forget";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "name": name,
            "password": password,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setDataAndToken() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token", responseBody['user']['api_token']);
              prefs.setInt("id", responseBody['user']['id']);
              prefs.setString("name", responseBody['user']['name']);
              prefs.setString(
                  "birthdate", responseBody['user']['date_of_birth']);
              prefs.setString("phone", responseBody['user']['mobile_number']);
              prefs.setInt("gender", responseBody['user']['gender']);
              prefs.setString("state", responseBody['user']['state']);
              prefs.setString("center", responseBody['user']['center']);
              prefs.setString("address", responseBody['user']['address']);
              prefs.setString("friend_invitation_id",
                  responseBody['user']['friend_invitation_id']);
              prefs.setString(
                  "invitation_id", responseBody['user']['invitation_id']);

              int money = 0;
              money = responseBody['user']['money'];
              prefs.setDouble("money", double.parse(money.toString()));

              prefs.setString("token", responseBody['user']['api_token']);

              prefs.setInt("isLoggedIn", 2);

              print(prefs.getString("token"));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            }

            setDataAndToken();
          } else {
            setState(() {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: "فشل تسجيل الدخول",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.grey[800]);
            });
          }
          return responseBody;
        } else {
          Fluttertoast.showToast(
              msg: "فشل تسجيل الدخول",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } catch (e) {
        print(e);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode1 = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
    myFocusNode4 = FocusNode();
    myFocusNode5 = FocusNode();
    myFocusNode6 = FocusNode();
    myFocusNode7 = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 150, 102),
        title: Text(
          "تأكيد الحساب",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 150, 102),
                  ), //show this if state is loading
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
              color: Color.fromARGB(255, 249, 249, 249),
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Icon(
                      Icons.mail_outline,
                      size: 230,
                      color: Color.fromARGB(255, 255, 150, 102),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode1,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 219, 219, 219),
                                filled: true),
                            onChanged: ((value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[0] = value;
                                myFocusNode2.requestFocus();
                              }
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode2,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 219, 219, 219),
                                filled: true),
                            onChanged: (value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[1] = value;
                                myFocusNode3.requestFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode3,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 219, 219, 219),
                                filled: true),
                            onChanged: (value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[2] = value;
                                myFocusNode4.requestFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode4,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              filled: true,
                            ),
                            onChanged: (value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[3] = value;
                                myFocusNode5.requestFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode5,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              filled: true,
                            ),
                            onChanged: (value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[4] = value;
                                myFocusNode6.requestFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            focusNode: myFocusNode6,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 28),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              filled: true,
                            ),
                            onChanged: (value) {
                              //verificationCode = verificationCode! + value;
                              if (value != "") {
                                code[5] = value;
                                myFocusNode7.requestFocus();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    isInvaledCode
                        ? Text(
                            "الكود الذي ادخلته غير صحيح",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )
                        : Text(""),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Text(
                          "سيتم ارسال رمز عن طريق sms لتأكيد الحساب",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 255, 150, 102),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          backgroundColor: Color.fromARGB(255, 255, 150, 102),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {
                          if (widget.signUpOrForget == "signUp") {
                            getPrefs();
                          } else {
                            VerifiyCode();
                          }
                        },
                        child: Text(
                          "تأكيد",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                      height: 18,
                    ),
                    InkWell(
                      onTap: (() {
                        if (widget.signUpOrForget == "signUp") {
                          SendCode("signUp");
                        } else {
                          SendCode("forget");
                        }
                      }),
                      child: isSmsSending
                          ? CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 150, 102),
                            )
                          : Text(
                              "اعادة ارسال الرمز",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 150, 102),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )
                  ]),
            )),
    );
  }
}
