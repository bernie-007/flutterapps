import 'package:flutter/material.dart';

class AppColor {
  final Color primaryColor;
  final Color primaryLightColor;
  final Color darkColor;
  final Color lightColor;
  final Color greyColor;
  final Color greyLightColor;
  final Color pinkColor;

  AppColor({
    this.primaryColor,
    this.primaryLightColor,
    this.darkColor,
    this.lightColor,
    this.greyColor,
    this.greyLightColor,
    this.pinkColor
  });
}

AppColor appColors = new AppColor(
  primaryColor: Color.fromRGBO(25, 118, 211, 1.0),
  primaryLightColor: Color.fromRGBO(25, 118, 211, 0.3),
  darkColor: Color.fromRGBO(40, 40, 40, 1.0),
  lightColor: Color.fromRGBO(243, 243, 243, 1.0),
  greyColor: Color.fromRGBO(123, 123, 123, 1.0),
  greyLightColor: Color.fromRGBO(123, 123, 123, 0.3),
  pinkColor: Color.fromRGBO(255, 65, 129, 1.0)
);