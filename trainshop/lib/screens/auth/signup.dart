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
import 'package:trainshop/screens/auth/login.dart';
import 'package:trainshop/view/common/input_field.dart';
import 'package:trainshop/view/dropdown/select_dropdown.dart';

class SignUp extends StatefulWidget {
  final Controller controller;
  const SignUp({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _shopname = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowPass = true;
  bool isNewUserCreating = false;
  bool isSignUpSuccess = false;
  Future<int>? _statusCode;
  // String? countryid;
  // String? deliverystationid;

  // Future<int> send() async {
  //   const String apiUrl = "http://localhost:5000/create";
  //   // ইউ আর এল এ কোন স্পেইস রাখা যাবে না, নতুবা ইরর আসবে।

  //   final response = await http.post(Uri.parse(apiUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({
  //         "username": _username.text,
  //         "email": _email.text,
  //         "password": _pass.text
  //       }));

  //   if (response.statusCode == 200) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('userinfo', response.body);
  //     // widget.controller.appStates.isLogedIn.value = true;
  //     print(response.body);
  //     setState(() {
  //       isSignUpSuccess = true;
  //     });
  //     return response.statusCode;
  //   } else {
  //     return response.statusCode;
  //   }
  // }

  //Send Registration Data
  Future<int> send() async {
    // widget.controller.appStates.email.value = _email.text;
    // widget.controller.appStates.username.value = _username.text;
    // widget.controller.appStates.shopname.value = _shopname.text;
    // widget.controller.appStates.password.value = _pass.text;
    // widget.controller.appStates.countryid.value = countryid ?? '';
    // var response = await trycatch(
    //   action: 'signUp',
    //   controller: widget.controller,
    // );

    print({
      "username": _username.text,
      "shopname": _shopname.text,
      "email": _email.text,
      "password": _pass.text,
      "countryid": widget.controller.appStates.countryid.value,
      "deliverystationid": widget.controller.appStates.deliveryStationId.value,
    });

    dynamic response = await postdata(
      x: 'createshop',
      body: {
        "username": _username.text,
        "shopname": _shopname.text,
        "email": _email.text,
        "password": _pass.text,
        "countryid": widget.controller.appStates.countryid.value,
        "deliverystationid":
            widget.controller.appStates.deliveryStationId.value,
      },
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userinfo', response.body);
      // widget.controller.appStates.isLogedIn.value = true;
      print(response.body);
      setState(() {
        isSignUpSuccess = true;
      });
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> alreadyHaveAccount = <Widget>[
      const Text(
        "Already have an account?",
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
              builder: (_) => Login(
                controller: widget.controller,
              ),
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
            "Sign In",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];

    //SignUp Children
    List<Widget> children = <Widget>[
      //  const SizedBox(
      //         width: double.infinity,
      //         height: 100,
      //         child: Center(
      //           child: Text(
      //             "Trainshop",
      //             style: TextStyle(
      //                 fontSize: 40,
      //                 fontWeight: FontWeight.w900,
      //                 color: Colors.green),
      //           ),
      //         ),
      //       ),

      //User SignUp Area
      Container(
        constraints: BoxConstraints(
          minWidth: Responsive.value(350.0, 350.0, 350.0, context),
          maxWidth: Responsive.value(double.infinity, 500.0, 650.0, context),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.value(
            20.0,
            50.0,
            50.0,
            context,
          ),
          vertical: Responsive.value(
            20.0,
            50.0,
            50.0,
            context,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.value(
            20.0,
            50.0,
            50.0,
            context,
          ),
          vertical: Responsive.value(
            20.0,
            50.0,
            50.0,
            context,
          ),
        ),
        // width: Responsive.value(
        //   // double.infinity,
        //   // Responsive.width(context) * 0.85,
        //   // Responsive.width(context) * 0.4,
        //   //context,
        // ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create New Shop",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Email Input Field
              InputField(
                controller: _username,
                labelText: "User Name",
                prefixIcon: const Icon(Icons.person),
                validator: (String? val) {
                  if (!val!.isValidName) {
                    return 'Enter Valid User Name';
                  } else if (val.isEmpty) {
                    return "Username must not be empty";
                  }
                  // else if (val.length < 8) {
                  //   return "Password must be atleast 8 characters long";
                  // }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              InputField(
                controller: _shopname,
                labelText: "Shop Name",
                prefixIcon: const Icon(Icons.store),
                validator: (String? val) {
                  if (!val!.isValidName) {
                    return 'Enter Valid Shop Name';
                  } else if (val.isEmpty) {
                    return "Shopname must not be empty";
                  }
                  // else if (val.length < 8) {
                  //   return "Password must be atleast 8 characters long";
                  // }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
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
                height: 16,
              ),
              //Confirm Password Input field
              InputField(
                controller: _confirmpass,
                labelText: "Re-enter Password",
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
                    return "Re-Enter Password";
                  } else if (val.length < 8) {
                    return "Password must be atleast 8 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              //Country Selector
              SelectDropDown(
                constraints: const BoxConstraints(
                  maxHeight: 55,
                ),
                bordercolor: Colors.green,
                borderradius: 25.0,
                itemname: 'countryname',
                url: 'getallcountry',
                label: 'Select Country',
                controller: widget.controller,
                onChanged: (value, id) {
                  //countryid = id;
                  widget.controller.appStates.countryid.value = id;
                  print(
                      "Selected country id : ${widget.controller.appStates.countryid.value}");
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ValueListenableBuilder<String>(
                  valueListenable: widget.controller.appStates.countryid,
                  builder: (context, value, child) {
                    widget.controller.appStates.deliveryStationId.value = "";
                    return SelectDropDown(
                      constraints: const BoxConstraints(
                        maxHeight: 55,
                      ),
                      bordercolor: Colors.green,
                      borderradius: 25.0,
                      itemname: 'stationname',
                      url:
                          'getStationByCountry/${widget.controller.appStates.countryid.value}',
                      label: 'Delivery Station',
                      controller: widget.controller,
                      onChanged: (value, id) {
                        widget.controller.appStates.deliveryStationId.value =
                            id;
                        print(
                            "Selected country id : ${widget.controller.appStates.countryid.value} & Station Id is : ${widget.controller.appStates.deliveryStationId.value}");
                      },
                    );
                  }),
              const SizedBox(
                height: 16,
              ),
              //SignUp button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isNewUserCreating = true;
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
                    shape: const StadiumBorder()),
                child: const Text("Sign Up"),
              ),
              const SizedBox(
                height: 30,
              ),

              //Sign Up Button
              Responsive.width(context) > 350
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: alreadyHaveAccount,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: alreadyHaveAccount,
                    ),

              //SignUp Status Display
              isNewUserCreating
                  ? FutureBuilder(
                      //future এ প্যারামিটার হিসেবে ফাংশন পাস করলে এটি বল্ড মেথড এর সাথে বার বার কল হবে।
                      //তাই, বার বার কল করা বন্ধ করতে এটিকে সেটস্টেইট বা ইনিট ফাংশনের ভেতর ডিফাইন করতে হবে।
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
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'New User Created Successfully!!',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ));
                          } else if (snapshot.data == 209) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Fields Must not be empty',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ));
                          } else if (snapshot.data == 202) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Email Already in use, try another email!!',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ));
                          } else {
                            return Center(
                              //child: Text('${snapshot.data}'));
                              child: Text("status code is : ${snapshot.data} "),
                            );
                          } // snapshot.data  :- get your object which is pass from your downloadData() function
                        }
                      },
                    )
                  : const SizedBox(
                      width: 1,
                    ),
            ],
          ),
        ),
      ),
    ];

    return isSignUpSuccess
        ? const MyApp()
        : Scaffold(
            body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          ));
  }
}
