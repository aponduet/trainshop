import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/controller/validator.dart';
import 'package:trainshop/main.dart';
import 'package:http/http.dart' as http;
import 'package:trainshop/screens/auth/email_verify.dart';
import 'package:trainshop/screens/auth/signup.dart';
import 'package:trainshop/view/common/input_field.dart';

class Login extends StatefulWidget {
  final Controller controller;
  const Login({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  bool isLogin = false;
  bool isLogSuccess = false;
  Future<int>? _statusCode;

  Future<int> send() async {
    widget.controller.appStates.email.value = _email.text;
    widget.controller.appStates.password.value = _pass.text;

    //var res = await trycatch(action: 'login', controller: widget.controller);
    dynamic res = await postdata(x: 'login', body: {
      "email": widget.controller.appStates.email.value,
      "password": widget.controller.appStates.password.value,
    });

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userinfo', res.body);
      print(res.body);
      setState(() {
        isLogSuccess = true;
      });
      return res.statusCode;
    } else {
      return res.statusCode;
    }
  }

  // Future<int> send() async {
  //   const String url = "http://localhost:5000/login";
  //   // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       {
  //         "email": _email.text,
  //         "password": _pass.text,
  //       },
  //     ),
  //   );
  //   //UserInfo userInfo = UserInfo.fromJson(jsonDecode(response.body));
  //   if (response.statusCode == 200) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('userinfo', response.body);
  //     print(response.body);
  //     setState(() {
  //       isLogSuccess = true;
  //     });
  //     return response.statusCode;
  //   } else {
  //     return response.statusCode;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //Dummy Distance check

    List<Widget> donotHaveAccount = <Widget>[
      const Text(
        "Do not have an account?",
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
              builder: (_) => SignUp(controller: widget.controller),
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
            "Sign Up",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];
    //Login Children
    List<Widget> children = <Widget>[
      //Display Feature Slider Conditionaly depending on screen height
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Responsive.value(null, Colors.green, Colors.green, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TRAINSHOP",
                style: TextStyle(
                    fontSize: Responsive.value(45.0, 45.0, 60.0, context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Text(
                "Delivery Foods & Manage Shop Easy",
                style: TextStyle(
                    fontSize: Responsive.value(24.0, 32.0, 40.0, context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      //User Login Area
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
        height: Responsive.value(350.0, Responsive.height(context),
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
                      //Email Input Field
                      InputField(
                        controller: _email,
                        labelText: "E-mail address",
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (val) {
                          if (!val!.isValidEmail) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //Password Input field
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
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerify(
                                  controller: widget.controller,
                                ),
                              ),
                            );
                          }),
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //login button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLogin = true;
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
                        child: const Text("Login"),
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

                      //Login Status Display
                      isLogin
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MyApp(),
                                      ),
                                    );
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Login Successful!!',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ); //go back to MyApp if login success
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
                                      ),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        //child: Text('${snapshot.data}'));
                                        // child: Text("${snapshot.data} "),
                                        child: Text(
                                          "Login Failed",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
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

    return isLogSuccess
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
