import 'package:flutter/material.dart';
import 'package:get_store/Auth/registeration/main/components/textFormFieldWithDropDownListComponent.dart';
import 'package:get_store/Auth/registeration/main/mainView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/components/textformfieldCompnent.dart.dart';

class Register3 extends StatefulWidget {
  Register3({Key? key}) : super(key: key);

  @override
  State<Register3> createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  late BankListDataModel _bankChooseState;
  late BankListDataModel _bankChooseCenter;

  late List<BankListDataModel> _gender;
  late List<BankListDataModel> _state;
  late List<BankListDataModel> _center;

  late Color existedColor;
  late Color mainColor = Color.fromARGB(255, 255, 150, 102);
  late Color errorColor = Colors.red;

  bool checkedValue = false;
  late bool _validate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    existedColor = mainColor;
    _validate = false;
    _state = [
      BankListDataModel("المحافظة"),
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
    _center = [
      BankListDataModel("المركز"),
    ];
    _bankChooseState = _state[0];
    _bankChooseCenter = _center[0];
  }

  void _onDropDownItemSelectedState(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseState = newSelectedBank;
      if (newSelectedBank.bank_name.toString() == "الإسكندرية") {
        _center = [
          BankListDataModel("الإسكندرية"),
          BankListDataModel("برج العرب"),
        ];
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
      }
      if (newSelectedBank.bank_name.toString() == "أسوان") {
        _center = [
          BankListDataModel("أسوان"),
          BankListDataModel("دراو"),
          BankListDataModel("كوم امبو"),
          BankListDataModel("النوبة"),
          BankListDataModel("ادفو")
        ];
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
      }
      if (newSelectedBank.bank_name.toString() == "دمياط") {
        _center = [
          BankListDataModel("دمياط"),
          BankListDataModel("فارسكور"),
          BankListDataModel("كفر سعد"),
          BankListDataModel("الزرقا"),
          BankListDataModel("كفر البطيخ")
        ];
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
      }
      if (newSelectedBank.bank_name.toString() == "السويس") {
        _center = [
          BankListDataModel("السويس"),
          BankListDataModel("الاربعين"),
          BankListDataModel("عتاقة"),
          BankListDataModel("الجناين"),
          BankListDataModel("فيصل")
        ];
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
      }
      if (newSelectedBank.bank_name.toString() == "القاهرة") {
        _center = [
          BankListDataModel("القاهرة"),
        ];
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
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
        _bankChooseCenter = _center[0];
      }
      if (newSelectedBank.bank_name.toString() == "الوادي الجديد") {
        _center = [
          BankListDataModel("الخارجة"),
          BankListDataModel("باريس"),
          BankListDataModel("الداخلة"),
          BankListDataModel("الفرافرة"),
          BankListDataModel("بلاط")
        ];
        _bankChooseCenter = _center[0];
      }
    });
  }

  void _onDropDownItemSelectedCenter(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChooseCenter = newSelectedBank;
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: existedColor, width: 2));

    TextStyle textStyle = new TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: existedColor,
    );
    return MainView(
        title: "تسجيل حساب",
        content: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: FormField<String>(builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    hintText: "المحافظة",
                    errorText: _validate ? 'من فضلك ادخل البيانات' : null,
                    errorStyle: TextStyle(
                      fontSize: 16,
                      color: errorColor,
                    ),
                    prefixIcon: Icon(
                      Icons.flag,
                      size: 40,
                      color: existedColor,
                    ),
                    //Icon(Icons.person, size: 40, color: widget.mainColor),
                    hintStyle: textStyle,
                    contentPadding: EdgeInsets.only(
                        top: 10, right: 25, bottom: 10, left: 10),
                    disabledBorder: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: errorColor, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        width: 2,
                        color: errorColor,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: SingleChildScrollView(
                      child: Container(
                        child: DropdownButton<BankListDataModel>(
                          style: textStyle,
                          hint: Text(
                            "Select Bank",
                            style: textStyle,
                          ),
                          items: _state
                              .map<DropdownMenuItem<BankListDataModel>>(
                                  (BankListDataModel value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(value.bank_name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (BankListDataModel? newSelectedBank) {
                            _onDropDownItemSelectedState(newSelectedBank!);
                          },
                          value: _bankChooseState,
                        ),
                      ),
                    ),
                  ),
                );
              }, validator: (value) {
                value = _bankChooseState.bank_name.toString();
                if (value == "المحافظة") {
                  setState(() {
                    existedColor = errorColor;
                    _validate = true;
                  });
                  return 'من فضلك ادخل البيانات';
                } else {
                  setPrefs() async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("state", value!);
                  }

                  setPrefs();
                }
              }),
            ),
            SizedBox(
              height: 27,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: FormField<String>(builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    hintText: "المركز",
                    errorText: _validate ? 'من فضلك ادخل البيانات' : null,
                    errorStyle: TextStyle(
                      fontSize: 16,
                      color: errorColor,
                    ),
                    prefixIcon: Icon(
                      Icons.location_city,
                      size: 40,
                      color: existedColor,
                    ),
                    //Icon(Icons.person, size: 40, color: widget.mainColor),
                    hintStyle: textStyle,
                    contentPadding: EdgeInsets.only(
                        top: 10, right: 25, bottom: 10, left: 10),
                    disabledBorder: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: errorColor, width: 2)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        width: 2,
                        color: errorColor,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: SingleChildScrollView(
                      child: Container(
                        child: DropdownButton<BankListDataModel>(
                          style: textStyle,
                          hint: Text(
                            "Select Bank",
                            style: textStyle,
                          ),
                          items: _center
                              .map<DropdownMenuItem<BankListDataModel>>(
                                  (BankListDataModel value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(value.bank_name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (BankListDataModel? newSelectedBank) {
                            _onDropDownItemSelectedCenter(newSelectedBank!);
                          },
                          value: _bankChooseCenter,
                        ),
                      ),
                    ),
                  ),
                );
              }, validator: (value) {
                value = _bankChooseCenter.bank_name.toString();
                if (value == "المركز") {
                  setState(() {
                    existedColor = errorColor;
                    _validate = true;
                  });
                  return 'من فضلك ادخل البيانات';
                } else {
                  setPrefs() async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("center", value!);
                  }

                  setPrefs();
                }
              }),
            ),
            SizedBox(
              height: 27,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormFieldComponent(
                  textInputType: TextInputType.text,
                  textFormFieldNum: 9,
                )),
            SizedBox(
              height: 27,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 150, 102),
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 100, 100, 100),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            )
          ],
        ),
        buttonText: "التالي",
        btnClick: 3,
        RegisterOrLogin: "لدي حساب بالفعل");
  }
}

class BankListDataModel {
  String bank_name;
  BankListDataModel(this.bank_name);
}
