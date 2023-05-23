import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/Advertisement/advertisement.dart';
import 'package:get_store/Auth/intro/slider_intro.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectionFailed.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int timeout = 0;
  bool isLoading = false;
  var results;

  getdata() async {
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/admins/show-advertisement";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({"api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          Timer(Duration(seconds: 5), () {
            timeout = 1;
            setState(() {});
          });
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

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Color.fromARGB(255, 240, 240, 240),
            child: Image.asset(
              "images/logo.png",
            ))
        : timeout == 0
            ? Container(
                color: Color.fromARGB(255, 240, 240, 240),
                child: Image.asset(
                  "images/logo.png",
                ))
            : FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (BuildContext context,
                    AsyncSnapshot<SharedPreferences> prefs) {
                  var x = prefs.data;
                  if (prefs.hasData) {
                    if (x?.getInt('isLoggedIn') != null) {
                      if (x?.getInt('isLoggedIn') == 1) {
                        return MaterialApp(
                          home: Login(),
                          debugShowCheckedModeBanner: false,
                        );
                      } else
                        return MaterialApp(
                          home: results['advertisement'].length == 0
                              ? Home()
                              : Advertisement(),
                          debugShowCheckedModeBanner: false,
                        );
                    }
                  }
                  return MaterialApp(
                    home: SliderIntro(),
                    debugShowCheckedModeBanner: false,
                  );
                });
  }
}
