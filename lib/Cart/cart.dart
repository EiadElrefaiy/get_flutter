import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/Order/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'emptyCart.dart';

class Cart extends StatefulWidget {
  List<int> numbers = List<int>.generate(5, (int index) {
    return 1;
  });

  Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoading = false;
  var results;
  var deleteResults;
  int user_id = 0;
  int total = 0;
  String discount = "";

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
        var url = "http://app.getcenter.info/api/v1/pieces/get-cart-pieces";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"user_id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          for (int i = 0; i < results['cart'].length; i++) {
            widget.numbers[i] = 1;
          }
          total = results['total'];
          if (results['discount'] == 0) {
            discount = "الاجمالي";
          } else {
            discount = "الاجمالي بعد الخصم";
          }
          setState(() {
            isLoading = false;
          });
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
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }

  //http://192.168.1.4:8000/api/v1/pieces/delete-from-cart

  updateCart(int id, int quantity) async {
    try {
      var url = "http://app.getcenter.info/api/v1/pieces/update-cart-pieces";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "id": id,
          "quantity": quantity,
          "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
        }),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );
      if (response.statusCode != 200) {
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

  deleteFromCart(int id) async {
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/pieces/delete-from-cart";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"id": id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          deleteResults = jsonDecode(response.body);
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
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    total = total;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
      appBar: Appbar(),
      body: isLoading
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
              child: Column(
                children: [
                  Container(
                      color: Color.fromARGB(255, 240, 240, 240),
                      height: results['cart'].length == 0
                          ? screenHeight - (screenHeight / 17.5)
                          : screenHeight - (screenHeight / 5),
                      child: results['cart'].length == 0
                          ? EmptyCart()
                          : SingleChildScrollView(
                              child: Column(children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: results['cart'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 90,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${results['cart'][index]['picture'].toString()}",
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
                                            flex: 5,
                                            child: ListTile(
                                              title: Column(
                                                children: [
                                                  /*
                                              Text(
                                                "${results['categories'][index].toString()} - ${results['sizes'][index].toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                textDirection: TextDirection.rtl,
                                                ),
                                                */
                                                  Row(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: [
                                                        Text(results['cart']
                                                                    [index]
                                                                ['category']
                                                            .toString()),
                                                        Text(" - "),
                                                        Text(results['cart']
                                                                [index]['size']
                                                            .toString()),
                                                      ]),
                                                  Row(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (widget.numbers[
                                                                      index] ==
                                                                  1) {
                                                                widget.numbers[
                                                                        index] =
                                                                    widget.numbers[
                                                                        index];
                                                              } else {
                                                                widget.numbers[
                                                                        index] =
                                                                    widget.numbers[
                                                                            index] -
                                                                        1;
                                                                int price =
                                                                    results['cart']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'price'];
                                                                total = total -
                                                                    price;
                                                              }
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .do_not_disturb_on_sharp,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    150,
                                                                    102),
                                                          )),
                                                      Text(
                                                          " ${widget.numbers[index].toString()} "),
                                                      //Text(" 1 "),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            int quantity = int
                                                                .parse(results[
                                                                            'cart']
                                                                        [index][
                                                                    'quantity']);
                                                            if (widget.numbers[
                                                                    index] ==
                                                                quantity) {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "يوجد ${quantity.toString()} قطعة فقط لهذا المقاس",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 16,
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          800]);
                                                            } else {
                                                              widget.numbers[
                                                                      index] =
                                                                  widget.numbers[
                                                                          index] +
                                                                      1;
                                                              int price = int.parse(
                                                                  results['cart']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'price']);
                                                              total =
                                                                  total + price;
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add_circle,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              150,
                                                              102),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              subtitle: Text(
                                                "${results['cart'][index]['price'].toString()} جنيه",
                                                style: TextStyle(),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              leading: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  deleteFromCart(results['cart']
                                                      [index]['id']);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Cart()));
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "تم حذف القطعة من العربة",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      textColor: Colors.white,
                                                      fontSize: 16,
                                                      backgroundColor:
                                                          Colors.grey[800]);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]))),
                  results['cart'].length == 0
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(top: 3),
                          width: double.infinity,
                          height: screenHeight -
                              (screenHeight - (screenHeight / 7)),
                          color: Colors.white,
                          child: Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      discount,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 59, 59, 59)),
                                    ),
                                    Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          "$total جنيه",
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                        ))
                                  ],
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      bool check = connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi;
                                      if (check == true) {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setInt("order_total", total);

                                        for (int i = 0;
                                            i < results['cart'].length;
                                            i++) {
                                          print(results['cart'][i]['id']);
                                          print(widget.numbers[i]);
                                          updateCart(results['cart'][i]['id'],
                                              widget.numbers[i]);
                                        }
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Order())));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "خطأ في الاتصال",
                                            toastLength: Toast.LENGTH_SHORT,
                                            textColor: Colors.white,
                                            fontSize: 16,
                                            backgroundColor: Colors.grey[800]);
                                      }
                                    },
                                    child: Text(
                                      "انشاء طلب",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ]),
                        ),
                ],
              ),
            ),
    );
  }
}
