import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    onPrimary: Colors.white, // Text on primary buttons
    secondary: Colors.lightBlue.shade100,
    onSecondary: Colors.blue, // Text on secondary buttons
    surface: Colors.blue.shade50, // Background of cards, buttons
    onSurface: Colors.black, // Text on cards, buttons
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Button background color
      foregroundColor: Colors.white, // Button Text/Icon Color
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.blue),
  appBarTheme: const AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: Colors.white)),
  tabBarTheme: TabBarTheme(
    labelStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold), // Active Tab Style
    unselectedLabelStyle:
        const TextStyle(fontSize: 14), // Inactive Tab Style
    labelColor: Colors.white, // Active Tab Color
    unselectedLabelColor: Colors.grey[700], // Inactive Tab Color
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(width: 4.0, color: Colors.white), // Pointer style
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade900,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade900,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade600,
    onSecondary: Colors.black,
    surface: Colors.grey.shade800,
    onSurface: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey.shade300),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: const AppBarTheme(
      color: Colors.grey,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: Colors.white)),
  tabBarTheme: TabBarTheme(
    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontSize: 14),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey[700],
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(width: 4.0, color: Colors.white),
    ),
  ),
);
