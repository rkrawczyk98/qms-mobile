import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    onPrimary: Colors.white, // For icons or text on primary color
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
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
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.grey,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey[300]),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  hintColor: Colors.white, // Tooltip color
  dividerColor: Colors.grey[600], // Frame color
);
