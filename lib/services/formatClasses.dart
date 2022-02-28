import 'package:flutter/material.dart';

class MyColors {

  Color bgColor = const Color(0xFFF5F5F6);
  Color fgColor = const Color(0xFFE1E2E1);
  Color color1 = const Color(0xFF607D8B);
  Color lightColor1 = const Color(0xFF8EACBB);
  Color darkColor1 = const Color(0xFF34515E);
  Color textColor = const Color(0xFFF5F5F6);

}

class MyTextStyle {

  TextStyle title = TextStyle(color: MyColors().textColor, fontFamily: 'Roboto', fontWeight: FontWeight.w500, fontSize: 55.0);
  TextStyle clock = TextStyle(color: MyColors().textColor, fontFamily: 'Roboto', fontSize: 80.0);
  TextStyle large = TextStyle(color: MyColors().textColor, fontFamily: 'Roboto', fontSize: 30.0);
  TextStyle medium = TextStyle(color: MyColors().textColor, fontFamily: 'Roboto', fontSize: 18.0);
  TextStyle small = TextStyle(color: MyColors().textColor, fontFamily: 'Roboto', fontSize: 16.0);

}

