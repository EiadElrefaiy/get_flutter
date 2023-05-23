import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isLoading = false;
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
        var url = "http://app.getcenter.info/api/v1/shops/get-shops";
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
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(children: [
                            Text(
                              "نبذة عنا",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 150, 102),
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              "- تطبيق get بيساعدك انك تشوف الملابس المعروضة في المحلات من غير ما تضطر تنزل تلف",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  //color: Color.fromARGB(255, 255, 150, 102),
                                  fontSize: 18),
                            ),
                            Text(
                              "- تطبيق get هيوصلك اوردرك لحد باب بيتك والمعاينة عند الاستلام",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  //color: Color.fromARGB(255, 255, 150, 102),
                                  fontSize: 18),
                            ),
                            Text(
                              "- تطبيق get هيخليك كمان تكسب فلوس عن طريقك دعوة اصدقائك انهم يسجلوا في التطبيق و مع كل اوردر عن طريقهم هينزلك عمولة 5 جنيه على كل قطعة",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  //color: Color.fromARGB(255, 255, 150, 102),
                                  fontSize: 18),
                            ),
                          ]),
                        ),
                        /*
                           Column(
                             children: [
                               Text(
                                "شركائنا",
                                textAlign : TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102),
                                    fontSize: 30),
                          ),
                              Container(
                              height: 75,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: results.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return  Container(
                                                margin: EdgeInsets.symmetric(horizontal: 5),
                                                child: 
                                                ClipRRect(
                                                       borderRadius: BorderRadius.circular(50.0),
                                                  child: Image.network(
                                                      results['data'][i]["logo"].toString() ,
                                                      width: 75,
                                                      fit: BoxFit.fill,
                                                      ),
                                                ),
                                              );
                                }
                              ),
                            ),
                          ],
                        ),
                          */
                        Column(
                          children: [
                            Text(
                              "تواصل معنا",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 150, 102),
                                  fontSize: 25),
                            ),
                            Container(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          "https://cdn2.downdetector.com/static/uploads/logo/FB-f-Logo__blue_512.png",
                                          width: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          "https://play-lh.googleusercontent.com/bYtqbOcTYOlgc6gqZ2rwb8lptHuwlNE75zYJu6Bn076-hTmvd96HH-6v7S0YUAAJXoJN",
                                          width: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Instagram-Icon.png/800px-Instagram-Icon.png",
                                          width: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          "https://open-store.io/icons/telegram.web/telegram.web-1.0.0.png",
                                          width: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ))));
  }
}
