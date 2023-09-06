import 'package:flutter/material.dart';

const primaryColor = Colors.green;
const accentColor = Colors.green;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  //appbar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
  ),
  //floating Action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentColor,
  ),
  //Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(accentColor),
    ),
  ),
  //Input Box theme
  // inputDecorationTheme: InputDecorationTheme(
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(20.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   //filled: true,
  //   fillColor: Colors.grey.withOpacity(0.1),
  //   enabledBorder: const OutlineInputBorder(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(40.0),
  //     ),
  //     borderSide: BorderSide(
  //       color: Colors.green,
  //     ),
  //   ),
  //   focusedBorder: const OutlineInputBorder(
  //     borderRadius: BorderRadius.all(Radius.circular(40.0)),
  //     borderSide: BorderSide(color: Colors.blue),
  //   ),
  //   errorBorder: const OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.red, width: 1),
  //     borderRadius: BorderRadius.all(Radius.circular(40)),
  //   ),
  //   focusedErrorBorder: const OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.red, width: 1),
  //     borderRadius: BorderRadius.all(Radius.circular(40)),
  //   ),
  //   isDense: true,
  // ),
  //TextStyle theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF232323),
      fontSize: 26,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
    ),
  ),
);
