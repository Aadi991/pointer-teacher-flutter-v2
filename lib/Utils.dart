import 'dart:math';

import 'package:flutter/material.dart';

import 'Storage/SignInOption.dart';

class Utils {
  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  static int randomRange(int min, int max) =>
      min + new Random().nextInt(max - min);

  static void showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));

  static String random10DigitNumber() {
    String ret = " ";
    for (int i = 0; i < 10; i++) {
      ret = ret + Utils.randomRange(1, 9).toString();
    }
    return ret;
  }
}

class GlobalVariables{
  static SignInOptions signInOption = SignInOptions.None;
  static ProfileFrom profileFrom = ProfileFrom.None;
}

enum ProfileFrom{
  None,
  SplashPage,
  SignInWidget,
  RegisterWidget,
  SignInOrRegister,
  Home
}

class SharedPrefsKeys{
  static const String phoneNoKey = 'Phone Number';
  static const String schoolIDKey = 'School ID';
}