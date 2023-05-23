import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_store/General/appBar.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:get_store/Order/successOrder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../Cart/cart.dart';

class Order extends StatefulWidget {
  Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool isLoading = false;
  bool isLoadingDelivery = false;
  int user_id = 0;
  String? name;
  String? phone;
  String? address;
  int delivery = 0;
  var results;
  var deliveryResults;
  Position? cl;
  StreamSubscription<Position>? ps;
  GoogleMapController? gmc;
  var lat;
  var long;

  Set<Marker> myMarker = {};

  int deleveryCost = 0;
  deliveryPrice() async {
    try {
      setState(() {
        isLoadingDelivery = true;
      });
      cl = await Geolocator.getCurrentPosition().then((value) => value);
      lat = cl?.latitude;
      long = cl?.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      var url = "http://app.getcenter.info/api/v1/orders/order-delivery";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "state": placemarks[0].administrativeArea,
          "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
        }),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );
      deliveryResults = jsonDecode(response.body);
      delivery = deliveryResults["price"];
      deleveryCost = 1;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoadingDelivery = false;
    });
  }

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
            deliveryPrice();
            cl = await Geolocator.getCurrentPosition().then((value) => value);
            lat = cl?.latitude;
            long = cl?.longitude;
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
        // deliveryPrice();
        cl = await Geolocator.getCurrentPosition().then((value) => value);
        lat = cl?.latitude;
        long = cl?.longitude;
        myMarker
            .add(Marker(markerId: MarkerId("1"), position: LatLng(lat, long)));

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
      }
    }

    return Container();
  }
//================================================================================================

  /*
     Future getLatAndLong<Position>() async{
      return await Geolocator.getCurrentPosition().then((value) => value);
     }
  */

  sendData() async {
    setState(() {
      isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user_id = prefs.getInt("id")!;
      int? total = prefs.getInt("order_total")! + delivery;
      var url = "http://app.getcenter.info/api/v1/orders/add";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "user_id": user_id,
          "name": name,
          "phone": phone,
          "address": address,
          "delivery": delivery,
          "longitude": long,
          "latitude": lat,
          "date": intl.DateFormat('yMd').format(DateTime.now()),
          "deadline": intl.DateFormat('yMd')
              .format(DateTime.now().add(Duration(days: 3))),
          "done_date": "",
          "total": total,
          "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
        }),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SuccessOrder()),
          (Route<dynamic> route) => false,
        );
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
  }

  @override
  void initState() {
    //getLocation();
    deliveryPrice();
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
              : SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                          color: Color.fromARGB(255, 240, 240, 240),
                          padding: EdgeInsets.all(15),
                          height: screenHeight - (screenHeight / 17.5),
                          child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(children: [
                                Text(
                                  "بيانات الاوردر",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 255, 150, 102),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    cursorColor:
                                        Color.fromARGB(255, 255, 150, 102),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 150, 102)),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: -5, horizontal: 10),
                                      hintText: "الاسم ثلاثي باللغة العربية",
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102)),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      errorStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return 'من فضلك ادخل البيانات';
                                      } else if (RegExp(
                                              r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                          .hasMatch(value)) {
                                        return 'خطأ في اسم المستخدم';
                                      }
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      phone = value;
                                    },
                                    cursorColor:
                                        Color.fromARGB(255, 255, 150, 102),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 150, 102)),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: -5, horizontal: 10),
                                      hintText: "رقم التليفون",
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102)),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      errorStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return 'من فضلك ادخل البيانات';
                                      }
                                      bool numberCheck = value.length == 11 &&
                                              value.startsWith("0122") ||
                                          value.startsWith("0127") ||
                                          value.startsWith("0128") ||
                                          value.startsWith("0120") ||
                                          value.startsWith("0100") ||
                                          value.startsWith("0106") ||
                                          value.startsWith("0109") ||
                                          value.startsWith("0101") ||
                                          value.startsWith("0111") ||
                                          value.startsWith("0114") ||
                                          value.startsWith("0112") ||
                                          value.startsWith("0155");

                                      if (!RegExp(r'^[0-9]+$')
                                              .hasMatch(value) ||
                                          numberCheck == false) {
                                        return 'خطأ في ادخال رقم التليفون';
                                      }
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      address = value;
                                    },
                                    cursorColor:
                                        Color.fromARGB(255, 255, 150, 102),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 150, 102)),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: -5, horizontal: 10),
                                      hintText: "العنوان",
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 255, 150, 102)),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              width: 2)),
                                      errorStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return 'من فضلك ادخل البيانات';
                                      }
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                deliveryPrice();
                                              });
                                            },
                                            child: Text(
                                              "اعادة تحديد موقعي",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ))
                                      ],
                                    ),
                                    deliveryResults == null
                                        ? Column(
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
                                          )
                                        : Text(
                                            "تكلفة الشحن ${deliveryResults['price'].toString()} جنيه",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 150, 102)),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                    future: GetLatAndLongOnMap(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Widget> snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      }

                                      return Container(
                                          child: CircularProgressIndicator());
                                    }),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 130),
                                    ),
                                    onPressed: () {
                                      sendData();
                                    },
                                    child: Text(
                                      "تأكيد الطلب",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ]))),
                    ],
                  ),
                ),
        ));
  }
}


