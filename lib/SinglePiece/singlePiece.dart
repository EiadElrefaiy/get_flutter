import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get_store/Cart/cart.dart';
import 'package:get_store/Cart/emptyCart.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/General/localization.dart';
import 'package:get_store/SinglePiece/fullScreen.dart';
import 'package:get_store/SingleShop/shopInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../General/appBar.dart';
import '../SingleShop/singleShop.dart';
import 'package:cached_network_image/cached_network_image.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class SinglePiece extends StatefulWidget {
  String pieceId;
  String shopId;
  SinglePiece({Key? key, required this.pieceId, required this.shopId})
      : super(key: key);

  @override
  State<SinglePiece> createState() => _SinglePieceState();
}

class _SinglePieceState extends State<SinglePiece> {
  bool isLoading = false;
  String sizes = "";
  String sizeChoosen = "";
  String selectedSize = "";
  int user_id = 0;
  int activePage = 0;
  var results;
  var addToCartresults;

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("id")!;
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/pieces/get-piece-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "id": widget.pieceId,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );

        if (response.statusCode == 200) {
          results = jsonDecode(response.body);

          for (int i = 0; i < results['singlePiece'][0]['sizes'].length; i++) {
            if (results['singlePiece'][0]['sizes'].length == 1) {
              if (results['singlePiece'][0]['sizes'][i]['size'].toString() ==
                  "x") {
                sizes = "";
              } else {
                sizes =
                    results['singlePiece'][0]['sizes'][i]['size'].toString();
              }
            } else {
              if (i == 0) {
                sizes =
                    results['singlePiece'][0]['sizes'][i]['size'].toString() +
                        " - ";
              } else if (i == results['singlePiece'][0]['sizes'].length - 1) {
                sizes = sizes +
                    results['singlePiece'][0]['sizes'][i]['size'].toString();
              } else {
                sizes = sizes +
                    results['singlePiece'][0]['sizes'][i]['size'].toString() +
                    " - ";
              }
            }
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

  addPieceToCart(int userId, String pieceId, String size) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/pieces/add-to-cart";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "user_id": user_id,
            "piece_id": widget.pieceId,
            "size": size,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          addToCartresults = jsonDecode(response.body);
          print(addToCartresults);
          Fluttertoast.showToast(
              msg: addToCartresults["msg"].toString(),
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
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

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        appBar: Appbar(),
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
                    color: Color.fromARGB(255, 240, 240, 240),
                    height: screenHeight - (screenHeight / 17.5),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                            height: screenHeight / 2.5,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                            scrollDirection: Axis.horizontal,
                                            //controller: _pageController,
                                            onPageChanged: (page) {
                                              setState(() {
                                                activePage = page;
                                              });
                                            },
                                            itemCount: results["shop"][0]
                                                    ['images']
                                                .length,
                                            pageSnapping: true,
                                            itemBuilder:
                                                (context, pagePosition) {
                                              return Container(
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${results["shop"][0]['images'][pagePosition]['img'].toString()}",
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
                                              );
                                            }),
                                        results["shop"][0]['images'].length > 1
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight / 4.3,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: indicators(
                                                          results["shop"][0]
                                                                  ['images']
                                                              .length,
                                                          activePage)),
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
                                      color: Color.fromARGB(255, 240, 240, 240),
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
                                                results["shop"][0]['name']
                                                    .toString(),
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          Container(
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
                                                              results["shop"][0]
                                                                      ['center']
                                                                  .toString()),
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
                                                                  ShopInfo(
                                                                      shopId: widget
                                                                          .shopId))));
                                                    },
                                                    child: Text(
                                                      "المزيد عن المحل",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      height: 1,
                                      color: Color.fromARGB(255, 200, 200, 200),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          width: double.infinity,
                          height: screenHeight / 2.8,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${results['singlePiece'][0]['picture'].toString()}",
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
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  child: Center(
                                                    child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        color: Colors.black45,
                                                        child: Center(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: ((context) =>
                                                                          FullScreen(
                                                                              image: results['singlePiece'][0]['picture'].toString()))));
                                                            },
                                                            icon: Icon(Icons
                                                                .fullscreen),
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "${results['category'][0]['name'].toString()}",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                  Text(
                                                    sizes,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "${results['model'][0]['price'].toString()} جنيه",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green),
                                                      onPressed: () {
                                                        selectedSize =
                                                            results['singlePiece']
                                                                            [0][
                                                                        'sizes']
                                                                    [0]['size']
                                                                .toString();
                                                        showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              int selectedRadio =
                                                                  0;
                                                              return AlertDialog(
                                                                content:
                                                                    StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: List<
                                                                              Widget>.generate(
                                                                          results['singlePiece'][0]['sizes']
                                                                              .length,
                                                                          (int
                                                                              index) {
                                                                        return RadioListTile<
                                                                            int>(
                                                                          title:
                                                                              Text(results['singlePiece'][0]['sizes'][index]['size'].toString()),
                                                                          value:
                                                                              index,
                                                                          activeColor: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              150,
                                                                              102),
                                                                          groupValue:
                                                                              selectedRadio,
                                                                          onChanged:
                                                                              (int? value) {
                                                                            setState(() {
                                                                              selectedRadio = value!;
                                                                              selectedSize = results['singlePiece'][0]['sizes'][selectedRadio]['size'].toString();
                                                                            });
                                                                          },
                                                                        );
                                                                      }),
                                                                    );
                                                                  },
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text(
                                                                      "الغاء",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              150,
                                                                              102)),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                      "تأكيد",
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              150,
                                                                              102)),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      addPieceToCart(
                                                                          user_id,
                                                                          widget
                                                                              .pieceId,
                                                                          selectedSize);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Text(
                                                        "اضافة الى العربية",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  )),
                              /*
                                     Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [

                                        ],
                                      )
                                      ),
                                      */
                              results['RestOfPieces'].length != 1
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              height: 1,
                                              color: Color.fromARGB(
                                                  255, 200, 200, 200),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(right: 15),
                                          height: screenHeight / 15,
                                          child: ListView.builder(
                                              shrinkWrap: false,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: results['RestOfPieces']
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.pieceId =
                                                          results['RestOfPieces']
                                                                  [i]['id']
                                                              .toString();
                                                      getData();
                                                    });
                                                    /*
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: ((context) => SinglePiece(
                                            pieceId:
                                                "${results['RestOfPieces'][i]['id'].toString()}"))));
                                                */
                                                  },
                                                  child: Container(
                                                    height: 5,
                                                    width: 50,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            '${results['RestOfPieces'][i]['color'].toString()}'
                                                                .toColor(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        results['singlePiece'][0]['description'] != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        height: 1,
                                        color:
                                            Color.fromARGB(255, 200, 200, 200),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      results['singlePiece'][0]['description']
                                          .toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              height: 1,
                              color: Color.fromARGB(255, 200, 200, 200),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "ذات صلة",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(right: 15),
                          height: screenHeight / 10,
                          child: ListView.builder(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: results['randomModels'].length,
                              itemBuilder: (BuildContext context, int i) {
                                return InkWell(
                                  onTap: () {
                                    widget.pieceId = results['randomModels'][i]
                                            ['id']
                                        .toString();
                                    getData();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        height: screenHeight / 35,
                                        width: 80,
                                        imageUrl:
                                            "${results['randomModels'][i]['picture'].toString()}",
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
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ]),
                    ),
                  ))));
  }
}
