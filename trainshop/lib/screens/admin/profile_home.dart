import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/main.dart';
import 'package:trainshop/screens/admin/payment_home.dart';
import 'package:trainshop/screens/admin/report_home.dart';
import 'package:trainshop/screens/admin/orders_home.dart';
import 'package:trainshop/screens/admin/products_home.dart';
import 'package:trainshop/view/admin/profile/chats_board.dart';
import 'package:trainshop/view/admin/profile/edit_profile.dart';
import 'package:trainshop/view/admin/profile/profile.dart';

import 'package:trainshop/view/admin/shop/stockUpdate.dart';
import 'package:trainshop/controller/localstorage.dart';

class ProfileHome extends StatefulWidget {
  final Controller controller;
  const ProfileHome({Key? key, required this.controller}) : super(key: key);
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  String? imageName;
  late File file;
  bool isImagSelected = false;
  final drawerkey = GlobalKey<ScaffoldState>();

/* ------------------ Upload Single Profile Image so Server ----------------- */

  changeBackgroundImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      //use withData: true, If null is returned in desktop ,
      //follow https://github.com/miguelpruivo/flutter_file_picker/issues/817
      type: FileType.image,
      //allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      //imagePath = result.files.single.path;
      Uint8List? imagebytes = result.files.single.bytes;
      String filename = result.files.single.name;
      Map<String, dynamic> requestBody = <String, dynamic>{
        'userid': widget.controller.appStates.userid.value,
        'imagebytes': imagebytes,
        'filename': filename,
      };
      //print(requestBody);
      var res = await trycatch(
        action: 'uploadBackgroundImage',
        controller: widget.controller,
        anyvalue: requestBody,
      );

