import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/General/localization.dart';
import 'package:get_store/Notification/notification.dart';
import 'package:get_store/SinglePiece/singlePiece.dart';
import 'package:http/http.dart' as http;
import 'package:get_store/General/drawer.dart';
import 'package:get_store/SingleShop/singleShop.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Cart/cart.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  var results;
  int pages = 1;
  List<Shop> shops = [];
  late ScrollController _controller = ScrollController();
  late PageController _pageController;
  List<int> numbers = List<int>.generate(100, (int index) {
    return 0;
  });

  getShops(int page) async {
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
          body: jsonEncode(
              {"api_password": "tQnyBMCfK32bUx6pUnIh5IzR", "page": page}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          for (int i = 0; i < results.length; i++) {
            Shop shop = new Shop(
                results['data'][i]['id'].toString(),
                results['data'][i]['name'].toString(),
                results['data'][i]['center'].toString(),
                results['data'][i]['images'],
                results['data'][i]['models']);

            shops.add(shop);
          }
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

  getMoreShops(int page) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/shops/get-shops";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"api_password": "tQnyBMCfK32bUx6pUnIh5IzR", "page": page}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);

          for (int i = 0; i < results.length; i++) {
            Shop shop = new Shop(
                results['data'][i]['id'].toString(),
                results['data'][i]['name'].toString(),
                results['data'][i]['center'].toString(),
                results['data'][i]['images'],
                results['data'][i]['models']);

            shops.add(shop);
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

  int activePage = 1;

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white70 : Colors.white38,
            shape: BoxShape.circle),
      );
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        pages = pages + 1;
        getMoreShops(pages);
      });
    }
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    getShops(pages);
    _controller.addListener(_scrollListener);
    super.initState();
    _pageController = PageController(viewportFraction: 1, initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = Appbar();
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(child: AppDrawer()),
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
                color: Color.fromARGB(255, 240, 240, 240),
                width: double.infinity,
                height: screenHeight - (screenHeight / 17.5),
                child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: false,
                    itemCount: shops.length,
                    itemBuilder: (BuildContext context, int index) {
                      return index == shops.length - 1 && results["to"] == pages
                          ? Column(
                              children: [
                                Container(
                                    height: screenHeight / 2,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: PageView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                //controller: _pageController,
                                                onPageChanged: (page) {
                                                  setState(() {
                                                    numbers[index] = page;
                                                  });
                                                },
                                                itemCount:
                                                    shops[index].images.length,
                                                pageSnapping: true,
                                                itemBuilder:
                                                    (context, pagePosition) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${shops[index].images[pagePosition]['img'].toString()}",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                      shops[index]
                                                                  .images
                                                                  .length >
                                                              1
                                                          ? Column(
                                                              children: [
                                                                SizedBox(
                                                                  height:
                                                                      screenHeight /
                                                                          4.9,
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: indicators(
                                                                        shops[index]
                                                                            .images
                                                                            .length,
                                                                        numbers[
                                                                            index])),
                                                              ],
                                                            )
                                                          : Container()
                                                    ],
                                                  );
                                                })),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, right: 5, left: 5),
                                              color: Color.fromARGB(
                                                  255, 240, 240, 240),
                                              //child: Text('Entry ${entries[index]}')
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${shops[index].name}",
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      150,
                                                                      102),
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              Localization
                                                                  .stateLocalizaton(
                                                                      shops[index]
                                                                          .center),
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        ),
                                                        ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            150,
                                                                            102)),
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: ((context) =>
                                                                          SingleShop(
                                                                            shopId:
                                                                                "${shops[index].id}",
                                                                          ))));
                                                            },
                                                            child: Text(
                                                              "المزيد",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: screenHeight / 10,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: shops[index]
                                                            .models
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int i) {
                                                          return Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: ((context) => SinglePiece(
                                                                                shopId: "${shops[index].id}",
                                                                                pieceId: shops[index].models[i]['model_main_piece_id'].toString(),
                                                                              ))));
                                                                },
                                                                child:
                                                                    CachedNetworkImage(
                                                                  height:
                                                                      screenHeight /
                                                                          35,
                                                                  width: 80,
                                                                  imageUrl:
                                                                      "${shops[index].models[i]['picture'].toString()}",
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Container(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              )),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              height: 1,
                                              color: Color.fromARGB(
                                                  255, 200, 200, 200),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102),
                                      ), //show this if state is loading
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container(
                              height: screenHeight / 2,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          PageView.builder(
                                              scrollDirection: Axis.horizontal,
                                              //controller: _pageController,
                                              onPageChanged: (page) {
                                                setState(() {
                                                  numbers[index] = page;
                                                });
                                              },
                                              itemCount:
                                                  shops[index].images.length,
                                              pageSnapping: true,
                                              itemBuilder:
                                                  (context, pagePosition) {
                                                return Container(
                                                  width: double.infinity,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${shops[index].images[pagePosition]['img'].toString()}",
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
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                );
                                              }),
                                          shops[index].images.length > 1
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          screenHeight / 4.9,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: indicators(
                                                            shops[index]
                                                                .images
                                                                .length,
                                                            numbers[index])),
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5, right: 5, left: 5),
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        //child: Text('Entry ${entries[index]}')
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${shops[index].name}",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Color.fromARGB(
                                                            255, 255, 150, 102),
                                                        size: 30,
                                                      ),
                                                      Text(
                                                        Localization
                                                            .stateLocalizaton(
                                                                shops[index]
                                                                    .center),
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          150,
                                                                          102)),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    ((context) =>
                                                                        SingleShop(
                                                                          shopId:
                                                                              "${shops[index].id}",
                                                                        ))));
                                                      },
                                                      child: Text(
                                                        "المزيد",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: screenHeight / 10,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: shops[index]
                                                      .models
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        ((context) =>
                                                                            SinglePiece(
                                                                              shopId: "${shops[index].id}",
                                                                              pieceId: shops[index].models[i]['model_main_piece_id'].toString(),
                                                                            ))));
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                            height:
                                                                screenHeight /
                                                                    35,
                                                            width: 80,
                                                            imageUrl:
                                                                "${shops[index].models[i]['picture'].toString()}",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        height: 1,
                                        color:
                                            Color.fromARGB(255, 200, 200, 200),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                    }),
              ),
      ),
    );
  }
}

class Shop {
  final String id;
  final String name;
  final String center;
  final List<dynamic> images;
  final List<dynamic> models;
  Shop(this.id, this.name, this.center, this.images, this.models);
}
