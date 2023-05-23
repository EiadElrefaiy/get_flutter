import 'package:flutter/material.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/Profile/commision.dart';
import 'package:get_store/Profile/inviteCode.dart';
import 'package:get_store/Profile/payment.dart';
import 'package:get_store/Profile/userInfo.dart';
import 'package:get_store/Profile/userOrders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../Cart/cart.dart';
import '../General/appBar.dart';
import '../SingleShop/singleShop.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int user_id = 0;
  bool isLoading = false;
  var results;
  final _formKey = GlobalKey<FormState>();

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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        appBar: Appbar(),
        body: isLoading || results == null
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
                  color: Color.fromARGB(255, 240, 240, 240),
                  height: screenHeight - (screenHeight / 17.5),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Container(
                      height: screenHeight / 3.5,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              color: Color.fromARGB(255, 255, 150, 102),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 224, 130, 87),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: results["gender"] == 1
                                          ? Image.asset(
                                              "images/icons8-female-user-104.png",
                                              width: 20,
                                              height: 20,
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Color.fromARGB(
                                                  255, 240, 240, 240),
                                            )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    results['name'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: screenHeight - (screenHeight / 3.5) - 35,
                      child: DefaultTabController(
                          length: 3,
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 150, 102),
                              automaticallyImplyLeading: false,
                              bottomOpacity: 0.0,
                              elevation: 0.0,
                              title:
                                  TabBar(indicatorColor: Colors.white, tabs: [
                                Tab(
                                  child: Text("الحساب"),
                                ),
                                Tab(
                                  child: Text("الطلبات"),
                                ),
                                Tab(
                                  child: Text("العمولة"),
                                ),
                              ]),
                            ),
                            body: Container(
                              padding: EdgeInsets.all(10),
                              child: TabBarView(
                                children: [
                                  UserInfo(),
                                  UserOrders(),
                                  Commission(),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ])),
                ),
              ));
  }
}
