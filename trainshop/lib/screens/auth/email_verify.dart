import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/controller/validator.dart';
import 'package:trainshop/main.dart';
import 'package:trainshop/model/localstorage/userinfo.dart';
import 'package:trainshop/screens/auth/login.dart';
import 'package:trainshop/screens/auth/otp_verify.dart';
import 'package:http/http.dart' as http;
import 'package:trainshop/view/common/input_field.dart';

class EmailVerify extends StatefulWidget {
  final Controller controller;
  const EmailVerify({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValidEmail = false;
  bool isCheckRunning = false;
  Future<int>? _statusCode;

  Future<int> send() async {
    const String url = "http://localhost:5000/account";
    // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।
    widget.controller.appStates.verifyEmail.value = _email.text;
    final response = await trycatch(
      action: 'verifyEmail',
      controller: widget.controller,
    );

    //UserInfo userInfo = UserInfo.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      setState(() {
        isValidEmail = true;
      });
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  // Future<int> send() async {
  //   const String url = "http://localhost:5000/account";
  //   // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       {"email": _email.text},
  //     ),
  //   );

  //   //UserInfo userInfo = UserInfo.fromJson(jsonDecode(response.body));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isValidEmail = true;
  //     });
  //     return response.statusCode;
  //   } else {
  //     return response.statusCode;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> donotHaveAccount = <Widget>[
      const Text(
        "Go back Login Page",
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
            "Login",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];
    //EmailVerify Children
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
      //User EmailVerify Area
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
                        "We will verify your account and send you OTP , Please enter your Email address",
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

                      //EmailVerify button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isCheckRunning = true;
                              _statusCode = send();
                            });
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => OtpScreen(
                          //       controller: widget.controller,
                          //     ),
                          //   ),
                          // );
                        },
                        style: OutlinedButton.styleFrom(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(30.0),
                            // ),
                            minimumSize: const Size.fromHeight(50),
                            shape: const StadiumBorder()),
                        child: const Text("Send OTP"),
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

                      //EmailVerify Status Display
                      isCheckRunning
                          ? FutureBuilder(
                              future: _statusCode,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    ),
                                  );
                                } else {
                                  if (snapshot.data == 200) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'OTP has been sent to your Email.',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data == 201) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'User not found!',
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
                                          'Something goes wrong! Try again later.',
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

    return isValidEmail
        ? OtpScreen(
            userEmail: _email.text,
            controller: widget.controller,
          )
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
