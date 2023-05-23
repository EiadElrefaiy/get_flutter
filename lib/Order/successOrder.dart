import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:get_store/Order/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SuccessOrder extends StatefulWidget {
  SuccessOrder({Key? key}) : super(key: key);

  @override
  State<SuccessOrder> createState() => _SuccessOrderState();
}

class _SuccessOrderState extends State<SuccessOrder> {
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
                          Icons.check_circle,
                          size: 200,
                          color: Color.fromARGB(255, 255, 150, 102),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "تم تأكيد الاوردر",
                            style: TextStyle(
                                fontSize: 25,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            "سيتم التواصل مع مندوبنا في اقرب وقت",
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
                            backgroundColor: Color.fromARGB(255, 255, 150, 102),
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
                            "تم",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                    ]))),
          ],
        ),
      ),
    );
  }
}
