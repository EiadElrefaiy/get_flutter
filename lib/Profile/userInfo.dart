import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ffi';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserInfo extends StatefulWidget {
  UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int user_id = 0;
  bool isLoading = false;
  var results;
  bool online = true;

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
        var url = "http://app.getcenter.info/api/v1/users/get-user-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading || results == null
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
                //physics: NeverScrollableScrollPhysics(),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اسم المستخدم",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 150, 102)),
                            ),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText: results['name'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("تاريخ الميلاد",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText:
                                        results['date_of_birth'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("رقم التليفون",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText:
                                        results['mobile_number'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("المحافظة",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText: results['state'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("المركز",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText: results['center'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("العنوان",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText: results['address'].toString()),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("النوع",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102))),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 143, 143, 143),
                                            width: 1)),
                                    hintText: results['gender'] == 1
                                        ? "ذكر"
                                        : "انثى"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