/*
Widget build(BuildContext context) {
            double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
    appBar: AppBar(
    backgroundColor: Color.fromARGB(255, 255, 150, 102),
    /*
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        */
    actions: <Widget>[
      IconButton(
        onPressed: () {
             Navigator.of(context).push(
              MaterialPageRoute(
                  builder: ((context) => Cart())));
        },
        icon: Icon(Icons.shopping_cart),
        tooltip: "عرض العربة",
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.search),
        tooltip: "البحث عن قطع او محلات",
      )
    ],
  ),

    body:  SingleChildScrollView(
    child: 
      Column(
        children: [
          Container(
                   color: Color.fromARGB(255, 240, 240, 240),
                   padding: EdgeInsets.all(15),
                        height: screenHeight - (screenHeight / 17.5),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Text("بيانات الاوردر" , style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 150, 102) , fontWeight: FontWeight.bold),),
                             SizedBox(
                                height: 25,
                             ),
                            
                             Directionality(
                              textDirection: TextDirection.rtl,
                               child: TextFormField(
                                onChanged: (value){
                                  name = value;
                                },
                                     cursorColor: Color.fromARGB(255, 255, 150, 102),
                                     style: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                     decoration: InputDecoration(
                                       contentPadding: EdgeInsets.symmetric(vertical: -5 , horizontal: 10),
                                       hintText: "الاسم ثلاثي باللغة العربية",
                                       hintStyle: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                        disabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        enabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        focusedBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                       /*
                                       errorStyle: TextStyle(
                                         fontSize: textFontSize - 4,
                                         color: errorColor,
                                       ),
                                       */
                                       )),
                             ),

                             SizedBox(
                                height: 40,
                             ),

                             Directionality(
                              textDirection: TextDirection.rtl,
                               child: TextFormField(
                                onChanged: (value){
                                    phone = value;
                                },
                                     cursorColor: Color.fromARGB(255, 255, 150, 102),
                                     style: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                     decoration: InputDecoration(
                                       contentPadding: EdgeInsets.symmetric(vertical: -5 , horizontal: 10),
                                       hintText: "رقم التليفون",
                                       hintStyle: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                        disabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        enabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        focusedBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                       /*
                                       errorStyle: TextStyle(
                                         fontSize: textFontSize - 4,
                                         color: errorColor,
                                       ),
                                       */
                                       )),
                             ),

                              SizedBox(
                                height: 40,
                              ),

                             Directionality(
                              textDirection: TextDirection.rtl,
                               child: TextFormField(
                                onChanged: (value){
                                  address = value;
                                },
                                     cursorColor: Color.fromARGB(255, 255, 150, 102),
                                     style: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                     decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: -5 , horizontal: 10),
                                       hintText: "العنوان",
                                       hintStyle: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 255, 150, 102)),
                                        disabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        enabledBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                        focusedBorder: UnderlineInputBorder(                                      
                                        borderSide: BorderSide(color: Color.fromARGB(255, 255, 150, 102), width: 2)
                                        ),
                                       /*
                                       errorStyle: TextStyle(
                                         fontSize: textFontSize - 4,
                                         color: errorColor,
                                       ),
                                       */
                                       )),
                             ),

                            SizedBox(
                                height: 10,
                             ),

                            Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Icon(Icons.location_on , color: Colors.blue,),
                                  Text("تحديد موقعي" , style: TextStyle(color: Colors.blue),),
                                ],
                              ),
                              Text("تكلفة الشحن 20 جنيه" , style: TextStyle(color: Color.fromARGB(255, 255, 150, 102)),)
                            ],),
                            SizedBox(
                                height: 10,
                             ),

                            Container(
                              width: double.infinity,
                              height: 240,
                              color: Colors.red,
                              child: Image.network("https://developers.google.com/maps/images/landing/hero_geocoding_api_480.png" , fit: BoxFit.fill,),
                            ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(       
                                      backgroundColor:  Colors.green  ,
                                      padding: EdgeInsets.symmetric(horizontal: 130),
                                    ),                                   
                                    onPressed: (){
                                      /*
                                      Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Order())));
                                      */
                                    },
                                     child: Text("تأكيد الطلب" ,style: TextStyle(color: Colors.white ),)
                                    )
                          ])
                    )
            ),
        ],
      ),
     ),
    );
  }
}
*/