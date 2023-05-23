import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextFormFieldDropDown extends StatefulWidget {
  final textFormFieldNum;
  late List<BankListDataModel> bankDataList = [];
  TextFormFieldDropDown({Key? key, required this.textFormFieldNum})
      : super(key: key);

  @override
  _TextFormFieldDropDownState createState() => _TextFormFieldDropDownState();
}

class _TextFormFieldDropDownState extends State<TextFormFieldDropDown> {
  //String _bankChoose;
  late BankListDataModel _bankChoose;
  late IconData icon;
  Color mainColor = Color.fromARGB(255, 255, 150, 102);
  Color errorColor = Colors.red;
  final double borderRadius = 50;
  final double borderWidth = 2;
  final double textFontSize = 20;
  final double iconSize = 40;
  late bool _validate;

  late Color existedColor;
  late List<BankListDataModel> gender = [
    BankListDataModel("النوع"),
    BankListDataModel("ذكر"),
    BankListDataModel("انثى"),
  ];
  @override
  void initState() {
    super.initState();
    existedColor = mainColor;
    icon = Icons.family_restroom;
    widget.bankDataList = gender;
    _bankChoose = widget.bankDataList[0];
    _validate = false;
  }

  void _onDropDownItemSelected(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChoose = newSelectedBank;
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = new OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: existedColor, width: borderWidth));
    TextStyle textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: existedColor,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FormField<String>(builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: "النوع",
            prefixIcon: Icon(icon, color: existedColor),
            //Icon(Icons.person, size: 40, color: widget.mainColor),
            hintStyle: textStyle,
            errorText: _validate ? 'من فضلك ادخل البيانات' : null,
            errorStyle: TextStyle(
              fontSize: textFontSize - 4,
              color: errorColor,
            ),
            contentPadding:
                EdgeInsets.only(top: 10, right: 25, bottom: 10, left: 10),
            disabledBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: errorColor, width: borderWidth)),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                width: borderWidth,
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
                    _bankChoose.bank_name,
                    style: textStyle,
                  ),
                  items: widget.bankDataList
                      .map<DropdownMenuItem<BankListDataModel>>(
                          (BankListDataModel value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          Text(value.bank_name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (BankListDataModel? newSelectedBank) {
                    _onDropDownItemSelected(newSelectedBank!);
                  },
                  value: _bankChoose,
                ),
              ),
            ),
          ),
        );
      }, validator: (value) {
        value = _bankChoose.bank_name.toString();
        if (value == "النوع") {
          setState(() {
            existedColor = errorColor;
            _validate = true;
          });
          return 'من فضلك ادخل البيانات';
        } else {
          setPrefs() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (value == "ذكر") {
              prefs.setInt("gender", 1);
            } else {
              prefs.setInt("gender", 0);
            }
          }

          setPrefs();
        }
      }),
    );
  }
}

class BankListDataModel {
  String bank_name;
  BankListDataModel(this.bank_name);
}
