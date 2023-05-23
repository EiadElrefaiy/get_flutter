import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_store/Cart/cart.dart';
import 'package:get_store/General/localization.dart';
import 'package:get_store/Notification/notification.dart';
import 'package:get_store/SingleShop/singleShop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

var results;
var resultCart;
var resultShops;

class Appbar extends AppBar {
  Appbar({Key? key}) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  StreamController _streamController = StreamController();
  late Timer _timer;
  bool isLoading = false;
  int user_id = 0;

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user_id = prefs.getInt("id")!;
      var url = "http://app.getcenter.info/api/v1/users/new-notification";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {"user_id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );

      results = jsonDecode(response.body);

      var urlCart = "http://app.getcenter.info/api/v1/pieces/get-cart-pieces";
      var responseCart = await http.post(
        Uri.parse(urlCart),
        body: jsonEncode(
            {"user_id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );

      resultCart = jsonDecode(responseCart.body);

      _streamController.add(results);
      _streamController.add(resultCart);

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
    // getCartData();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => getData());
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return AppBar(
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Color.fromARGB(255, 255, 150, 102),
            // title: Text("الرئيسية"),
            actions: <Widget>[
              results == 0
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => UserNotification())));
                      },
                      icon: Icon(Icons.notifications),
                      tooltip: "الاشعارات",
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) =>
                                        UserNotification())));
                              },
                              icon: Icon(Icons.notifications),
                              tooltip: "الاشعارات",
                            ),
                            Positioned(
                                left: 25,
                                top: 23,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red),
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                        child: Text(results.toString(),
                                            style: TextStyle(fontSize: 9)))))
                          ],
                        ),
                      ],
                    ),
              resultCart['cart'].length == 0
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: ((context) => Cart())));
                      },
                      icon: Icon(Icons.shopping_cart),
                      tooltip: "العربة",
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => Cart())));
                              },
                              icon: Icon(Icons.shopping_cart),
                              tooltip: "العربة",
                            ),
                            Positioned(
                                left: 25,
                                top: 23,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red),
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                        child: Text(
                                            resultCart["cart"]
                                                .length
                                                .toString(),
                                            style: TextStyle(fontSize: 9)))))
                          ],
                        ),
                      ],
                    ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => DataSearch())));
                },
                icon: Icon(Icons.search),
                tooltip: "البحث عن قطع او محلات",
              )
            ],
          );
        return Container(
          color: Color.fromARGB(255, 255, 150, 102),
        );
      },
    );
  }
}

class DataSearch extends StatefulWidget {
  DataSearch({Key? key}) : super(key: key);

  @override
  State<DataSearch> createState() => _DataSearchState();
}

class _DataSearchState extends State<DataSearch> {
  bool isLoading = false;
  List<Shop> shops = [];
  int page = 1;
  int shops_count = 0;
  String searchValue = "";

