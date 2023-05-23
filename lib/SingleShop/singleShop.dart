import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/General/localization.dart';
import 'package:get_store/SinglePiece/singlePiece.dart';
import 'package:get_store/SingleShop/shopInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SingleShop extends StatefulWidget {
  String shopId;
  SingleShop({Key? key, required this.shopId}) : super(key: key);

  @override
  State<SingleShop> createState() => _SingleShopState();
}

class _SingleShopState extends State<SingleShop> {
  late BankListDataModel _bankChooseModels = BankListDataModel("");
  late BankListDataModel _bankChooseSizes = BankListDataModel("");

  late List<BankListDataModel> models = [];

  late List<BankListDataModel> sizes = [];

  final modelController = TextEditingController();
  final sizeController = TextEditingController();

  bool isLoading = false;
  bool isFiltering = false;
  var results;
  List<Shop> shops = [];
  List<Category> categories = [];
  List<Piece> pieces = [];
  var resultFilter;
  var resultsCategories;
  int pages = 1;
  late ScrollController _controller = ScrollController();
  int pieces_count = 0;
  bool filter = false;
  List<String> catClass = ["none"];
  bool online = true;

  int activePage = 0;

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

  getdata(int page) async {
    try {
      setState(() {
        isLoading = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/shops/get-shop-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "id": widget.shopId,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );

        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          resultFilter = results;

          Shop shop = new Shop(
            results['shops']['id'].toString(),
            results['shops']['name'].toString(),
            results['shops']['center'].toString(),
            results['shops']['images'],
          );
          shops.add(shop);

          for (int i = 0; i < results['categories'].length; i++) {
            Category category = new Category(
              results['categories'][i]["id"].toString(),
              results['categories'][i]["name"].toString(),
              results['categories'][i]["class"].toString(),
              results['categories'][i]["shop_id"].toString(),
            );
            categories.add(category);
          }

          for (int i = 0; i < categories.length; i++) {
            models.add(BankListDataModel(categories[i].name));
          }

          pieces_count = results["pieces_count"];

          for (int i = 0; i < results['pieces']['data'].length; i++) {
            Piece piece = new Piece(
              results['pieces']['data'][i]["id"].toString(),
              results['pieces']['data'][i]["model_id"].toString(),
              results['pieces']['data'][i]["description"].toString(),
              results['pieces']['data'][i]["picture"].toString(),
              results['pieces']['data'][i]["color"].toString(),
            );
            pieces.add(piece);
          }
        } else {
          online = false;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ConnectionFaield()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        online = false;
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

  getMorePieces(int page) async {
    pages = pages + 1;
    page = pages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/shops/get-shop-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "id": widget.shopId,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR",
            "page": page
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          resultFilter = results;
          pieces_count = results["pieces_count"];

          for (int i = 0; i < results['pieces']['data'].length; i++) {
            Piece piece = new Piece(
              results['pieces']['data'][i]["id"].toString(),
              results['pieces']['data'][i]["model_id"].toString(),
              results['pieces']['data'][i]["description"].toString(),
              results['pieces']['data'][i]["picture"].toString(),
              results['pieces']['data'][i]["color"].toString(),
            );
            setState(() {
              pieces.add(piece);
            });
          }
        } else {
          online = false;
          Fluttertoast.showToast(
              msg: "خطأ في الاتصال",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } else {
        online = false;
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

  filterData(String filterModel, String filterSize, int page) async {
    pages = 1;
    page = pages;
    try {
      setState(() {
        isFiltering = true;
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/pieces/filter";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "shop_id": widget.shopId,
            "model": filterModel,
            "size": filterSize,
            "page": page,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );

        if (response.statusCode == 200) {
          resultFilter = jsonDecode(response.body);
          pieces_count = resultFilter["pieces_count"];
          pieces.removeRange(0, pieces.length);

          for (int i = 0; i < resultFilter['pieces']['data'].length; i++) {
            Piece piece = new Piece(
              resultFilter['pieces']['data'][i]["id"].toString(),
              resultFilter['pieces']['data'][i]["model_id"].toString(),
              resultFilter['pieces']['data'][i]["description"].toString(),
              resultFilter['pieces']['data'][i]["picture"].toString(),
              resultFilter['pieces']['data'][i]["color"].toString(),
            );
            setState(() {
              pieces.add(piece);
            });
          }
          filter = true;
          setState(() {
            if (filterSize == "جميع المقاسات") {
              sizes.removeRange(0, sizes.length);
              if (resultFilter["class"][0] == "احذية") {
                sizes = [
                  BankListDataModel("جميع المقاسات"),
                  BankListDataModel("38"),
                  BankListDataModel("39"),
                  BankListDataModel("40"),
                  BankListDataModel("41"),
                  BankListDataModel("42"),
                  BankListDataModel("43"),
                  BankListDataModel("44"),
                  BankListDataModel("45"),
                ];
              } else if (resultFilter["class"][0] == "ملابس" ||
                  resultFilter["class"][0] == "all") {
                sizes = [
                  BankListDataModel("جميع المقاسات"),
                  BankListDataModel("S"),
                  BankListDataModel("M"),
                  BankListDataModel("L"),
                  BankListDataModel("XL"),
                  BankListDataModel("XXL"),
                  BankListDataModel("XXXL"),
                  BankListDataModel("XXXXL"),
                ];
              } else {
                sizes = [
                  BankListDataModel("جميع المقاسات"),
                ];
              }
              _bankChooseSizes = sizes[0];
            }
            isFiltering = false;
          });
        } else {
          online = false;
          Fluttertoast.showToast(
              msg: "خطأ في الاتصال",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } else {
        online = false;
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

  getMoreFilterData(String filterModel, String filterSize, int page) async {
    pages = pages + 1;
    page = pages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        var url = "http://app.getcenter.info/api/v1/pieces/filter";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "shop_id": widget.shopId,
            "model": filterModel,
            "size": filterSize,
            "page": page,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          resultFilter = jsonDecode(response.body);

          pieces_count = resultFilter["pieces_count"];

          for (int i = 0; i < resultFilter['pieces']['data'].length; i++) {
            Piece piece = new Piece(
              resultFilter['pieces']['data'][i]["id"].toString(),
              resultFilter['pieces']['data'][i]["model_id"].toString(),
              resultFilter['pieces']['data'][i]["description"].toString(),
              resultFilter['pieces']['data'][i]["picture"].toString(),
              resultFilter['pieces']['data'][i]["color"].toString(),
            );
            setState(() {
              pieces.add(piece);
            });
          }
        } else {
          online = false;
          Fluttertoast.showToast(
              msg: "خطأ في الاتصال",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } else {
        online = false;
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
      if (filter == true) {
        if (pages == pieces_count) {
          setState(() {
            getMoreFilterData(_bankChooseModels.bank_name.toString(),
                _bankChooseSizes.bank_name.toString(), pages);
            print(_bankChooseModels.bank_name.toString() +
                "\n" +
                _bankChooseSizes.bank_name.toString());
          });
        } else {
          getMoreFilterData(_bankChooseModels.bank_name.toString(),
              _bankChooseSizes.bank_name.toString(), pages);
          print(_bankChooseModels.bank_name.toString() +
              "\n" +
              _bankChooseSizes.bank_name.toString());
        }
      } else {
        if (pages == pieces_count) {
          setState(() {
            getMorePieces(pages);
          });
        } else {
          getMorePieces(pages);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata(pages);
    _controller.addListener(_scrollListener);

    models = [
      BankListDataModel("تشكيلة متنوعة"),
    ];

    sizes = [
      BankListDataModel("جميع المقاسات"),
    ];

    _bankChooseModels = models[0];
    _bankChooseSizes = sizes[0];
    super.initState();
  }

  void _onDropDownItemSelectedModels(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseModels = newSelectedBank;
    });
    filterData(
        _bankChooseModels.bank_name.toString(), sizes[0].bank_name, pages);
    _bankChooseSizes = sizes[0];
  }

  void _onDropDownItemSelectedSizes(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseSizes = newSelectedBank;
    });
    filterData(_bankChooseModels.bank_name.toString(),
        _bankChooseSizes.bank_name.toString(), pages);
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
                color: Color.fromARGB(255, 240, 240, 240),
                height: screenHeight - (screenHeight / 17.5),
                child: ListView(
                  controller: _controller,
                  children: [
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
                                        itemCount: shops[0].images.length,
                                        pageSnapping: true,
                                        itemBuilder: (context, pagePosition) {
                                          return Container(
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${shops[0].images[pagePosition]['img'].toString()}",
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
                                          );
                                        }),
                                    shops[0].images.length > 1
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: screenHeight / 4.3,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: indicators(
                                                      shops[0].images.length,
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
                                            "${shops[0].name}",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  Localization.stateLocalizaton(
                                                      shops[0].center),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(255, 255,
                                                            150, 102)),
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
                            )
                          ],
                        )),
                    Center(
                        child: isFiltering
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 180,
                                  ),
                                  CircularProgressIndicator(
                                    color: Color.fromARGB(255, 255, 150, 102),
                                  ), //show this if state is loading
                                ],
                              )
                            : Container(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: SizedBox(
                                                width: 125,
                                                height: 30,
                                                child: FormField<String>(
                                                  builder:
                                                      (FormFieldState<String>
                                                          state) {
                                                    return InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "المقاس",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    100,
                                                                    100,
                                                                    100),
                                                            fontSize: 15),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: -20,
                                                                right: 8),
                                                      ),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            child: DropdownButton<
                                                                BankListDataModel>(
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          100,
                                                                          100,
                                                                          100),
                                                                  fontSize: 15),
                                                              hint: Text(
                                                                "المقاس",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            100,
                                                                            100,
                                                                            100),
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              items: sizes.map<
                                                                      DropdownMenuItem<
                                                                          BankListDataModel>>(
                                                                  (BankListDataModel
                                                                      value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Center(
                                                                    child: Text(
                                                                        value
                                                                            .bank_name),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (BankListDataModel?
                                                                      newSelectedBank) {
                                                                _onDropDownItemSelectedSizes(
                                                                    newSelectedBank!);
                                                              },
                                                              value:
                                                                  _bankChooseSizes,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: SizedBox(
                                                width: 130,
                                                height: 30,
                                                child: FormField<String>(
                                                  builder:
                                                      (FormFieldState<String>
                                                          state) {
                                                    return InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "تشكيلة متنوعة",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    100,
                                                                    100,
                                                                    100),
                                                            fontSize: 15),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: -20,
                                                                right: 8),
                                                      ),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            child: DropdownButton<
                                                                BankListDataModel>(
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          100,
                                                                          100,
                                                                          100),
                                                                  fontSize: 15),
                                                              hint: Text(
                                                                "تشكيلة متنوعة",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            100,
                                                                            100,
                                                                            100),
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              items: models.map<
                                                                      DropdownMenuItem<
                                                                          BankListDataModel>>(
                                                                  (BankListDataModel
                                                                      value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Center(
                                                                    child: Text(
                                                                        value
                                                                            .bank_name),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (BankListDataModel?
                                                                      newSelectedBank) {
                                                                _onDropDownItemSelectedModels(
                                                                    newSelectedBank!);
                                                              },
                                                              value:
                                                                  _bankChooseModels,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          SingleChildScrollView(
                                            child: pages <= pieces_count &&
                                                    pieces_count != 1
                                                ? Column(
                                                    children: [
                                                      GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            pieces.length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: ((context) =>
                                                                          SinglePiece(
                                                                            pieceId:
                                                                                "${pieces[index].id}",
                                                                            shopId:
                                                                                widget.shopId,
                                                                          ))));
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          5),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  height: 110,
                                                                  width: 110,
                                                                  imageUrl:
                                                                      "${pieces[index].picture}",
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
                                                        },
                                                      ),
                                                      Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            CircularProgressIndicator(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      150,
                                                                      102),
                                                            ), //show this if state is loading
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: pieces.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      ((context) =>
                                                                          SinglePiece(
                                                                            pieceId:
                                                                                "${pieces[index].id}",
                                                                            shopId:
                                                                                widget.shopId,
                                                                          ))));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 5),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              height: 110,
                                                              width: 110,
                                                              imageUrl:
                                                                  "${pieces[index].picture}",
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
                                                              placeholder:
                                                                  (context,
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
                                                    },
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                  ],
                ),
              )),
      ),
    );
  }
}

class BankListDataModel {
  String bank_name;
  BankListDataModel(this.bank_name);
}

class Shop {
  final String id;
  final String name;
  final String center;
  final List<dynamic> images;
  Shop(this.id, this.name, this.center, this.images);
}

class Piece {
  final String id;
  final String model_id;
  final String description;
  final String picture;
  final String color;
  Piece(this.id, this.model_id, this.description, this.picture, this.color);
}

class Category {
  final String id;
  final String name;
  final String _class;
  final String shopId;
  Category(
    this.id,
    this.name,
    this._class,
    this.shopId,
  );
}
