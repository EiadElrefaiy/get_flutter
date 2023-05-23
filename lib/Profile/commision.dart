import 'package:flutter/material.dart';
import 'package:get_store/Profile/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'inviteCode.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Commission extends StatefulWidget {
  Commission({Key? key}) : super(key: key);

  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  late int cash = 0;
  int user_id = 0;
  bool isLoading = false;
  late ScrollController _controller = ScrollController();

  var results;
  var getMoreCommessionsResults;
  List<Commession> commessions = [];

  var paymentsResults;
  var morePaymentsResults;
  List<PaymentOperation> payments = [];

  int commessionPages = 1;
  int paymentPages = 1;

  int commessions_count = 0;
  int payments_count = 0;

  getData(int page) async {
    page = commessionPages;
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
        var url = "http://app.getcenter.info/api/v1/orders/get-orders";
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
          for (int i = 0; i < results['orders']['data'].length; i++) {
            Commession commession = new Commession(
              int.parse(results['orders']['data'][i]['id'].toString()),
              int.parse(results['orders']['data'][i]['total']),
              results['orders']['data'][i]['done_date'].toString(),
            );
            setState(() {
              commessions.add(commession);
            });
          }
          commessions_count = results['orders_count'];
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

  getMoreData(int page) async {
    commessionPages = commessionPages + 1;
    page = commessionPages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;
        var url = "http://app.getcenter.info/api/v1/orders/get-orders";
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
          getMoreCommessionsResults = jsonDecode(response.body);

          for (int i = 0;
              i < getMoreCommessionsResults['orders']['data'].length;
              i++) {
            Commession commession = new Commession(
              int.parse(getMoreCommessionsResults['orders']['data'][i]['id']
                  .toString()),
              int.parse(
                  getMoreCommessionsResults['orders']['data'][i]['total']),
              getMoreCommessionsResults['orders']['data'][i]['done_date']
                  .toString(),
            );
            setState(() {
              commessions.add(commession);
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

  getPayData(int page) async {
    page = paymentPages;
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
        var url = "http://app.getcenter.info/api/v1/payments/get-payment-id";
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
          paymentsResults = jsonDecode(response.body);

          for (int i = 0; i < paymentsResults['payments']['data'].length; i++) {
            PaymentOperation payment = new PaymentOperation(
                int.parse(
                    paymentsResults['payments']['data'][i]['id'].toString()),
                paymentsResults['payments']['data'][i]['wallet_number']
                    .toString(),
                paymentsResults['payments']['data'][i]['date'].toString(),
                int.parse(paymentsResults['payments']['data'][i]['done']));
            setState(() {
              payments.add(payment);
            });
          }
          payments_count = paymentsResults['payments_count'];
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

  getMorePayData(int page) async {
    paymentPages = paymentPages + 1;
    page = paymentPages;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;
        var url = "http://app.getcenter.info/api/v1/payments/get-payment-id";
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
          morePaymentsResults = jsonDecode(response.body);
          for (int i = 0;
              i < morePaymentsResults['payments']['data'].length;
              i++) {
            PaymentOperation payment = new PaymentOperation(
                int.parse(morePaymentsResults['payments']['data'][i]['id']
                    .toString()),
                morePaymentsResults['payments']['data'][i]['wallet_number']
                    .toString(),
                morePaymentsResults['payments']['data'][i]['date'].toString(),
                int.parse(morePaymentsResults['payments']['data'][i]['done']));
            setState(() {
              payments.add(payment);
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
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (cash == 0) {
        if (commessionPages == commessions_count) {
          setState(() {
            getMoreData(commessionPages);
          });
        } else {
          getMoreData(commessionPages);
        }
      } else {
        if (paymentPages == payments_count) {
          setState(() {
            getMorePayData(paymentPages);
          });
        } else {
          getMorePayData(paymentPages);
        }
      }
      print("bottom");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData(commessionPages);
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true || results == null
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 150, 102),
              ), //show this if state is loading
            ],
          ))
        : Container(
            child: Container(
            child: ListView(controller: _controller, children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "العمولة الحالية",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            "${results['total'][0].toString()} جنيه",
                            style: TextStyle(fontSize: 20),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 22,
                                ),
                                height: 2.5,
                                color: Color.fromARGB(255, 255, 150, 102),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => Payment())));
                                },
                                child: Text(
                                  "سحب",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                ),
                                onPressed: () {
                                  if (cash == 0) {
                                    setState(() {
                                      cash = 1;
                                      getPayData(paymentPages);
                                    });
                                  } else {
                                    setState(() {
                                      cash = 0;
                                      getData(commessionPages);
                                    });
                                  }
                                },
                                child: cash == 0
                                    ? Text(
                                        "طلبات السحب",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        "العمولات",
                                        style: TextStyle(color: Colors.white),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 150, 102),
                      padding: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => InviteCode())));
                    },
                    child: Text(
                      "كود الدعوة",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              cash == 0
                  ? commessions.length == 0
                      ? Center(
                          child: Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "لا يوجد عمولات ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102),
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: commessions.length,
                          itemBuilder: (BuildContext context, int i) {
                            return commessionPages <= commessions_count &&
                                    commessions_count != 1 &&
                                    i == commessions.length - 1
                                ? Column(
                                    children: [
                                      Card(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "تم ربح عمولة 5% من اجمالي اوردر رقم ${commessions[i].id} بقيمة ${commessions[i].total / 20} جنيه بتاريخ ${commessions[i].done_date}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 150, 102),
                                                  fontSize: 16),
                                            )),
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
                                      ))
                                    ],
                                  )
                                : Card(
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "تم ربح عمولة 5% من اجمالي اوردر رقم ${commessions[i].id} بقيمة ${commessions[i].total / 20} جنيه بتاريخ ${commessions[i].done_date}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              fontSize: 16),
                                        )),
                                  );
                          },
                        )
                  : payments.length == 0
                      ? Center(
                          child: Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "لا يوجد طلبات سحب ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 150, 102),
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: payments.length,
                          itemBuilder: (BuildContext context, int i) {
                            return paymentPages <= payments_count &&
                                    payments_count != 1 &&
                                    i == payments.length - 1
                                ? Column(
                                    children: [
                                      Card(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "رقم الاوردر : ${payments[i].id} \n رقم المحفظة الالكترونية : ${payments[i].phone} \n التاريخ : ${payments[i].date} \n ${payments[i].done == 0 ? 'سيتم التحويل قريبا' : 'تم التحويل'}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 150, 102),
                                                  fontSize: 16),
                                            )),
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
                                      ))
                                    ],
                                  )
                                : Card(
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "رقم الاوردر : ${payments[i].id} \n رقم المحفظة الالكترونية : ${payments[i].phone} \n التاريخ : ${payments[i].date} \n ${payments[i].done == 0 ? 'سيتم التحويل قريبا' : 'تم التحويل'}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 150, 102),
                                              fontSize: 16),
                                        )),
                                  );
                          },
                        ),
            ]),
          ));
  }
}

class PaymentOperation {
  final int id;
  final String phone;
  final String date;
  final int done;
  PaymentOperation(this.id, this.phone, this.date, this.done);
}

class Commession {
  final int id;
  final int total;
  final String done_date;
  Commession(this.id, this.total, this.done_date);
}
