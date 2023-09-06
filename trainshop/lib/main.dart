import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/localstorage.dart';
import 'package:trainshop/controller/theme/dark.dart';
import 'package:trainshop/controller/theme/light.dart';
import 'package:trainshop/screens/auth/login.dart';
import 'package:trainshop/screens/landing.dart';
import 'package:trainshop/screens/splash.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //A unique Global State Container is controller
  Controller controller = Controller();
  Future<int>? _statusCode;

  @override
  void initState() {
    _statusCode = LocalStorage.getUserInfo(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.appStates.isDarkTheme,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'trainshop app',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: FutureBuilder<int>(
            future: _statusCode,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Splash();
              } else {
                if (snapshot.data == 200) {
                  return Landing(controller: controller);
                } else {
                  return Login(controller: controller);
                  // return Status(
                  //   controller: controller,
                  // );
                }
              }
            },
          ),
        );
      },
    );
  }
}










// Theme implementation
/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/theme/dark.dart';
import 'package:trainshop/controller/theme/light.dart';
import 'package:trainshop/screens/home.dart';
import 'package:trainshop/screens/login.dart';
import 'package:trainshop/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //A unique Global State Container is controller
  Controller controller = Controller();

  @override
  void initState() {
    //Read Theme information from local database
    getThemeInfo();
    super.initState();
  }

  getThemeInfo() async {
    // helping article : https://medium.flutterdevs.com/using-sharedpreferences-in-flutter-251755f07127
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool themeValue = prefs.getBool('themeValue') ?? false;
    controller.appStates.isDarkTheme.value = themeValue;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.appStates.isDarkTheme,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'trainshop app',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: Splash(
            controller: controller,
          ),
        );
      },
    );
  }
}

*/
