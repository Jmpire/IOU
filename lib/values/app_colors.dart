import 'package:flutter/material.dart';

// defines the colors used in the app
class AppColors {
  static bool theme = true;
  static Color waveBackgroundColor = const Color(0xff1D2228);
  static Color orange = const Color(0xffFC8123);
  static Color pieDark = const Color(0xff1D2228);
  static Color background = const Color(0xff1D2228);
  static Color appBackgroundColor = Colors.white;
  static Color red = Colors.red;
  static Color statusBarColor = const Color(0xff16191E);
  static Color blackText = Colors.black;
  static Color whiteText = Colors.white;
  static Color divider = const Color(0xffF5F5F5);

  AppColors() {
    if (theme == true) {
      whiteText = Colors.black;
      waveBackgroundColor = Colors.blue;
      blackText = Colors.white;
      appBackgroundColor = const Color(0xff1D2228);
      pieDark = Colors.blue;
      divider = const Color.fromARGB(255, 49, 55, 62);
    } else {
      divider = const Color(0xffF5F5F5);
      blackText = Colors.black;
      whiteText = Colors.white;
      appBackgroundColor = Colors.white;
      waveBackgroundColor = const Color(0xff1D2228);
      pieDark = const Color(0xff1D2228);
    }
  }
}
