import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade50,
    primary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade800,
    secondary: Colors.grey.shade300,
    tertiary: Colors.blue.shade300,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey.shade800,
        displayColor: Colors.black,
      ),
);
