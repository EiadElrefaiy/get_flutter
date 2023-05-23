import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ffi';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InviteCode extends StatefulWidget {
  InviteCode({Key? key}) : super(key: key);

  @override
  State<InviteCode> createState() => _InviteCodeState();
}

class _InviteCodeState extends State<InviteCode> {
  int user_id = 0;
  bool isLoading = false;
  var results;

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
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 240, 240, 240),
                      height: screenHeight - (screenHeight / 17.5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "كود الدعوة",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 150, 102),
                                  fontSize: 30),
                            ),
                            Icon(
                              Icons.mail,
                              size: 280,
                              color: Color.fromARGB(255, 255, 150, 102),
                            ),
                            Text(
                              "قم بدعوة اصدقائك و اربح معانا",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25),
                            ),
                            Text(
                                "يمكنك دعوة اصدقائك والحصول على 5% عمولة من كل اوردر عن طريقهم",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18)),
                            TextFormField(
                              readOnly: true,
                              initialValue: results['invitation_id'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 150, 102)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102),
                                        width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102),
                                        width: 2)),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 150, 102),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: results['invitation_id']
                                            .toString()));
                                    Fluttertoast.showToast(
                                        msg: "تم نسخ الكود",
                                        toastLength: Toast.LENGTH_SHORT,
                                        textColor: Colors.white,
                                        fontSize: 16,
                                        backgroundColor: Colors.grey[800]);
                                  },
                                  child: Text(
                                    "نسخ الكود",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  )),
                            ),
                          ])))),
    );
  }
}
