import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    onPrimary: Colors.blue, // For icons or text on primary color
    secondary: Colors.lightBlue[50]!,
    onSecondary: Colors.blue,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.blue),
  hintColor: Colors.grey[600], // Tooltip color
  dividerColor: Colors.grey[400], // Frame color
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[900]!,
    onPrimary: Colors.white, // For icons or text on primary color
    secondary: Colors.grey[600]!,
    onSecondary: Colors.grey[600]!,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.grey,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    foregroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey[300]),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  hintColor: Colors.white, // Tooltip color
  dividerColor: Colors.grey[600], // Frame color
);
