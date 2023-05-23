import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_store/Order/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cart.dart';

class EmptyCart extends StatefulWidget {
  List<int> numbers = List<int>.generate(5, (int index) {
    return 1;
  });

  EmptyCart({Key? key}) : super(key: key);

  @override
  State<EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: Color.fromARGB(255, 240, 240, 240),
                height: screenHeight - (screenHeight / 17.5),
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
                          Icons.shopping_cart,
                          size: 200,
                          color: Color.fromARGB(255, 255, 150, 102),
                        ),
                      ),
                      Text(
                        "العربة فارغة",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 255, 150, 102)),
                      )
                    ]))),
          ],
        ),
      ),
    );
  }
}
