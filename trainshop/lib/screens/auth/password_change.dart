import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/controller/validator.dart';
import 'package:trainshop/main.dart';
import 'package:http/http.dart' as http;
import 'package:trainshop/model/localstorage/userinfo.dart';
import 'package:trainshop/view/common/input_field.dart';

class PasswordScreen extends StatefulWidget {
  //final String userEmail;
  final Controller controller;
  const PasswordScreen({
    Key? key,
    //required this.userEmail,
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  bool isPassUpdating = false;
  bool isPasswordUpdated = false;
  Future<int>? _statusCode;

  Future<int> send() async {
    // const String url = "http://localhost:5000/updatepass";

    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(
    //     {
    //       "email": widget.userEmail,
    //       "password": _pass.text,
    //     },
    //   ),
    // );
    widget.controller.appStates.password.value = _pass.text;
    final response = await trycatch(
      action: 'changePass',
      controller: widget.controller,
    );

    //UserInfo userInfo = UserInfo.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userinfo', response.body);
      // widget.controller.appStates.isLogedIn.value = true;
      UserInfo userinfo = UserInfo.fromJson(jsonDecode(response.body));
      print("The JWT is : ${userinfo.jwt}");
      print("Email is : ${userinfo.email}");
      setState(
        () {
          isPasswordUpdated = true;
        },
      );
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> donotHaveAccount = <Widget>[
      const Text(
        "Go back to home",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
      OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MyApp(),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          //minimumSize: const Size.fromHeight(50),
          shape: const StadiumBorder(),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Home",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];
    //PasswordScreen Children
    List<Widget> children = <Widget>[
      //Display Feature Slider Conditionaly depending on screen height
      const Expanded(
              child: Center(
                child: Text(
                  "trainshop",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      //User PasswordScreen Area
      Container(
        constraints: BoxConstraints(
          minWidth: Responsive.value(350.0, 350.0, 350.0, context),
          maxWidth: Responsive.value(double.infinity, 450.0, 500.0, context),
        ),
        width: Responsive.value(
          double.infinity,
          Responsive.width(context) * 0.4,
          Responsive.width(context) * 0.4,
          context,
        ),
        height: Responsive.value(350, Responsive.height(context),
            Responsive.height(context), context),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minWidth: Responsive.value(240.0, 300.0, 400.0, context),
                maxWidth: Responsive.value(450.0, 450.0, 450.0, context),
              ),
              width: Responsive.value(
                Responsive.width(context) * double.infinity,
                Responsive.width(context) * 0.36,
                Responsive.width(context) * 0.4,
                context,
              ),
              //height: double.infinity,
              //height: Responsive.value(350, 400, 400, context),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Type new password",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //Email Input Field
                      InputField(
                        controller: _pass,
                        labelText: "Password",
                        obscureText: isShowPass,
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: isShowPass
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                isShowPass = !isShowPass;
                              });
                            },
                          ),
                        ),
                        validator: (String? val) {
                          if (!val!.isValidPassword) {
                            return 'Enter Valid Password';
                          } else if (val.isEmpty) {
                            return "Please Enter Password";
                          } else if (val.length < 8) {
                            return "Password must be atleast 8 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //Password Input field
                      InputField(
                        controller: _confirmPass,
                        labelText: "Repeate Password",
                        obscureText: isShowPass,
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: isShowPass
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                isShowPass = !isShowPass;
                              });
                            },
                          ),
                        ),
                        validator: (String? val) {
                          if (!val!.isValidPassword) {
                            return 'Enter Valid Password';
                          } else if (val.isEmpty) {
                            return "Please Enter Password";
                          } else if (val.length < 8) {
                            return "Password must be atleast 8 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //PasswordScreen button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isPassUpdating = true;
                              _statusCode = send();
                              // }
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(30.0),
                          // ),
                          minimumSize: const Size.fromHeight(50),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Update Password"),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      //Sign Up Button
                      Responsive.width(context) > 300
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: donotHaveAccount,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: donotHaveAccount,
                            ),

                      //PasswordScreen Status Display
                      isPassUpdating
                          ? FutureBuilder(
                              future: _statusCode,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                        )),
                                  );
                                } else {
                                  if (snapshot.data == 200) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MyApp(),
                                      ),
                                    );
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Password Update Successful.',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ); //go back to MyApp if PasswordScreen success
                                  } else if (snapshot.data == 201) {
                                    return const Center(
                                        child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'User not found',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ));
                                  } else {
                                    return Center(
                                      //child: Text('${snapshot.data}'));
                                      // child: Text("${snapshot.data} "),
                                      child: Text(
                                          'PasswordScreen Failed, The jwt is : "${snapshot.data}"'),
                                    );
                                  } // snapshot.data  :- get your object which is pass from your downloadData() function
                                }
                              },
                            )
                          : const SizedBox(
                              width: 10,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ];

    return isPasswordUpdated
        ? const MyApp()
        : Scaffold(
            body: Responsive.isMobile(context)
                ? SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 450,
                      ),
                      height: Responsive.height(context) < 450
                          ? 450
                          : Responsive.height(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  )
                : Row(
                    children: children,
                  ),
          );
  }
}