  sendValue(String value) async {
    page = 1;
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/shops/search";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "value": value,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          if (value == "") {
            resultShops = null;
          } else {
            resultShops = jsonDecode(response.body);
            shops = [];
            for (int i = 0; i < resultShops['shops']['data'].length; i++) {
              Shop shop = new Shop(
                resultShops['shops']['data'][i]["id"].toString(),
                resultShops['shops']['data'][i]["name"].toString(),
                resultShops['shops']['data'][i]["center"].toString(),
                resultShops['shops']['data'][i]["address"].toString(),
                resultShops['shops']['data'][i]["logo"].toString(),
              );
              shops.add(shop);
            }
            shops_count = resultShops["shops_count"];
          }
        } else {
          resultShops = null;
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  moreValues(String value) async {
    page = page + 1;
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/shops/search";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "value": value,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          if (value == "") {
            resultShops = null;
          } else {
            resultShops = jsonDecode(response.body);

            for (int i = 0; i < resultShops['shops']['data'].length; i++) {
              Shop shop = new Shop(
                resultShops['shops']['data'][i]["id"].toString(),
                resultShops['shops']['data'][i]["name"].toString(),
                resultShops['shops']['data'][i]["center"].toString(),
                resultShops['shops']['data'][i]["address"].toString(),
                resultShops['shops']['data'][i]["logo"].toString(),
              );
              shops.add(shop);
            }
          }
        } else {
          resultShops = null;
        }
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
    //getadata();
    resultShops = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  Expanded(
                    flex: 6,
                    child: Form(
                        child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                            onChanged: ((value) {
                              searchValue = value;
                              sendValue(value);

                              if (value == "") {
                                sendValue("");
                              }
                            }),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.black,
                              contentPadding:
                                  EdgeInsets.only(bottom: -10, left: 20),
                              fillColor: Color.fromARGB(255, 237, 237, 237),
                              filled: true,
                              hintText: "search for shops",
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(150),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 237, 237, 237),
                                  )
                                  //borderSide: BorderSide(color: mainColor, width: borderWidth));
                                  ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(150),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 237, 237, 237),
                                  )
                                  //borderSide: BorderSide(color: mainColor, width: borderWidth));
                                  ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(150),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 242, 242, 242))
                                  //borderSide: BorderSide(color: mainColor, width: borderWidth));
                                  ),
                            )),
                      ),
                    )),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              resultShops != null
                  ? Container(
                      child: isLoading
                          ? Center(
                              child: Container(
                                height: 600,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      color: Color.fromARGB(255, 255, 150, 102),
                                    ), //show this if state is loading
                                  ],
                                ),
                              ),
                            )
                          : page < shops_count
                              ? Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: shops.length,
                                          padding: EdgeInsets.only(bottom: 20),
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: Material(
                                                child: InkWell(
                                                  onTap: (() {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) =>
                                                                    SingleShop(
                                                                      shopId:
                                                                          shops[index]
                                                                              .id,
                                                                    ))));
                                                  }),
                                                  child: Row(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                            height: 90,
                                                            child: Center(
                                                              child: Container(
                                                                  width: 70,
                                                                  height: 70,
                                                                  child: ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              150),
                                                                      child: Image.network(
                                                                          shops[index]
                                                                              .logo,
                                                                          fit: BoxFit
                                                                              .fill))),
                                                            )),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                shops[index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            150,
                                                                            102)),
                                                              ),
                                                              Text(
                                                                Localization.stateLocalizaton(
                                                                    shops[index]
                                                                        .center),
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            150,
                                                                            102)),
                                                              ),
                                                            ],
                                                          ),
                                                          subtitle: Text(
                                                            shops[index]
                                                                .address,
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
                                                            maxLines: 1,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Center(
                                        child: InkWell(
                                            onTap: () {
                                              moreValues(searchValue);
                                            },
                                            child: Text(
                                              "المزيد من النتائج",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 150, 102)),
                                            )))
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.topCenter,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: shops.length,
                                      padding: EdgeInsets.only(bottom: 20),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Material(
                                            child: InkWell(
                                              onTap: (() {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            SingleShop(
                                                              shopId:
                                                                  shops[index]
                                                                      .id,
                                                            ))));
                                              }),
                                              child: Row(
                                                textDirection:
                                                    TextDirection.ltr,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                        height: 90,
                                                        child: Center(
                                                          child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              150),
                                                                  child: Image.network(
                                                                      shops[index]
                                                                          .logo,
                                                                      fit: BoxFit
                                                                          .fill))),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    flex: 6,
                                                    child: ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            shops[index].name,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        150,
                                                                        102)),
                                                          ),
                                                          Text(
                                                            Localization
                                                                .stateLocalizaton(
                                                                    shops[index]
                                                                        .center),
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        150,
                                                                        102)),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Text(
                                                        shops[index].address,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    150,
                                                                    102)),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                    )
                  : Container(
                      height: 600,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text("لا توجد نتائج")],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class Shop {
  final String id;
  final String name;
  final String center;
  final String address;
  final String logo;
  Shop(this.id, this.name, this.center, this.address, this.logo);
}
