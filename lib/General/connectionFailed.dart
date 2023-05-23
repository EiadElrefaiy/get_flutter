import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:get_store/Order/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectionFaield extends StatefulWidget {
  ConnectionFaield({Key? key}) : super(key: key);

  @override
  State<ConnectionFaield> createState() => _ConnectionFaieldState();
}

class _ConnectionFaieldState extends State<ConnectionFaield> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                color: Color.fromARGB(255, 240, 240, 240),
                width: double.infinity,
                height: screenHeight,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      SizedBox(
                        height: screenHeight / 2 - 170,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        height: 200,
                        width: 300,
                        child: Icon(
                          Icons.wifi_off,
                          size: 200,
                          color: Colors.red,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "خطأ في الاتصال",
                            style: TextStyle(
                                fontSize: 25,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            "توجد مشكلة في الاتصال بالسيرفر او فشل الاتصال بالانترنت",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 142, 142, 142),
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 70),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            "حاول مجددا",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                    ]))),
          ],
        ),
      ),
    );
  }
}
