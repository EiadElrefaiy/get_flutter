import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/login.dart';
import 'package:get_store/prog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainview extends StatefulWidget {
  final Color mainColor = Color.fromARGB(255, 255, 150, 102);

  final double image_margin;
  final String image;
  final BoxFit boxFit;
  final String title;
  final String description;
  final double height1;
  final String button_title;
  final int tabNumber;
  final double height2;
  final Color point1_color;
  final Color point2_color;
  final Color point3_color;

  Mainview({
    Key? key,
    required this.image_margin,
    required this.image,
    required this.boxFit,
    required this.title,
    required this.description,
    required this.height1,
    required this.button_title,
    required this.tabNumber,
    required this.height2,
    required this.point1_color,
    required this.point2_color,
    required this.point3_color,
  }) : super(key: key);

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      //color: Color.fromARGB(255, 221, 219, 219),
      //rgb(253,247,187)
      color: Color.fromARGB(255, 249, 249, 249),
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: widget.image_margin),
              child: Image.asset(
                widget.image,
                fit: widget.boxFit,
              ),
            )),
        Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: Column(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: widget.mainColor),
                        ),
                        Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.mainColor),
                        ),
                        SizedBox(
                          height: widget.height1,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: widget.mainColor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            if (widget.tabNumber == 3) {
                              setLoggedIn() async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt("isLoggedIn", 1);
                              }

                              setLoggedIn();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => Login())));
                            } else {
                              DefaultTabController.of(context)
                                  ?.animateTo(widget.tabNumber);
                            }
                          },
                          child: Text(widget.button_title),
                        ),
                        SizedBox(
                          height: widget.height2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: widget.point1_color,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: widget.point2_color,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: widget.point3_color,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        )
                      ]),
                    )),
              ]),
            )),
      ]),
    ));
  }
}
