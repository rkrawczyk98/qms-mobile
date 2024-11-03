import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
  ),
  hintColor: Colors.grey[600], // Tooltip color
  dividerColor: Colors.grey[400], // Frame color
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Colors.grey,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey[300]),
  ),
  hintColor: Colors.white, // Tooltip color
  dividerColor: Colors.grey[600], // Frame color
);