      if (res.statusCode == 200) {
        setState(() {});
        //isImageSelected = false;
      }
    } else {
      // User canceled the picker
      print("No image selected");
    }
  }

  changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      //use withData: true, If null is returned in desktop ,
      //follow https://github.com/miguelpruivo/flutter_file_picker/issues/817
      type: FileType.image,
      //allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      Uint8List? imageBytes = result.files.single.bytes;
      //imagePath = result.files.single.path;
      var filename = result.files.single.name;
      print('filename is : $filename');

      Map<String, dynamic> requestBody = {
        'userid': widget.controller.appStates.userid.value,
        //image path
        //'imagepath': imagePath,
        'imagebytes': imageBytes,
        'filename': filename,
      };
      var res = await trycatch(
        action: 'uploadSingleImage',
        controller: widget.controller,
        anyvalue: requestBody,
      );
      if (res.statusCode == 200) {
        setState(() {});
        //isImageSelected = false;
      }
    } else {
      // User canceled the picker
      print("No image selected");
    }
  }

  List<Map<String, dynamic>> info = [
    {
      'title': 'New Orders',
      'icon': Icons.list,
      'quantity': 120,
      'color': Colors.green,
    },
    {
      'title': 'Processing',
      'icon': Icons.carpenter,
      'quantity': 300,
      'color': Colors.orange,
    },
    {
      'title': 'Delivery',
      'icon': Icons.delivery_dining,
      'quantity': 80,
      'color': Colors.red,
    },
    {
      'title': 'New Messages',
      'icon': Icons.message,
      'quantity': 120,
      'color': Colors.yellow,
    },
    {
      'title': 'Notifications',
      'icon': Icons.notification_add,
      'quantity': 300,
      'color': Colors.blue,
    },
    {
      'title': 'Total Payment',
      'icon': Icons.payment,
      'quantity': 80,
      'color': Colors.pink,
    },
  ];

  @override
  void initState() {
    //_tabController = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerkey,
      endDrawer: Drawer(
        width: 300,
        child: Column(
          children: [
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(controller: widget.controller),
                    ),
                  );
                },
                //hoverColor: Colors.green,
                leading: const Icon(Icons.panorama),
                title: const Text('Edit Profile'),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () {
                changeImage();
              },
              child: const ListTile(
                // onTap: () {
                //   Navigator.pop(context); //close popup menu
                //   changeImage();
                // },
                leading: Icon(Icons.settings),
                title: Text('Change Profile Image'),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () {
                //Navigator.pop(context); //close popup menu
                changeBackgroundImage();
              },
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Change Background Image'),
              ),
            ),
            widget.controller.appStates.isDarkTheme.value
                ? PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: () {
                      LocalStorage.themeHandler(widget.controller);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.light_mode),
                      title: Text('Light Mode'),
                    ),
                  )
                : PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: () {
                      LocalStorage.themeHandler(widget.controller);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.dark_mode),
                      title: Text('Dark Mode'),
                    ),
                  ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersHome(),
                    ),
                  );
                },
                leading: const Icon(Icons.list),
                title: const Text('Orders'),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsHome(
                        controller: widget.controller,
                        category: 'Snaks',
                      ),
                    ),
                  );
                },
                leading: const Icon(Icons.production_quantity_limits_sharp),
                title: const Text('Products'),
              ),
            ),
            // PopupMenuItem(
            //   padding: EdgeInsets.zero,
            //   onTap: () {},
            //   child: ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) =>
            //                   Trainadmin(controller: widget.controller)));
            //     },
            //     leading: const Icon(Icons.train_outlined),
            //     title: const Text('Train Admin Panel'),
            //   ),
            // ),
            // PopupMenuItem(
            //   padding: EdgeInsets.zero,
            //   onTap: () {},
            //   child: ListTile(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => AdminShopHome(
            //             controller: widget.controller,
            //           ),
            //         ),
            //       );
            //     },
            //     leading: const Icon(Icons.report),
            //     title: const Text('Shop Admin Panel'),
            //   ),
            // ),
            // PopupMenuItem(
            //   padding: EdgeInsets.zero,
            //   onTap: () {},
            //   child: ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => AdvertiseHome(
            //                     controller: widget.controller,
            //                   )));
            //     },
            //     leading: const Icon(Icons.report),
            //     title: const Text('Advertise Home'),
            //   ),
            // ),
            // PopupMenuItem(
            //   padding: EdgeInsets.zero,
            //   onTap: () {},
            //   child: ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           context, MaterialPageRoute(builder: (_) => AboutUs()));
            //     },
            //     leading: const Icon(Icons.report),
            //     title: const Text('About Us'),
            //   ),
            // ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                hoverColor: Colors.red,
                onTap: () {
                  LocalStorage.logoutHandler(widget.controller);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                      (Route<dynamic> route) => false
                      //Here (Route<dynamic> route) => false will make sure that all routes before the pushed route be removed.
                      //Helping Article : https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
                      );
                  //print(widget.controller.appStates.isLogedIn.value);
                },
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: const Text("MY PROFILE"),
        actions: [
// ! ||--------------------------------------------------------------------------------||
// ! ||                                Notification Menu                               ||
// ! ||--------------------------------------------------------------------------------||
          SizedBox(
            //color: Colors.yellow,
            width: 60,
            height: 60,
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: PopupMenuButton(
                      constraints: const BoxConstraints(
                        minWidth: 300,
                        maxHeight: 400,
                      ),
                      tooltip: "Notifications",
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 30,
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/images/rocket.png',
                              ),
                            ),
                            title: Text("Md. Sohel Rana"),
                            subtitle: Text(
                                "Please Send my product as soon as possible."),
                          ),
                        ),
                        const PopupMenuItem(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/images/profile.jpeg',
                              ),
                            ),
                            title: Text("Md. Sohel Rana"),
                            subtitle: Text(
                                "Please Send my product as soon as possible."),
                          ),
                        ),
                        const PopupMenuItem(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/images/rocket.png',
                              ),
                            ),
                            title: Text("Md. Sohel Rana"),
                            subtitle: Text(
                                "Please Send my product as soon as possible."),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(
                        minHeight: 20,
                        minWidth: 20,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              if (drawerkey.currentState!.isEndDrawerOpen) {
                drawerkey.currentState!.closeEndDrawer();
              } else {
                drawerkey.currentState!.openEndDrawer();
              }
            },
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            Container(
              width: Responsive.width(context) < 750 ? 300 : 400,
              height: double.infinity,
              child: const Card(child: Profile()),
            ),
          Expanded(
            child: Card(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 200,
                ),
                //physics: const NeverScrollableScrollPhysics(),
                // crossAxisCount: Responsive.width(context) > 750
                //     ? 3
                //     : Responsive.width(context) < 400
                //         ? 1
                //         : 2,
                // // crossAxisCount: Responsive.value(1, 2, 3, context),
                // childAspectRatio: 3 / 2,
                // mainAxisSpacing: 5,
                // crossAxisSpacing: 5,

                itemCount: info.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: info[index]['color'],
                      // width: 250,
                      // height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info[index]['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  info[index]['icon'],
                                  color: Colors.white,
                                  size:
                                      Responsive.width(context) < 200 ? 40 : 60,
                                ),
                                Text(
                                  info[index]['quantity'].toString(),
                                  style: TextStyle(
                                    fontSize: Responsive.width(context) < 200
                                        ? 40
                                        : 60,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                // children: [
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.blue,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "New Orders",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.shopping_cart,
                //                   color: Colors.white,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                 ),
                //                 Text(
                //                   "122",
                //                   style: TextStyle(
                //                     fontSize: Responsive.width(context) < 200
                //                         ? 40
                //                         : 60,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.blue,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "New Orders",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.shopping_cart,
                //                   color: Colors.white,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                 ),
                //                 Text(
                //                   "122",
                //                   style: TextStyle(
                //                     fontSize: Responsive.width(context) < 200
                //                         ? 40
                //                         : 60,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.blue,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "New Orders",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.shopping_cart,
                //                   color: Colors.white,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                 ),
                //                 Text(
                //                   "122",
                //                   style: TextStyle(
                //                     fontSize: Responsive.width(context) < 200
                //                         ? 40
                //                         : 60,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.green,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "Processing",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               overflow: TextOverflow.ellipsis,
                //               color: Colors.white,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.shopping_bag,
                //                   color: Colors.white,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                 ),
                //                 Text(
                //                   "312",
                //                   style: TextStyle(
                //                     fontSize: Responsive.width(context) < 200
                //                         ? 40
                //                         : 60,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.red,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "Deliveried",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.delivery_dining,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                   color: Colors.white,
                //                 ),
                //                 Text(
                //                   "32",
                //                   style: TextStyle(
                //                     fontSize: Responsive.width(context) < 200
                //                         ? 40
                //                         : 60,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       color: Colors.orange,
                //       // width: 250,
                //       // height: 250,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "Pending",
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           Expanded(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Icon(
                //                   Icons.payment,
                //                   color: Colors.white,
                //                   size:
                //                       Responsive.width(context) < 200 ? 40 : 60,
                //                 ),
                //                 Text(
                //                   "03",
                //                   style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: Responsive.width(context) < 200
                //                           ? 40
                //                           : 60,
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ],
              ),
            ),
          ),
          // Responsive.isDesktop(context)
          //     ? SizedBox(
          //         width: Responsive.value(300.0, 350.0, 400.0, context),
          //         child: const ChatsBoard(),
          //       )
          //     : const SizedBox(),
        ],
      ),
    );
  }
}
