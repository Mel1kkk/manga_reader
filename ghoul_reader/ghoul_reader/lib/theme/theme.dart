import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200, // background color
    primary: Colors.grey.shade900, // text color
    secondary: Colors.grey.shade300, // container color
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade900,
  ),
);