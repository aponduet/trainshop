import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/localstorage.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/model/localstorage/userinfo.dart';

class EditProfile extends StatefulWidget {
  final Controller controller;
  const EditProfile({Key? key, required this.controller}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  String category = '';
  String? imageName;
  String? imagePath;
  late File file;
  bool isImagSelected = false;
  Map<String, dynamic> userInfo = {};
  Future<dynamic>? _userInfo;
  int? _formStatus;
  bool isFormSubmitting = false;
  // Map<String, dynamic> productInfo = {
  //   //This Data will come from Database
  //   'product_id': 4,
  //   'product_name': 'Mutton Sandwich',
  //   'product_description':
  //       'Bread and mutton sandwith with tomato souse, chili flavor and free water.',
  //   'category': 'Breakfast',
  //   'price': '150 tk',
  //   'quantity': 5,
  //   'stock': 10,
  //   'shop_id': 14,
  //   'shop_name': 'Hamim Hotel & Restaurant',
  // };

  List<String> productCategory = <String>[
    'Snaks',
    'Drinks',
    'Fruits',
    'Breakfast'
  ];
  // Map<String, dynamic> formData = {
  //   'username': 'md sohel rana',
  //   'email': 'sohelrana.yy@IloveYOu',
  // };

  // Future<int> send() async {
  //   int? status;
  //   String url = "http://localhost:5000/updateProfileInfo";
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       {
  //         "jwt": widget.controller.appStates.jwt.value,
  //         'username': 'md sohel rana',
  //         'email': 'sohelrana.yy@IloveYOu',
  //       },
  //     ),
  //   );

  //   /*
  //   .------------------------------.
  //   |     Status Code Guidlines    |
  //   '------------------------------'
  //   Authentication Releted Status Codes
  //   200 : Data Found Successfully
  //   202 : Data Not Found
  //   303 : token Expired or Invalid
  //   404 : User not found. (Do not use status 300 to 399 to avoid re-direct issues)
  //   505 : Request body is not complete.
  //   500 : Data Search Error while searching in Database
  //   */

  //   if (response.statusCode == 200) {
  //     return response.statusCode;
  //   } else {
  //     if (response.statusCode == 204 || response.statusCode == 404) {
  //       //logout if invalid / Expired token or User not found
  //       LocalStorage.logoutHandler(widget.controller);
  //       status = response.statusCode;
  //     } else {
  //       status = response.statusCode;
  //     }
  //   }
  //   return status;
  // }

  //Upload form
  Future<int> updateProfileInfo() async {
    int status;
    Map<String, String> requestBody = <String, String>{
      "jwt": widget.controller.appStates.jwt.value,
      'email': widget.controller.appStates.email.value,
      'userid': widget.controller.appStates.userid.value,
      //information to be Updated
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'address': addressController.text,
      'aboutme': aboutmeController.text,
      'mobile': mobileController.text,
      'dateofbirth': dateOfBirthController.text,
      'facebook': facebookController.text,
      'twitter': twitterController.text,
      'whatsapp': whatsappController.text,
    };
    var response = await trycatch(
      action: 'updateProfileInfo',
      controller: widget.controller,
      anyvalue: requestBody,
    );

    // int? status;
    // String url = "http://localhost:5000/updateProfileInfo";
    // Map<String, String> requestBody = <String, String>{
    //   "jwt": widget.controller.appStates.jwt.value,
    //   'email': widget.controller.appStates.email.value,
    //   'userid': widget.controller.appStates.userid.value,
    //   //information to be Updated
    //   'firstname' : facebookController.text,
    // };
    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse(url),
    // );
    // if (isImagSelected) {
    //   request.files.add(await http.MultipartFile.fromPath('picture', imagePath!));
    // }
    // request.fields.addAll(requestBody);
    // var response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);

      print('Update Status is : $res');

      //widget.controller.appStates.imageurl.value = res['imageurl'];
      // widget.controller.appStates.firstname.value = res['firstname'] ?? '';
      // widget.controller.appStates.lastname.value = res['lastname'] ?? '';
      // widget.controller.appStates.address.value = res['address'] ?? '';
      // widget.controller.appStates.dateofbirth.value = res['dateofbirth'] ?? '';
      // widget.controller.appStates.mobile.value = res['mobile'] ?? '';
      // widget.controller.appStates.facebook.value = res['facebook'] ?? '';
      // widget.controller.appStates.twitter.value = res['twitter'] ?? '';
      // widget.controller.appStates.whatsapp.value = res['whatsapp'] ?? '';
      status = response.statusCode;
    } else {
      if (response.statusCode == 404) {
        //logout if invalid / Expired token or User not found
        LocalStorage.logoutHandler(widget.controller);
        status = response.statusCode;
      } else {
        status = response.statusCode;
      }
    }
    return status;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    dateOfBirthController.dispose();
    facebookController.dispose();
    whatsappController.dispose();
    // twitterController.dispose();
    super.dispose();
  }

  Future<dynamic> fetch() async {
    var response = await trycatch(
      action: 'getUserInfo',
      controller: widget.controller,
    );

    if (response.statusCode == 200) {
      userInfo = json.decode(response.body);
      print(userInfo);
      //Place user information to input field.
      firstNameController.text = userInfo['firstname'] ?? "";
      lastNameController.text = userInfo['lastname'] ?? "";
      addressController.text = userInfo['address'] ?? "";
      aboutmeController.text = userInfo['aboutme'] ?? "";
      dateOfBirthController.text = userInfo['dateofbirth'] ?? "";
      mobileController.text = userInfo['mobile'] ?? "";
      facebookController.text = userInfo['facebook'] ?? "";
      twitterController.text = userInfo['twitter'] ?? "";
      whatsappController.text = userInfo['whatsapp'] ?? "";
    } else {}
    return response;
  }

  @override
  void initState() {
    //fetch user information
    _userInfo = fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: FutureBuilder(
          future: _userInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 40),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal:
                              Responsive.value(10.0, 30.0, 60.0, context),
                        ),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.green.withOpacity(0.2),
                        //   ),
                        //   borderRadius: const BorderRadius.all(
                        //     Radius.circular(10),
                        //   ),
                        // ),
                        width: 700,
                        //height: 500,
                        //color: Colors.yellow,
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //Main column
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: firstNameController,
                                      maxLength: 100,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        //hoverColor: Colors.white,
                                        counter: SizedBox(),
                                        //isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 10,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        filled: true,
                                        label: Text('First Name'),
                                        //fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: lastNameController,
                                      maxLength: 100,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        //hoverColor: Colors.white,
                                        counter: SizedBox(),
                                        //isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 10,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        filled: true,
                                        label: Text('Last Name'),
                                        //fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /* -------------------------------- About Me -------------------------------- */
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: aboutmeController,
                                maxLength: 500,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('About me'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: addressController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Address'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: mobileController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  // hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Mobile No.'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onTap: () async {
                                  final DateTime? newDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1992, 7, 10),
                                    firstDate: DateTime(1950, 1),
                                    lastDate: DateTime.now(),
                                    helpText: 'Select a date',
                                  );
                                  String getFormatedDate(date) {
                                    var inputFormat =
                                        DateFormat('yyyy-MM-dd HH:mm');
                                    var inputDate =
                                        inputFormat.parse(date.toString());
                                    var outputFormat =
                                        DateFormat('dd/MM/yyyy ');
                                    // var outputFormat = DateFormat('hh:mm a dd/MM/yyyy ');
                                    return outputFormat
                                        .format(inputDate)
                                        .toString();
                                  }

                                  print(getFormatedDate(newDate));
                                  setState(() {
                                    dateOfBirthController.text =
                                        getFormatedDate(newDate);
                                  });
                                },
                                controller: dateOfBirthController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Date of Birth'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: facebookController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Facebook Link'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: twitterController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Twitter Link'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: whatsappController,
                                maxLength: 100,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  //hoverColor: Colors.white,
                                  counter: SizedBox(),
                                  //isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  label: Text('Whatsapp'),
                                  //fillColor: Colors.white,
                                ),
                              ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              //Dropdown Menu
                              // Container(
                              //   width: double.infinity,
                              //   // decoration: const BoxDecoration(
                              //   //   color: Colors.white,
                              //   // ),
                              //   child: DropdownButtonFormField<String>(
                              //     decoration: const InputDecoration(
                              //       filled: true,
                              //       constraints: BoxConstraints(
                              //         maxHeight: 50,
                              //       ),
                              //       contentPadding: EdgeInsets.symmetric(
                              //         horizontal: 10,
                              //         vertical: 10,
                              //       ),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors.blue,
                              //         ),
                              //       ),
                              //     ),
                              //     iconEnabledColor: Colors.grey,
                              //     //dropdownColor: Colors.blueAccent,
                              //     elevation: 0,
                              //     value: category,
                              //     isDense: true,
                              //     isExpanded: true,
                              //     onChanged: (String? value) {
                              //       setState(() {
                              //         category = value!;
                              //       });
                              //     },
                              //     // style: const TextStyle(
                              //     //   //color: Colors.black,
                              //     //   fontSize: 16,
                              //     // ),
                              //     items: productCategory
                              //         .map<DropdownMenuItem<String>>(
                              //             (String value) {
                              //       return DropdownMenuItem<String>(
                              //         value: value,
                              //         child: Text(value),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),

                              // const Divider(
                              //   color: Colors.grey,
                              //   height: 30,
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                              // ! ||--------------------------------------------------------------------------------||
                              // ! ||                                 Form Send Button                               ||
                              // ! ||--------------------------------------------------------------------------------||
                              isFormSubmitting
                                  ? FutureBuilder<int>(
                                      future: updateProfileInfo(),
                                      initialData: 600,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else if (snapshot.data == 200) {
                                          return SizedBox(
                                            width: double.infinity,
                                            //height: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text(
                                                    'Profile Updated Successfully',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      "Go to Profile",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return SizedBox(
                                            width: double.infinity,
                                            //height: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text(
                                                    'Profile Update Failed!',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                                    child: Text(
                                                      "Go to Profile",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      })
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              isFormSubmitting = true;
                                              setState(() {});
                                            },
                                            color: Colors.yellow,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 10),
                                              child: Text("Save"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              );
            }
          }),
    );
  }
}
