import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/General/localization.dart';
import 'package:get_store/SinglePiece/singlePiece.dart';
import 'package:get_store/SingleShop/shopInfo.dart';
import 'package:get_store/SingleShop/singleShop.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_store/Cart/cart.dart';
import 'package:get_store/Cart/emptyCart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart' as intl;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../General/appBar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopInfo extends StatefulWidget {
  String shopId;
  ShopInfo({Key? key, required this.shopId}) : super(key: key);

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  bool isLoading = false;
  var results;
  Position? cl;
  StreamSubscription<Position>? ps;
  GoogleMapController? gmc;
  var lat;
  var long;
  int activePage = 0;

  getData() async {
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
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
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

  Set<Marker> myMarker = {};

  Future<Widget>? GetLatAndLongOnMap() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Container(
          width: double.infinity,
          height: 240,
          child: Container(
            width: double.infinity,
            height: 240,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 100,
                    width: 300,
                    child: Icon(
                      Icons.location_off,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "اذن الموقع غير مفعل",
                        style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 70),
                      ),
                      onPressed: () async {
                        LocationPermission servicePer =
                            await Geolocator.requestPermission();
                        setState(() {});
                      },
                      child: Text(
                        "تفعيل الموقع",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                ])),
          ));
    }

    if (permission == LocationPermission.always) {
      bool services;
      services = await Geolocator.isLocationServiceEnabled();
      if (services == false) {
        LocationPermission servicePer = await Geolocator.requestPermission();
        if (servicePer == LocationPermission.denied) {
          return Container(
              width: double.infinity,
              height: 240,
              child: Container(
                width: double.infinity,
                height: 240,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        height: 100,
                        width: 300,
                        child: Icon(
                          Icons.location_off,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "الموقع غير مفعل",
                            style: TextStyle(
                                fontSize: 25,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 70),
                          ),
                          onPressed: () async {
                            LocationPermission servicePer =
                                await Geolocator.requestPermission();
                            setState(() {});
                          },
                          child: Text(
                            "تفعيل الموقع",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                    ])),
              ));
        } else {
          try {
            cl = await Geolocator.getCurrentPosition().then((value) => value);
            lat = results['shops']['latitude'];
            long = results['shops']['longitude'];

            myMarker.add(
                Marker(markerId: MarkerId("1"), position: LatLng(lat, long)));
            return Container(
                width: double.infinity,
                height: 240,
                child: GoogleMap(
                  markers: myMarker,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ));
          } catch (e) {
            return Container(
              width: double.infinity,
              height: 240,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 100,
                      width: 300,
                      child: Icon(
                        Icons.location_off,
                        size: 100,
                        color: Colors.red,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "الموقع غير مفعل",
                          style: TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 70),
                        ),
                        onPressed: () async {
                          LocationPermission servicePer =
                              await Geolocator.requestPermission();
                          setState(() {});
                        },
                        child: Text(
                          "تفعيل الموقع",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                  ])),
            );
          }
        }
      } else {
        cl = await Geolocator.getCurrentPosition().then((value) => value);
        lat = results['shops']['latitude'];
        long = results['shops']['longitude'];

        myMarker.add(Marker(
            markerId: MarkerId("1"),
            position: LatLng(double.parse(lat), double.parse(long))));

        return Container(
            width: double.infinity,
            height: 240,
            child: GoogleMap(
              markers: myMarker,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(lat), double.parse(long)),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ));
      }
    }

    return Container();
  }
//================================================================================================

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
    getData();

    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();
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
                  child: Column(
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
                                          itemCount:
                                              results['shops']['images'].length,
                                          pageSnapping: true,
                                          itemBuilder: (context, pagePosition) {
                                            return Container(
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${results['shops']['images'][pagePosition]['img'].toString()}",
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
                                      results['shops']['images'].length > 1
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
                                                        results['shops']
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
                                              "${results['shops']['name'].toString()}",
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
                                                    Localization
                                                        .stateLocalizaton(
                                                            results['shops']
                                                                    ['center']
                                                                .toString()),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                                                                    shopId: widget
                                                                        .shopId))));
                                                  },
                                                  child: Text(
                                                    "ملابس المحل",
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
                      results == null
                          ? Container()
                          : FutureBuilder(
                              future: GetLatAndLongOnMap(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Widget> snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                }

                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102),
                                      )),
                                    ],
                                  ),
                                );
                              }),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "العنوان : ${results['shops']["address"].toString()}",
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "التليفون : ${results['shops']["phone"].toString()}",
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
