import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/main.dart';
import 'package:trainshop/controller/localstorage.dart';

class SessionExpired extends StatelessWidget {
  final Controller controller;
  const SessionExpired({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Card(
          child: Container(
            //margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(20),
            width: 400,
            height: 200,
            // decoration: BoxDecoration(
            //   //color: Colors.yellow,
            //   //border: Border.all(color: Colors.black),
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(20),
            //   ),
            // ),
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Your Session Expired! Please Login to Continue.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 200,
                  color: Colors.yellow,
                  onPressed: () {
                    LocalStorage.logoutHandler(controller);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
