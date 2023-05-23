import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ffi';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserOrders extends StatefulWidget {
  UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  int user_id = 0;
  bool isLoading = false;
  var results;
  var moreOrdersResuls;
  List<Order> orders = [];
  late ScrollController _controller = ScrollController();
  int pages = 1;
  int orders_count = 0;

  getOrders(int page) async {
    page = pages;
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

        var url = "http://app.getcenter.info/api/v1/orders/get-order-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "id": user_id,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);

          for (int i = 0; i < results["orders"]['data'].length; i++) {
            Order order = new Order(
              int.parse(results["orders"]["data"][i]['id'].toString()),
              int.parse(results["orders"]["data"][i]['done']),
              results["orders"]["data"][i]['date'].toString(),
              results["orders"]["data"][i]['pieces'],
              int.parse(results["orders"]["data"][i]['delivery']),
              double.parse(results["orders"]["data"][i]['total']),
              double.parse(
                  results["orders"]["data"][i]['total_after_throwback']),
            );
            orders.add(order);
          }
          orders_count = results["orders_count"];
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

  getMoreOrders(int page) async {
    pages = pages + 1;
    page = pages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;

        var url = "http://app.getcenter.info/api/v1/orders/get-order-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "id": user_id,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          moreOrdersResuls = jsonDecode(response.body);

          for (int i = 0; i < moreOrdersResuls["orders"]['data'].length; i++) {
            Order order = new Order(
              int.parse(moreOrdersResuls["orders"]["data"][i]['id'].toString()),
              int.parse(moreOrdersResuls["orders"]["data"][i]['done']),
              moreOrdersResuls["orders"]["data"][i]['date'].toString(),
              moreOrdersResuls["orders"]["data"][i]['pieces'],
              int.parse(
                moreOrdersResuls["orders"]["data"][i]['delivery'],
              ),
              double.parse(moreOrdersResuls["orders"]["data"][i]['total']),
              double.parse(moreOrdersResuls["orders"]["data"][i]
                  ['total_after_throwback']),
            );
            setState(() {
              orders.add(order);
            });
          }
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
  }

  _scrollListener() {
    if (_controller.position.extentAfter == 0) {
      if (pages == orders_count) {
        setState(() {
          getMoreOrders(pages);
        });
      } else {
        getMoreOrders(pages);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrders(pages);
    _controller.addListener(_scrollListener);

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
          : Container(
              child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: false,
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int i) {
                    return pages <= orders_count &&
                            orders_count != 1 &&
                            i == orders.length - 1
                        ? Column(
                            children: [
                              Card(
                                child: Column(children: [
                                  Text(
                                    "رقم الاوردر ${orders[i].id}",
                                    style: TextStyle(
                                        fontSize: 21,
                                        color:
                                            Color.fromARGB(255, 255, 150, 102)),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          orders[i].done == 0
                                              ? "في انتظار التأكيد"
                                              : orders[i].done == 1
                                                  ? "في انتظار التوصيل"
                                                  : orders[i].done == 2
                                                      ? "تم الاستلام"
                                                      : "لم يتم الاستلام",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102)),
                                        ),
                                        Text(
                                          orders[i].date,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orders[i].pieces.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 80,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${orders[i].pieces[index]['picture'].toString()}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: ListTile(
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        children: [
                                                          Text(orders[i]
                                                              .pieces[index]
                                                                  ['category']
                                                              .toString()),
                                                          orders[i].done == 2
                                                              ? int.parse(orders[i]
                                                                              .pieces[index]
                                                                          [
                                                                          'done']) ==
                                                                      1
                                                                  ? Container(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    )
                                                              : Container(),
                                                          Text(orders[i]
                                                              .pieces[index]
                                                                  ['size']
                                                              .toString()),
                                                        ]),
                                                  ],
                                                ),
                                                subtitle: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${orders[i].pieces[index]['price'].toString()} جنيه",
                                                        style: TextStyle(),
                                                      ),
                                                      Text(
                                                          "${orders[i].pieces[index]['quantityInOrder'].toString()} قطعة")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "تكلفة الشحن ${orders[i].delivery} جنيه",
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Row(
                                          children: [
                                            Text(
                                              "الاجمالي : ",
                                            ),
                                            orders[i].done == 2
                                                ? Text(
                                                    "${orders[i].total_after_throwback + orders[i].delivery} جنيه",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                    ),
                                                  )
                                                : Text(
                                                    "${orders[i].total + orders[i].delivery} جنيه",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(
                                    color: Color.fromARGB(255, 255, 150, 102),
                                  ), //show this if state is loading
                                ],
                              ))
                            ],
                          )
                        : Card(
                            child: Column(children: [
                              Text(
                                "رقم الاوردر ${orders[i].id}",
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Color.fromARGB(255, 255, 150, 102)),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      orders[i].done == 0
                                          ? "في انتظار التأكيد"
                                          : orders[i].done == 1
                                              ? "في انتظار التوصيل"
                                              : orders[i].done == 2
                                                  ? "تم الاستلام"
                                                  : "لم يتم الاستلام",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102)),
                                    ),
                                    Text(
                                      orders[i].date,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102)),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orders[i].pieces.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 80,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${orders[i].pieces[index]['picture'].toString()}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: ListTile(
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    children: [
                                                      Text(orders[i]
                                                          .pieces[index]
                                                              ['category']
                                                          .toString()),
                                                      orders[i].done == 2
                                                          ? int.parse(orders[i]
                                                                              .pieces[
                                                                          index]
                                                                      [
                                                                      'done']) ==
                                                                  1
                                                              ? Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 20,
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 20,
                                                                  ),
                                                                )
                                                          : Container(),
                                                      Text(orders[i]
                                                          .pieces[index]['size']
                                                          .toString()),
                                                    ]),
                                              ],
                                            ),
                                            subtitle: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${orders[i].pieces[index]['price'].toString()} جنيه",
                                                    style: TextStyle(),
                                                  ),
                                                  Text(
                                                      "${orders[i].pieces[index]['quantityInOrder'].toString()} قطعة")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "تكلفة الشحن ${orders[i].delivery} جنيه",
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Row(
                                      children: [
                                        Text(
                                          "الاجمالي : ",
                                        ),
                                        orders[i].done == 2
                                            ? Text(
                                                "${orders[i].total_after_throwback + orders[i].delivery} جنيه",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                ),
                                              )
                                            : Text(
                                                "${orders[i].total + orders[i].delivery} جنيه",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          );
                  }),
            ),
    );
  }
}

class Order {
  final int id;
  final int done;
  final String date;
  final List<dynamic> pieces;
  final int delivery;
  final double total;
  final double total_after_throwback;
  Order(this.id, this.done, this.date, this.pieces, this.delivery, this.total,
      this.total_after_throwback);
}
