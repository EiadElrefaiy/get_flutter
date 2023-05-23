import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/Home/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../SingleShop/singleShop.dart';

class Advertisement extends StatefulWidget {
  Advertisement({Key? key}) : super(key: key);

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  CountDownController _controller = CountDownController();
  bool isLoading = false;
  bool isTimeEnded = false;
  var results;

  getadata() async {
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
    getadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.black,
                height: screenHeight,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${results['advertisement']['picture'].toString()}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              color: Color.fromARGB(255, 141, 141, 141),
                            ), //show this if state is loading
                          ],
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                        right: 20,
                        top: 50,
                        child: isTimeEnded == false
                            ? CircularCountDownTimer(
                                width: 45,
                                height: 45,
                                duration: 15,
                                fillColor: Colors.amber,
                                controller: _controller,
                                backgroundColor: Colors.white54,
                                strokeWidth: 5.0,
                                strokeCap: StrokeCap.butt,
                                isTimerTextShown: true,
                                isReverse: true,
                                onComplete: () {
                                  setState(() {
                                    isTimeEnded = true;
                                  });
                                },
                                textStyle: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                ringColor: Colors.white,
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: ((context) => Home())));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    width: 45,
                                    height: 45,
                                    child: Center(
                                        child: Icon(
                                      Icons.cancel,
                                      size: 30,
                                      color: Colors.black,
                                    ))),
                              )),
                    results['advertisement']['shop_id'] != 0
                        ? Positioned(
                            right: 20,
                            bottom: 10,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 150, 102)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: ((context) => SingleShop(
                                                shopId:
                                                    "${results['advertisement']['shop_id']}",
                                              ))));
                                },
                                child: Text(
                                  "عرض المحل",
                                  style: TextStyle(color: Colors.white),
                                )))
                        : Container()
                  ],
                ),
              ),
            ),
    ));
  }
}
