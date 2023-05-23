import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_store/Cart/cart.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/Order/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:dart_date/dart_date.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserNotification extends StatefulWidget {
  UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  bool isLoading = false;
  var results;
  var moreNotificationsResults;
  int user_id = 0;
  List<_Notification> notifications = [];
  late ScrollController _controller = ScrollController();
  int pages = 1;
  int notification_count = 0;

  getNotifications(int page) async {
    setState(() {
      isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user_id = prefs.getInt("id")!;
      var url = "http://app.getcenter.info/api/v1/users/notification";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "user_id": user_id,
          "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
          "page": page
        }),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        results = jsonDecode(response.body);
        for (int i = 0; i < results["notification"]["data"].length; i++) {
          _Notification notification = new _Notification(
            int.parse(results["notification"]["data"][i]["user_id"]),
            results["notification"]["data"][i]["msg"].toString(),
            results["notification"]["data"][i]["kind"].toString(),
            int.parse(results["notification"]["data"][i]["readNot"]),
            results["notification"]["data"][i]["created_at"].toString(),
          );
          notifications.add(notification);
        }
        notification_count = results["notification_count"];
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
    setState(() {
      isLoading = false;
    });
  }

  getMoreNotifications(int page) async {
    pages = pages + 1;
    page = pages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;
        var url = "http://app.getcenter.info/api/v1/users/notification";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "user_id": user_id,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          moreNotificationsResults = jsonDecode(response.body);

          for (int i = 0;
              i < moreNotificationsResults["notification"]["data"].length;
              i++) {
            _Notification notification = new _Notification(
              moreNotificationsResults["notification"]["data"][i]["user_id"],
              moreNotificationsResults["notification"]["data"][i]["msg"]
                  .toString(),
              moreNotificationsResults["notification"]["data"][i]["kind"]
                  .toString(),
              moreNotificationsResults["notification"]["data"][i]["readNot"],
              moreNotificationsResults["notification"]["data"][i]["created_at"]
                  .toString(),
            );
            setState(() {
              notifications.add(notification);
            });
          }
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
  }

  String notificationTime(String stringdate) {
    DateTime date = DateTime.parse(stringdate);
    DateTime now = DateTime.now();
    String time = "";
    if (date.isSameMonth(now)) {
      if (date.isSameDay(now) || now.difference(date).inDays == 0) {
        if (date.isSameHour(now) || now.difference(date).inHours == 0) {
          if (date.isSameMinute(now) || now.difference(date).inMinutes == 0) {
            if (now.difference(date).inSeconds < 3) {
              time = "الان";
            } else {
              if (now.difference(date).inSeconds >= 3 &&
                  now.difference(date).inSeconds <= 10) {
                time = "منذ ${now.difference(date).inSeconds} ثواني";
              } else {
                time = "منذ ${now.difference(date).inSeconds} ثانية";
              }
            }
          } else {
            if (now.difference(date).inSeconds <= 10) {
              if (now.difference(date).inSeconds == 1) {
                time = "منذ دقيقة";
              } else if (now.difference(date).inSeconds == 2) {
                time = "منذ دقيقتان";
              } else {
                time = "منذ ${now.difference(date).inMinutes} دقائق";
              }
            } else {
              time = "منذ ${now.difference(date).inMinutes} دقيقة";
            }
          }
        } else {
          if (now.difference(date).inHours <= 10) {
            if (now.difference(date).inHours == 1) {
              time = "منذ ساعة";
            } else if (now.difference(date).inHours == 2) {
              time = "منذ ساعتان";
            } else {
              time = "منذ ${now.difference(date).inHours} ساعات";
            }
          } else {
            time = "منذ ${now.difference(date).inHours} ساعة";
          }
        }
      } else {
        if (now.difference(date).inDays <= 10) {
          if (now.difference(date).inDays == 1) {
            time = "منذ يوم";
          } else if (now.difference(date).inDays == 2) {
            time = "منذ يومين";
          } else {
            time = "منذ ${now.difference(date).inDays} ايام";
          }
        } else {
          time = "منذ ${now.difference(date).inDays} يوم";
        }
      }
    } else {
      time = intl.DateFormat('yyyy-MM-dd').format(date);
    }
    return time;
  }

  String msg(String msg) {
    List<String> splitMsg = msg.split(" ");
    splitMsg[0] = "لقد قمت";
    splitMsg.removeAt(1);
    String finalMsg = "";
    for (int i = 0; i < splitMsg.length; i++) {
      finalMsg += splitMsg[i] + " ";
    }
    return finalMsg.toString();
  }

  _scrollListener() {
    if (_controller.position.extentAfter == 0) {
      if (pages == notification_count) {
        setState(() {
          getMoreNotifications(pages);
        });
      } else {
        getMoreNotifications(pages);
      }
    }
  }

  @override
  void initState() {
    getNotifications(pages);
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        appBar: Appbar(),
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
              : Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          color: Color.fromARGB(255, 240, 240, 240),
                          height: screenHeight - (screenHeight / 17.5),
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: ListView.builder(
                                controller: _controller,
                                shrinkWrap: true,
                                itemCount: notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return pages <= notification_count &&
                                          notification_count != 1 &&
                                          index == notifications.length - 1
                                      ? Column(
                                          children: [
                                            Card(
                                              child: Row(
                                                textDirection:
                                                    TextDirection.rtl,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                        height: 90,
                                                        child: Center(
                                                          child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          150,
                                                                          102),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              150)),
                                                              child: notifications[
                                                                              index]
                                                                          .kind ==
                                                                      "order"
                                                                  ? Icon(
                                                                      Icons
                                                                          .list_alt,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 40,
                                                                    )
                                                                  : notifications[index]
                                                                              .kind ==
                                                                          "sign_up"
                                                                      ? Icon(
                                                                          Icons
                                                                              .person_add,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              40,
                                                                        )
                                                                      : notifications[index].kind ==
                                                                              "commession"
                                                                          ? Icon(
                                                                              Icons.money,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            )
                                                                          : Icon(
                                                                              Icons.check_circle,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            )),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    flex: 6,
                                                    child: ListTile(
                                                      title: notifications[
                                                                      index]
                                                                  .user_id ==
                                                              user_id
                                                          ? Text(
                                                              msg(notifications[
                                                                      index]
                                                                  .msg),
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          150,
                                                                          102)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 3,
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            )
                                                          : Text(
                                                              notifications[
                                                                      index]
                                                                  .msg,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          150,
                                                                          102)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 3,
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                            ),
                                                      subtitle: InkWell(
                                                        child: Text(
                                                          notificationTime(
                                                              notifications[
                                                                      index]
                                                                  .created_at),
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    150,
                                                                    102),
                                                          ),
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CircularProgressIndicator(
                                                    color: Color.fromARGB(
                                                        255, 255, 150, 102),
                                                  ), //show this if state is loading
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : Card(
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                    height: 90,
                                                    child: Center(
                                                      child: Container(
                                                          width: 70,
                                                          height: 70,
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      150,
                                                                      102),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          150)),
                                                          child: notifications[
                                                                          index]
                                                                      .kind ==
                                                                  "order"
                                                              ? Icon(
                                                                  Icons
                                                                      .list_alt,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 40,
                                                                )
                                                              : notifications[index]
                                                                          .kind ==
                                                                      "sign_up"
                                                                  ? Icon(
                                                                      Icons
                                                                          .person_add,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          177,
                                                                          177),
                                                                      size: 40,
                                                                    )
                                                                  : notifications[index]
                                                                              .kind ==
                                                                          "commession"
                                                                      ? Icon(
                                                                          Icons
                                                                              .money,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              40,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              40,
                                                                        )),
                                                    )),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: ListTile(
                                                  title: notifications[index]
                                                              .user_id ==
                                                          user_id
                                                      ? Text(
                                                          msg(notifications[
                                                                  index]
                                                              .msg),
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      150,
                                                                      102)),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        )
                                                      : Text(
                                                          notifications[index]
                                                              .msg,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      150,
                                                                      102)),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                        ),
                                                  subtitle: InkWell(
                                                    child: Text(
                                                      notificationTime(
                                                          notifications[index]
                                                              .created_at),
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 150, 102),
                                                      ),
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
        ));
  }
}

class _Notification {
  final int user_id;
  final String msg;
  final String kind;
  final int readNot;
  final String created_at;
  _Notification(
      this.user_id, this.msg, this.kind, this.readNot, this.created_at);
}
