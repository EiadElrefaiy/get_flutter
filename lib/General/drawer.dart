import 'package:flutter/material.dart';
import 'package:get_store/AboutUs/aboutUs.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/Profile/profile.dart';
import 'package:get_store/Settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String token = "";
  var results;

  Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
    var url = "http://app.getcenter.info/api/v1/users/logout";
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
      headers: {
        "Content-type": "Application/json;charset=UTF-8",
        "auth-token": token
      },
    );

    results = jsonDecode(response.body);

    if (results['statues'] == true) {
      prefs.setInt('isLoggedIn', 1);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Color.fromARGB(255, 240, 240, 240),
          width: double.infinity,
          height: 180,
          child: Image.asset(
            "images/logo.png",
            fit: BoxFit.fill,
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.home,
              color: Color.fromARGB(255, 255, 150, 102),
              size: 30,
            ),
            title: Text(
              "الرئيسية",
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 150, 102)),
            ),
            onTap: () {},
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.person,
              color: Color.fromARGB(255, 255, 150, 102),
              size: 30,
            ),
            title: Text(
              "حسابي",
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 150, 102)),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => Profile())));
            },
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.question_mark,
              color: Color.fromARGB(255, 255, 150, 102),
              size: 30,
            ),
            title: Text(
              "من نحن؟",
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 150, 102)),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => AboutUs())));
            },
          ),
        ),
        SizedBox(
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 22,
              ),
              height: 1.0,
              color: Color.fromARGB(255, 143, 143, 143),
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 255, 150, 102),
              size: 30,
            ),
            title: Text(
              "الاعدادات",
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 150, 102)),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => Settings())));
            },
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Color.fromARGB(255, 255, 150, 102),
              size: 30,
            ),
            title: Text(
              "تسجيل خروج",
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 150, 102)),
            ),
            onTap: () {
              Logout();
            },
          ),
        ),
      ],
    );
  }
}
