import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/forgetPhone.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/Auth/registeration/main/components/textformfieldCompnent.dart.dart';
import 'package:get_store/Auth/registeration/register1.dart';
import 'package:get_store/Auth/registeration/slider_register.dart';
import 'package:get_store/Auth/registeration/verification.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class MainView extends StatefulWidget {
  final Widget content;
  final String title;
  final String buttonText;
  final int btnClick;
  final String RegisterOrLogin;
  bool RememberPass = false;
  MainView(
      {Key? key,
      required this.content,
      required this.title,
      required this.btnClick,
      required this.buttonText,
      required this.RegisterOrLogin,
      bool? RememberPass})
      : super(key: key);

  @override
  State<MainView> createState() => _RegisterState();
}

class _RegisterState extends State<MainView> {
  String? phone = "";
  String? name_login = "";
  String? pass_login = "";
  String? friend_invitation_id = "";
  bool CheckInvCode = false;
  bool checkInvValue = false;
  bool checkedValue = false;
  bool isLoading = false;

  int isloggedIn = 0;

  getPrefs() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      friend_invitation_id = prefs.getString("friend_invitation_id");

      print("phone: " + "$phone");
      print("friend_invitation_id: " + "$friend_invitation_id");

      checkFriendInvitationId();
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      print(phone);
      var twilioResponse = await _twilioPhoneVerify.sendSmsCode('+2$phone');
      bool? successful = twilioResponse.successful;
      if (successful == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => SmsVerification(
                  signUpOrForget: SignUpOrForget,
                ))));
      } else {
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

  checkFriendInvitationId() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url =
            "http://app.getcenter.info/api/v1/users/get-user-invitation-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "friend_invitation_id": "$friend_invitation_id",
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print(friend_invitation_id);
          print(responseBody['msg']);
          // var itemCount = jsonResponse['totalItems'];
          if (responseBody['msg'] == "user existed") {
            SendCode("signUp");
            DefaultTabController.of(context)?.animateTo(4);
          } else {
            setState(() {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: "خطأ في كود الدعوة",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.grey[800]);
            });
          }
          return responseBody;
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

  getPrefsLogin(String log) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      name_login = prefs.getString("name_login");
      pass_login = prefs.getString("pass_login");
      login(log);
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }

  checkForget() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        phone = prefs.getString("phone");
        print(phone);

        var url = "http://app.getcenter.info/api/v1/users/check-forget";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "mobile_number": "${phone}",
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody["statues"] == true) {
            prefs.setString(
                "name_login", responseBody["user"][0]["name"].toString());
            SendCode("forget");
          } else {
            Fluttertoast.showToast(
                msg: "الرقم غير موجود",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.grey[800]);
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
      } catch (e) {
        print(e);
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

  login(String log) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url = "http://app.getcenter.info/api/v1/users/login";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "name": "$name_login",
            "password": "$pass_login",
            "log": log,
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
              prefs.setInt("gender", int.parse(responseBody['user']['gender']));
              prefs.setString("state", responseBody['user']['state']);
              prefs.setString("center", responseBody['user']['center']);
              prefs.setString("address", responseBody['user']['address']);
              prefs.setString("friend_invitation_id",
                  responseBody['user']['friend_invitation_id']);
              prefs.setString(
                  "invitation_id", responseBody['user']['invitation_id']);

              int money = 0;
              money = int.parse(responseBody['user']['money']);
              prefs.setDouble("money", double.parse(money.toString()));

              prefs.setString("token", responseBody['user']['api_token']);

              prefs.setInt("isLoggedIn", 2);

              print(prefs.getString("token"));

              if (prefs.getBool("remember") == true) {
                prefs.setString("rememberName", name_login!);
                prefs.setString("rememberPass", pass_login!);
              } else {
                prefs.setString("rememberName", "");
                prefs.setString("rememberPass", "");
              }

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
                  msg: "خطأ في اسم المستخدم او كلمة السر",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.grey[800]);
            });
          }
          return responseBody;
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
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Form(
                      key: _formKey,
                      child: Container(
                        color: Color.fromARGB(255, 249, 249, 249),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 240,
                              width: double.infinity,
                              child: Image.asset(
                                "images/logo.png",
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 255, 150, 102),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                children: [
                                  widget.content,

                                  //content

                                  SizedBox(
                                    height: 25,
                                  ),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder(),
                                        primary:
                                            Color.fromARGB(255, 255, 150, 102),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (widget.btnClick == 5) {
                                          getPrefsLogin("login");
                                        } else if (widget.btnClick == 4) {
                                          getPrefs();
                                        } else if (widget.btnClick == 6) {
                                          checkForget();
                                        } else if (widget.btnClick == 7) {
                                          getPrefsLogin("forget");
                                        } else {
                                          DefaultTabController.of(context)
                                              ?.animateTo(widget.btnClick);
                                        }
                                      }
                                    },
                                    child: Text(widget.buttonText),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  InkWell(
                                    child: Text(widget.RegisterOrLogin,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 150, 102),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    onTap: () {
                                      if (widget.RegisterOrLogin ==
                                          "انشاء حساب") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    SliderRegister())));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Login())));
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
  }
}
