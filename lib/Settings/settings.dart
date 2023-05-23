import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_store/General/connectionFailed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int user_id = 0;
  bool isLoading = false;
  var results;

  late BankListDataModel _bankChooseState;
  late BankListDataModel _bankChooseCenter;
  late BankListDataModel _bankChooseGender;

  late List<BankListDataModel> _gender;
  late List<BankListDataModel> _state;
  late List<BankListDataModel> _center;

  late Color existedColor;
  late Color mainColor = Color.fromARGB(255, 255, 150, 102);
  late Color errorColor = Colors.red;
  final _formKey = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  bool checkedValue = false;
  late bool _validate;

  late String stringDate;
  TextEditingController dateinput = TextEditingController();
  DateTime getBirthdate = DateTime.now();

  bool nameError = false;
  bool phoneError = false;
  bool addressError = false;

  String name = "";
  String phone = "";
  String dateOfBirth = "";
  String state = "";
  String center = "";
  String address = "";
  int gender = 0;

  String oldPassword = "";
  String newPassword = "";
  String reNewPassword = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    existedColor = mainColor;
    _validate = false;
    _gender = [
      BankListDataModel("ذكر"),
      BankListDataModel("انثى"),
    ];
    getData();
  }

  void _onDropDownItemSelectedGender(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseGender = newSelectedBank;
      if (_bankChooseGender.toString() == "ذكر") {
        gender = 1;
      } else {
        gender = 0;
      }
    });
  }

  void _onDropDownItemSelectedState(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseState = newSelectedBank;
      state = _bankChooseState.bank_name.toString();
      if (newSelectedBank.bank_name.toString() == "الإسكندرية") {
        _center = [
          BankListDataModel("الإسكندرية"),
          BankListDataModel("برج العرب"),
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الإسماعيلية") {
        _center = [
          BankListDataModel("الإسماعيلية"),
          BankListDataModel("فايد"),
          BankListDataModel("القنطرة شرق"),
          BankListDataModel("القنطرة غرب"),
          BankListDataModel("التل الكبير"),
          BankListDataModel("ابو صوير"),
          BankListDataModel("القصاصين")
        ];
      }
      if (newSelectedBank.bank_name.toString() == "أسوان") {
        _center = [
          BankListDataModel("أسوان"),
          BankListDataModel("دراو"),
          BankListDataModel("كوم امبو"),
          BankListDataModel("النوبة"),
          BankListDataModel("ادفو")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "أسيوط") {
        _center = [
          BankListDataModel("أسيوط"),
          BankListDataModel("ديروط"),
          BankListDataModel("منقلوط"),
          BankListDataModel("القوصية"),
          BankListDataModel("ابنوب"),
          BankListDataModel("ابو تيج"),
          BankListDataModel("الغنايم"),
          BankListDataModel("ساحل سليم"),
          BankListDataModel("البداري"),
          BankListDataModel("الفتح")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الأقصر") {
        _center = [
          BankListDataModel("الزينية"),
          BankListDataModel("البياضية"),
          BankListDataModel("القرنة"),
          BankListDataModel("ارمنت"),
          BankListDataModel("الطود"),
          BankListDataModel("اسنا")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "البحر الأحمر") {
        _center = [
          BankListDataModel("رأس غارب"),
          BankListDataModel("الغردقة"),
          BankListDataModel("القصير"),
          BankListDataModel("سفاجا"),
          BankListDataModel("مرسى علم"),
          BankListDataModel("حلايب"),
          BankListDataModel("شلاتين")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "البحيرة") {
        _center = [
          BankListDataModel("دمنهور"),
          BankListDataModel("كفر الدوار"),
          BankListDataModel("رشيد"),
          BankListDataModel("ادكو"),
          BankListDataModel("ابو المطامير"),
          BankListDataModel("ابو حمص"),
          BankListDataModel("الدلنجات"),
          BankListDataModel("المحمودية"),
          BankListDataModel("الرحمانية"),
          BankListDataModel("ايتاي البارود"),
          BankListDataModel("حوش عيسى"),
          BankListDataModel("شبراخيت"),
          BankListDataModel("كوم حمادة"),
          BankListDataModel("بدر"),
          BankListDataModel("وادي النطرون")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "بني سويف") {
        _center = [
          BankListDataModel("بني سويف"),
          BankListDataModel("الواسطي"),
          BankListDataModel("ناصر"),
          BankListDataModel("اهناسيا"),
          BankListDataModel("بيا"),
          BankListDataModel("سمسطا"),
          BankListDataModel("الفشن")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "بورسعيد") {
        _center = [
          BankListDataModel("حي الشرق"),
          BankListDataModel("حي الجنوب"),
          BankListDataModel("بورفؤاد"),
          BankListDataModel("الضواحي"),
          BankListDataModel("المناخ"),
          BankListDataModel("الزهور"),
          BankListDataModel("العرب")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "جنوب سيناء") {
        _center = [
          BankListDataModel("ابو رديس"),
          BankListDataModel("ابو زنيمة"),
          BankListDataModel("نويبع"),
          BankListDataModel("طابا"),
          BankListDataModel("رأس سدر"),
          BankListDataModel("دهب"),
          BankListDataModel("شرم الشيخ"),
          BankListDataModel("سانت كاترين"),
          BankListDataModel("الطور")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الجيزة") {
        _center = [
          BankListDataModel("البدرشين"),
          BankListDataModel("الصف"),
          BankListDataModel("اطفيح"),
          BankListDataModel("العياط"),
          BankListDataModel("الواحات البحرية"),
          BankListDataModel("منشأة القناطر"),
          BankListDataModel("اوسيم"),
          BankListDataModel("كرداسة"),
          BankListDataModel("ابو النمرس")
        ];
        ;
      }

      if (newSelectedBank.bank_name.toString() == "الدقهلية") {
        _center = [
          BankListDataModel("المنصورة"),
          BankListDataModel("طلخا"),
          BankListDataModel("ميت غمر"),
          BankListDataModel("دكرنس"),
          BankListDataModel("أجا"),
          BankListDataModel("منية النصر"),
          BankListDataModel("السنبلاوين"),
          BankListDataModel("بني عبيد"),
          BankListDataModel("المنزلة"),
          BankListDataModel("تمي الامديد"),
          BankListDataModel("الجمالية"),
          BankListDataModel("شربين"),
          BankListDataModel("المطرية"),
          BankListDataModel("بلقاس"),
          BankListDataModel("ميت سلسيل"),
          BankListDataModel("محلة دمنة"),
          BankListDataModel("نبروه")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "دمياط") {
        _center = [
          BankListDataModel("دمياط"),
          BankListDataModel("فارسكور"),
          BankListDataModel("كفر سعد"),
          BankListDataModel("الزرقا"),
          BankListDataModel("كفر البطيخ")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "سوهاج") {
        _center = [
          BankListDataModel("سوهاج"),
          BankListDataModel("اخميم"),
          BankListDataModel("البلينا"),
          BankListDataModel("المراغة"),
          BankListDataModel("المنشأة"),
          BankListDataModel("دار السلام"),
          BankListDataModel("جرجا"),
          BankListDataModel("جهينة"),
          BankListDataModel("ساقلته"),
          BankListDataModel("طما"),
          BankListDataModel("طهطا"),
          BankListDataModel("العسيرات")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "السويس") {
        _center = [
          BankListDataModel("السويس"),
          BankListDataModel("الاربعين"),
          BankListDataModel("عتاقة"),
          BankListDataModel("الجناين"),
          BankListDataModel("فيصل")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الشرقية") {
        _center = [
          BankListDataModel("الزقازيق"),
          BankListDataModel("منيا القمح"),
          BankListDataModel("بلبيس"),
          BankListDataModel("مشتول السوق"),
          BankListDataModel("ابو حماد"),
          BankListDataModel("ههيا"),
          BankListDataModel("ابو كبير"),
          BankListDataModel("فاقوس"),
          BankListDataModel("الابراهيمية"),
          BankListDataModel("ديرب النجم"),
          BankListDataModel("كفر صقر"),
          BankListDataModel("اولاد صقر"),
          BankListDataModel("الحسينية")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "شمال سيناء") {
        _center = [
          BankListDataModel("العريش"),
          BankListDataModel("الشيخ زويد"),
          BankListDataModel("رفح"),
          BankListDataModel("بئر العبد"),
          BankListDataModel("الحسنة"),
          BankListDataModel("نخل")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الغربية") {
        _center = [
          BankListDataModel("طنطا"),
          BankListDataModel("المحلة الكبرى"),
          BankListDataModel("كفر الزيات"),
          BankListDataModel("زفتى"),
          BankListDataModel("السنطة"),
          BankListDataModel("قطور"),
          BankListDataModel("بسيون"),
          BankListDataModel("سمنود")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "الفيوم") {
        _center = [
          BankListDataModel("الفيوم"),
          BankListDataModel("طامية"),
          BankListDataModel("سنورس"),
          BankListDataModel("اطسا"),
          BankListDataModel("شواي"),
          BankListDataModel("يوسف الصديق")
        ];
        ;
      }
      if (newSelectedBank.bank_name.toString() == "القاهرة") {
        _center = [
          BankListDataModel("التجمع الخامس"),
          BankListDataModel("مدينة نصر")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "القليوبية") {
        _center = [
          BankListDataModel("بنها"),
          BankListDataModel("قليوب"),
          BankListDataModel("القناطر الخيرية"),
          BankListDataModel("الخانكة"),
          BankListDataModel("كفر شكر"),
          BankListDataModel("طوخ"),
          BankListDataModel("شبين القناطر")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "قنا") {
        _center = [
          BankListDataModel("قنا"),
          BankListDataModel("ابو تشت"),
          BankListDataModel("نجع جمادي"),
          BankListDataModel("دشنا"),
          BankListDataModel("الوقف"),
          BankListDataModel("فقط"),
          BankListDataModel("نقادة"),
          BankListDataModel("قوص"),
          BankListDataModel("فرشوط")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "كفر الشيخ") {
        _center = [
          BankListDataModel("كفر الشيخ"),
          BankListDataModel("دسوق"),
          BankListDataModel("فوه"),
          BankListDataModel("مطويس"),
          BankListDataModel("البرلس"),
          BankListDataModel("الحامول"),
          BankListDataModel("بيلا"),
          BankListDataModel("الرياض"),
          BankListDataModel("سيدي سالم"),
          BankListDataModel("قلين")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "مطروح") {
        _center = [
          BankListDataModel("مرسى مطروح"),
          BankListDataModel("الحمام"),
          BankListDataModel("العلمين"),
          BankListDataModel("الضبعة"),
          BankListDataModel("سيدي براني"),
          BankListDataModel("السلوم"),
          BankListDataModel("سيوة")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "المنوفية") {
        _center = [
          BankListDataModel("شبين الكوم"),
          BankListDataModel("السادات"),
          BankListDataModel("منوف"),
          BankListDataModel("اشمون"),
          BankListDataModel("الباجور"),
          BankListDataModel("قويسنا"),
          BankListDataModel("بركة السبع"),
          BankListDataModel("تلا"),
          BankListDataModel("الشهداء")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "المنيا") {
        _center = [
          BankListDataModel("المنيا"),
          BankListDataModel("العدوة"),
          BankListDataModel("مغاغا"),
          BankListDataModel("بني مزار"),
          BankListDataModel("مطاي"),
          BankListDataModel("سمالوط"),
          BankListDataModel("ابو قرقاص"),
          BankListDataModel("ملوى"),
          BankListDataModel("دير مواس")
        ];
        //
      }
      if (newSelectedBank.bank_name.toString() == "الوادي الجديد") {
        _center = [
          BankListDataModel("الخارجة"),
          BankListDataModel("باريس"),
          BankListDataModel("الداخلة"),
          BankListDataModel("الفرافرة"),
          BankListDataModel("بلاط")
        ];
        //
      }
      _onDropDownItemSelectedCenter(_center[0]);
    });
  }

  void _onDropDownItemSelectedCenter(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseCenter = newSelectedBank;
      center = _bankChooseCenter.bank_name.toString();
    });
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;

        var url = "http://app.getcenter.info/api/v1/users/get-user-id";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode(
              {"id": user_id, "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"}),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          results = jsonDecode(response.body);
          _state = [
            BankListDataModel("${results['state'].toString()}"),
            BankListDataModel("الإسكندرية"),
            BankListDataModel("الإسماعيلية"),
            BankListDataModel("أسوان"),
            BankListDataModel("أسيوط"),
            BankListDataModel("الأقصر"),
            BankListDataModel("البحر الأحمر"),
            BankListDataModel("البحيرة"),
            BankListDataModel("بني سويف"),
            BankListDataModel("بورسعيد"),
            BankListDataModel("جنوب سيناء"),
            BankListDataModel("الجيزة"),
            BankListDataModel("الدقهلية"),
            BankListDataModel("دمياط"),
            BankListDataModel("سوهاج"),
            BankListDataModel("السويس"),
            BankListDataModel("الشرقية"),
            BankListDataModel("شمال سيناء"),
            BankListDataModel("الغربية"),
            BankListDataModel("الفيوم"),
            BankListDataModel("القاهرة"),
            BankListDataModel("القليوبية"),
            BankListDataModel("قنا"),
            BankListDataModel("كفر الشيخ"),
            BankListDataModel("مطروح"),
            BankListDataModel("المنوفية"),
            BankListDataModel("المنيا"),
            BankListDataModel("الوادي الجديد"),
          ];

          final cut = _state.lastIndexWhere(
              (_state) => _state.bank_name == "${results['state'].toString()}");
          _state = _state..removeAt(cut);

          _center = [
            BankListDataModel("المركز"),
          ];
          _bankChooseState = _state[0];
          ;
          _bankChooseGender = _gender[0];

          _onDropDownItemSelectedState(_state[0]);
          if (results['gender'] == 1) {
          } else {
            _onDropDownItemSelectedState(_gender[1]);
          }
          getBirthdate = DateTime.parse(results['date_of_birth'].toString());
          setState(() {
            isLoading = false;
          });
          name = results['name'].toString();
          phone = results['mobile_number'].toString();
          dateOfBirth = results['date_of_birth'].toString();
          state = results['state'].toString();
          center = results['center'].toString();
          address = results['address'].toString();
          gender = results['gender'];
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
  }

  sendData() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("id")!;

        var url = "http://app.getcenter.info/api/v1/users/update";
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "user_id": user_id,
            "name": name,
            "mobile_number": phone,
            "date_of_birth": dateOfBirth,
            "state": state,
            "center": center,
            "address": address,
            "gender": gender,
            "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'تم حفظ البيانات',
            customHeader: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 150, 102),
                    borderRadius: BorderRadius.circular(150.0)),
                width: double.infinity,
                height: double.infinity,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 80,
                )),
            btnOkColor: Color.fromARGB(255, 255, 150, 102),
            //desc: 'Dialog description here..................................................',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            //btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
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

  sendNewPassword() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool check = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (check == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String checkPassword = prefs.getString("pass_login")!;

        if (oldPassword == checkPassword && newPassword == reNewPassword) {
          print(newPassword);
          user_id = prefs.getInt("id")!;
          var url = "http://app.getcenter.info/api/v1/users/update-password";
          var response = await http.post(
            Uri.parse(url),
            body: jsonEncode({
              "user_id": user_id,
              'password': newPassword,
              "api_password": "tQnyBMCfK32bUx6pUnIh5IzR"
            }),
            headers: {"Content-type": "Application/json;charset=UTF-8"},
          );
          if (response.statusCode == 200) {
            AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              showCloseIcon: true,
              title: 'تم حفظ البيانات',
              customHeader: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 150, 102),
                      borderRadius: BorderRadius.circular(150.0)),
                  width: double.infinity,
                  height: double.infinity,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 80,
                  )),
              btnOkColor: Color.fromARGB(255, 255, 150, 102),
              //desc: 'Dialog description here..................................................',
              btnOkOnPress: () {},
              //btnOkIcon: Icons.check_circle,
            ).show();
          } else {
            Fluttertoast.showToast(
                msg: "خطأ في تعديل كلمة السر",
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

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Color.fromARGB(255, 255, 150, 102),
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: TabBar(indicatorColor: Colors.white, tabs: [
        Tab(
          child: Text("بيانات الحساب"),
        ),
        Tab(
          child: Text("كلمة السر"),
        ),
      ]),
    );
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: appBar,
          body: isLoading || results == null
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
              : TabBarView(children: [
                  SingleChildScrollView(
                    //physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 240, 240, 240),
                      height: screenHeight - (screenHeight / 17.5),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "اسم المستخدم",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 150, 102)),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            nameError = true;
                                          });
                                        } else if (RegExp(
                                                r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                            .hasMatch(value)) {
                                          setState(() {
                                            nameError = true;
                                          });
                                        }
                                      }),
                                      initialValue: results['name'].toString(),
                                      onChanged: ((value) {
                                        name = value;
                                      }),
                                      decoration: InputDecoration(
                                        hintText:
                                            nameError ? "خطأ في الاسم" : null,
                                        hintStyle: TextStyle(color: Colors.red),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: nameError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: nameError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: nameError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("تاريخ الميلاد",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 40,
                                    child: TextFormField(
                                      controller: dateinput,
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.calendar_month,
                                            color: Color.fromARGB(
                                                255, 255, 150, 102),
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          hintText: results['date_of_birth']
                                              .toString()),
                                      readOnly:
                                          true, //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: getBirthdate,
                                                firstDate: DateTime(
                                                    1900), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101),
                                                builder: (BuildContext context,
                                                    Widget? child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary: Color.fromARGB(
                                                            255,
                                                            255,
                                                            150,
                                                            102), // header background color
                                                        onPrimary: Colors
                                                            .white, // header text color
                                                        onSurface: Color.fromARGB(
                                                            255,
                                                            255,
                                                            150,
                                                            102), // body text color
                                                      ),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                        style: TextButton
                                                            .styleFrom(
                                                          primary: Color.fromARGB(
                                                              255,
                                                              255,
                                                              150,
                                                              102), // button text color
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                });

                                        if (pickedDate != null) {
                                          //pickedDate output format => 2021-03-10 00:00:00.000
                                          String formattedDate =
                                              intl.DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          //formatted date output using intl package =>  2021-03-16
                                          //you can implement different kind of Date Format here according to your requirement
                                          dateOfBirth = formattedDate;
                                          setState(() {
                                            dateinput.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                        } else {
                                          print("Date is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("رقم التليفون",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 30,
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            phoneError = true;
                                          });
                                        }
                                        bool numberCheck =
                                            value!.length == 11 &&
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
                                          setState(() {
                                            phoneError = true;
                                          });
                                        }
                                      }),
                                      initialValue:
                                          results['mobile_number'].toString(),
                                      onChanged: ((value) {
                                        phone = value;
                                      }),
                                      decoration: InputDecoration(
                                        hintText: phoneError
                                            ? "خطأ في ادخال رقم التليفون"
                                            : null,
                                        hintStyle: TextStyle(color: Colors.red),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: phoneError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: phoneError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: phoneError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("المحافظة",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 40,
                                    child: FormField<String>(builder:
                                        (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          contentPadding:
                                              EdgeInsets.only(top: -20),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              child: DropdownButton<
                                                  BankListDataModel>(
                                                hint: Text(
                                                  results['state'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                items: _state.map<
                                                        DropdownMenuItem<
                                                            BankListDataModel>>(
                                                    (BankListDataModel value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Row(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: [
                                                        Text(value.bank_name),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (BankListDataModel?
                                                    newSelectedBank) {
                                                  _onDropDownItemSelectedState(
                                                      newSelectedBank!);
                                                },
                                                value: _bankChooseState,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("المركز",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 40,
                                    child: FormField<String>(builder:
                                        (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          contentPadding:
                                              EdgeInsets.only(top: -20),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              child: DropdownButton<
                                                  BankListDataModel>(
                                                //style:  TextStyle(color: Color.fromARGB(255, 255, 150, 102)),
                                                hint: Text(
                                                  "Select Bank",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 150, 102)),
                                                ),
                                                items: _center.map<
                                                        DropdownMenuItem<
                                                            BankListDataModel>>(
                                                    (BankListDataModel value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Row(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: [
                                                        Text(value.bank_name),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (BankListDataModel?
                                                    newSelectedBank) {
                                                  _onDropDownItemSelectedCenter(
                                                      newSelectedBank!);
                                                },
                                                value: _bankChooseCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("العنوان",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 30,
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            addressError = true;
                                          });
                                        }
                                      }),
                                      initialValue:
                                          results['address'].toString(),
                                      onChanged: (value) {
                                        address = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: addressError
                                            ? "خطأ في ادخال العنوان"
                                            : null,
                                        hintStyle: TextStyle(color: Colors.red),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: addressError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: addressError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: addressError
                                                    ? Colors.red
                                                    : Color.fromARGB(
                                                        255, 143, 143, 143),
                                                width: 1)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("النوع",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 150, 102))),
                                  SizedBox(
                                    height: 40,
                                    child: FormField<String>(builder:
                                        (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 143, 143, 143),
                                                  width: 1)),
                                          contentPadding:
                                              EdgeInsets.only(top: -20),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              child: DropdownButton<
                                                  BankListDataModel>(
                                                //style:  TextStyle(color: Color.fromARGB(255, 255, 150, 102)),
                                                hint: Text(
                                                  "Select Bank",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 150, 102)),
                                                ),
                                                items: _gender.map<
                                                        DropdownMenuItem<
                                                            BankListDataModel>>(
                                                    (BankListDataModel value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Row(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      children: [
                                                        Text(value.bank_name),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (BankListDataModel?
                                                    newSelectedBank) {
                                                  _onDropDownItemSelectedGender(
                                                      newSelectedBank!);
                                                },
                                                value: _bankChooseGender,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 150, 102),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        sendData();
                                      }
                                    },
                                    child: Text(
                                      "حفظ البيانات",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 19),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    //physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 240, 240, 240),
                      height: screenHeight - (screenHeight / 17.5),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Form(
                          key: _formKeyPass,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            oldPassword = value;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 143, 143, 143),
                                                        width: 1)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            hintText: "كلمة السر",
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 150, 102)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          obscureText: true,
                                          onChanged: (value) {
                                            newPassword = value;
                                          },
                                          validator: (value) {
                                            if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')
                                                    .hasMatch(value!) ||
                                                value.isEmpty) {
                                              return 'خطا في ادخال كلمة السر';
                                            }
                                            if (value.length < 8) {
                                              return 'يجب الا تقل كلمة السر عن 8 خانات';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 143, 143, 143),
                                                        width: 1)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            hintText: "كلمة السر الجديدة",
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 150, 102)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          obscureText: true,
                                          onChanged: (value) {
                                            reNewPassword = value;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'خطا في ادخال كلمة السر';
                                            }
                                            if (value.length < 8) {
                                              return 'يجب الا تقل كلمة السر عن 8 خانات';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 143, 143, 143),
                                                        width: 1)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 143, 143, 143),
                                                    width: 1)),
                                            hintText: "اعادة كلمة السر الجديدة",
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 150, 102)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 150, 102),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                    ),
                                    onPressed: () {
                                      if (_formKeyPass.currentState!
                                          .validate()) {
                                        sendNewPassword();
                                      }
                                    },
                                    child: Text(
                                      "حفظ كلمة السر",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 19),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
    );
  }
}

class BankListDataModel {
  String bank_name;
  BankListDataModel(this.bank_name);
}
