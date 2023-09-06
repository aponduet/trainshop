import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/main.dart';
import 'package:trainshop/screens/admin/orders_home.dart';
import 'package:trainshop/screens/admin/products_home.dart';
import 'package:trainshop/view/admin/profile/edit_profile.dart';
import 'package:trainshop/controller/localstorage.dart';

class ReportHome extends StatefulWidget {
  final Controller controller;
  const ReportHome({Key? key, required this.controller}) : super(key: key);
  @override
  _ReportHomeState createState() => _ReportHomeState();
}

class _ReportHomeState extends State<ReportHome> {
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

  @override
  void initState() {
    //_tabController = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Responsive.isMobile(context) ? 4 : 3,
      child: Scaffold(
        key: drawerkey,
        endDrawer: Drawer(
          width: 300,
          child: Column(
            children: [
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () {
                  
                },
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
//         appBar: AppBar(
//           elevation: 0,
//           title: const Text("MY PROFILE"),
//           actions: [
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                                Notification Menu                               ||
// // ! ||--------------------------------------------------------------------------------||
//             SizedBox(
//               //color: Colors.yellow,
//               width: 60,
//               height: 60,
//               child: Center(
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       width: 60,
//                       height: 60,
//                       child: PopupMenuButton(
//                         constraints: const BoxConstraints(
//                           minWidth: 300,
//                           maxHeight: 400,
//                         ),
//                         tooltip: "Notifications",
//                         icon: const Icon(
//                           Icons.mail,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                         itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/rocket.png',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/profile.jpeg',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/rocket.png',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       right: 3,
//                       top: 3,
//                       child: Container(
//                         padding: const EdgeInsets.all(3),
//                         constraints: const BoxConstraints(
//                           minHeight: 20,
//                           minWidth: 20,
//                         ),
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           color: Colors.red,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '0',
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             IconButton(
//               onPressed: () {
//                 if (drawerkey.currentState!.isEndDrawerOpen) {
//                   drawerkey.currentState!.closeEndDrawer();
//                 } else {
//                   drawerkey.currentState!.openEndDrawer();
//                 }
//               },
//               icon: const Icon(
//                 Icons.settings,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(
//               width: 16,
//             ),
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                              Profile Settings Menu                             ||
// // ! ||--------------------------------------------------------------------------------||
//             // SizedBox(
//             //   //color: Colors.yellow,
//             //   width: 60,
//             //   height: 60,
//             //   child: Center(
//             //     child: PopupMenuButton(
//             //       tooltip: "Settings",
//             //       child: const CircleAvatar(
//             //         backgroundColor: Colors.green,
//             //         radius: 20,
//             //         child: Icon(
//             //           Icons.settings,
//             //           color: Colors.white,
//             //           size: 30,
//             //         ),
//             //         // backgroundImage: AssetImage(
//             //         //   'assets/images/profile.jpeg',
//             //         // ),
//             //       ),
//             //       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {},
//             //           child: ListTile(
//             //             onTap: () {
//             //               Navigator.pop(context);
//             //               Navigator.push(
//             //                 context,
//             //                 MaterialPageRoute(
//             //                   builder: (context) =>
//             //                       EditProfile(controller: widget.controller),
//             //                 ),
//             //               );
//             //             },
//             //             //hoverColor: Colors.green,
//             //             leading: const Icon(Icons.panorama),
//             //             title: const Text('Edit Profile'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {
//             //             changeImage();
//             //           },
//             //           child: const ListTile(
//             //             // onTap: () {
//             //             //   Navigator.pop(context); //close popup menu
//             //             //   changeImage();
//             //             // },
//             //             leading: Icon(Icons.settings),
//             //             title: Text('Change Profile Image'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {
//             //             //Navigator.pop(context); //close popup menu
//             //             changeBackgroundImage();
//             //           },
//             //           child: const ListTile(
//             //             leading: Icon(Icons.settings),
//             //             title: Text('Change Background Image'),
//             //           ),
//             //         ),
//             //         widget.controller.appStates.isDarkTheme.value
//             //             ? PopupMenuItem(
//             //                 padding: EdgeInsets.zero,
//             //                 onTap: () {
//             //                   LocalStorage.themeHandler(widget.controller);
//             //                 },
//             //                 child: const ListTile(
//             //                   leading: Icon(Icons.light_mode),
//             //                   title: Text('Light Mode'),
//             //                 ),
//             //               )
//             //             : PopupMenuItem(
//             //                 padding: EdgeInsets.zero,
//             //                 onTap: () {
//             //                   LocalStorage.themeHandler(widget.controller);
//             //                 },
//             //                 child: const ListTile(
//             //                   leading: Icon(Icons.dark_mode),
//             //                   title: Text('Dark Mode'),
//             //                 ),
//             //               ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {},
//             //           child: const ListTile(
//             //             leading: Icon(Icons.report),
//             //             title: Text('Report a Bug'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           child: ListTile(
//             //             hoverColor: Colors.red,
//             //             onTap: () {
//             //               LocalStorage.logoutHandler(widget.controller);
//             //               Navigator.pushAndRemoveUntil(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                     builder: (context) => const MyApp(),
//             //                   ),
//             //                   (Route<dynamic> route) => false
//             //                   //Here (Route<dynamic> route) => false will make sure that all routes before the pushed route be removed.
//             //                   //Helping Article : https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
//             //                   );
//             //               //print(widget.controller.appStates.isLogedIn.value);
//             //             },
//             //             leading: const Icon(Icons.logout),
//             //             title: const Text('Sign Out'),
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             /* ---------------------------- // Theme Handler ---------------------------- */
//             // ValueListenableBuilder<bool>(
//             //   valueListenable: widget.controller.appStates.isDarkTheme,
//             //   builder: (context, data, child) {
//             //     return Switch(
//             //       value: data,
//             //       onChanged: (value) =>
//             //           LocalStorage.themeHandler(widget.controller),
//             //     );
//             //   },
//             // ),
//             const SizedBox(
//               width: 10,
//             ),
//           ],
//         ),
        body: Responsive.isMobile(context)
// ! ||--------------------------------------------------------------------------------||
// ! ||                            Layout For Mobile Devices                           ||
// ! ||--------------------------------------------------------------------------------||
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: const Text('MY PROFILE'),
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
                                      //color: Colors.w,
                                      size: 30,
                                    ),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
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
                            //color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),

                        const SizedBox(
                          width: 10,
                        ),
                      ],
                      pinned: true,
                      floating: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        //dividerColor: Colors.yellow,
                        // unselectedLabelColor: Colors.red,
                        // labelColor: Colors.yellow,
                        isScrollable: true,
                        indicatorColor: Colors.green,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            child: SizedBox(
                              width: Responsive.width(context) / 4,
                              child: const Center(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                    //color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: SizedBox(
                              width: Responsive.width(context) / 4,
                              child: const Center(
                                child: Text(
                                  "Status",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: SizedBox(
                              width: Responsive.width(context) / 4,
                              child: const Center(
                                child: Text(
                                  "Requests",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: SizedBox(
                              width: Responsive.width(context) / 4,
                              child: const Center(
                                child: Text(
                                  "Lives",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // bottom: TabBar(
                      //   tabs: <Tab>[
                      //     Tab(text: 'STATISTICS'),
                      //     Tab(text: 'HISTORY'),
                      //   ],
                      //   controller: _tabController,
                      // ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    // Container(
                    //   color: Colors.grey.withOpacity(0.1),
                    //   child: TabBar(
                    //     //dividerColor: Colors.yellow,
                    //     // unselectedLabelColor: Colors.red,
                    //     // labelColor: Colors.yellow,
                    //     isScrollable: true,
                    //     indicatorColor: Colors.green,
                    //     indicatorWeight: 3,
                    //     tabs: [
                    //       Tab(
                    //         child: SizedBox(
                    //           width: Responsive.width(context) / 4,
                    //           child: const Center(
                    //             child: Text(
                    //               "Profile",
                    //               style: TextStyle(
                    //                 color: Colors.grey,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Tab(
                    //         child: SizedBox(
                    //           width: Responsive.width(context) / 4,
                    //           child: const Center(
                    //             child: Text(
                    //               "Status",
                    //               overflow: TextOverflow.ellipsis,
                    //               style: TextStyle(
                    //                 color: Colors.grey,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Tab(
                    //         child: SizedBox(
                    //           width: Responsive.width(context) / 4,
                    //           child: const Center(
                    //             child: Text(
                    //               "Requests",
                    //               overflow: TextOverflow.ellipsis,
                    //               style: TextStyle(
                    //                 color: Colors.grey,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Tab(
                    //         child: SizedBox(
                    //           width: Responsive.width(context) / 4,
                    //           child: const Center(
                    //             child: Text(
                    //               "Lives",
                    //               overflow: TextOverflow.ellipsis,
                    //               style: TextStyle(
                    //                 color: Colors.grey,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Center(
                            child: Text("Hello Sohel"),
                          ),
                          Center(
                            child: Text("Hello Tisha"),
                          ),
                          Center(
                            child: Text("Hello Rony"),
                          ),
                          Center(
                            child: Text("Hello Rocky"),
                          ),
                          // ProfileInfo(controller: widget.controller),
                          // ProfileStatusGallery(
                          //   controller: widget.controller,
                          // ),
                          // ProfileRequestGallery(
                          //   controller: widget.controller,
                          // ),
                          // ProfileLivesGallery(
                          //   controller: widget.controller,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              )

// ! ||--------------------------------------------------------------------------------||
// ! ||                            Layout For Desktp Devices                           ||
// ! ||--------------------------------------------------------------------------------||
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //first part
                  SizedBox(
                    width: Responsive.value(
                      Responsive.width(context),
                      MediaQuery.of(context).size.width < 800 ? 250.0 : 350.0,
                      450.0,
                      context,
                    ),
                    child: const Center(
                      child: Text("Profile Info goes here"),
                    ),
                    // child: ProfileInfo(controller: widget.controller),
                  ),
                  //Last part
                  Expanded(
                    flex: 1,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            //backgroundColor: Colors.white,
                            //elevation: 1,
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
                                            //color: Colors.w,
                                            size: 30,
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry>[
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
                                  //color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),

                              const SizedBox(
                                width: 10,
                              ),
                            ],
                            pinned: true,
                            floating: true,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                              isScrollable:
                                  Responsive.value(true, true, false, context),
                              indicatorColor: Colors.yellow,
                              indicatorWeight: 3,
                              tabs: [
                                Tab(
                                  child: SizedBox(
                                    //color: Colors.green,
                                    width: Responsive.value(
                                      Responsive.width(context) / 4,
                                      MediaQuery.of(context).size.width < 800
                                          ? (Responsive.width(context) - 250) /
                                              3
                                          : (Responsive.width(context) - 350) /
                                              3,
                                      (Responsive.width(context) - 450) / 3,
                                      context,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          //color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: SizedBox(
                                    width: Responsive.value(
                                      Responsive.width(context) / 4,
                                      MediaQuery.of(context).size.width < 800
                                          ? (Responsive.width(context) - 250) /
                                              3
                                          : (Responsive.width(context) - 350) /
                                              3,
                                      (Responsive.width(context) - 450) / 3,
                                      context,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Request",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          //color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: SizedBox(
                                    width: Responsive.value(
                                      Responsive.width(context) / 4,
                                      MediaQuery.of(context).size.width < 800
                                          ? (Responsive.width(context) - 250) /
                                              3
                                          : (Responsive.width(context) - 350) /
                                              3,
                                      (Responsive.width(context) - 450) / 3,
                                      context,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Lives",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          //color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: Column(
                        children: [
                          // Container(
                          //   color: Colors.grey.withOpacity(0.1),
                          //   child: TabBar(
                          //     isScrollable:
                          //         Responsive.value(true, true, false, context),
                          //     indicatorColor: Colors.green,
                          //     indicatorWeight: 3,
                          //     tabs: [
                          //       Tab(
                          //         child: SizedBox(
                          //           //color: Colors.green,
                          //           width: Responsive.value(
                          //             Responsive.width(context) / 4,
                          //             MediaQuery.of(context).size.width < 800
                          //                 ? (Responsive.width(context) - 250) /
                          //                     3
                          //                 : (Responsive.width(context) - 350) /
                          //                     3,
                          //             (Responsive.width(context) - 450) / 3,
                          //             context,
                          //           ),
                          //           child: const Center(
                          //             child: Text(
                          //               "Status",
                          //               style: TextStyle(
                          //                 color: Colors.grey,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       Tab(
                          //         child: SizedBox(
                          //           width: Responsive.value(
                          //             Responsive.width(context) / 4,
                          //             MediaQuery.of(context).size.width < 800
                          //                 ? (Responsive.width(context) - 250) /
                          //                     3
                          //                 : (Responsive.width(context) - 350) /
                          //                     3,
                          //             (Responsive.width(context) - 450) / 3,
                          //             context,
                          //           ),
                          //           child: const Center(
                          //             child: Text(
                          //               "Request",
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(
                          //                 color: Colors.grey,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       Tab(
                          //         child: SizedBox(
                          //           width: Responsive.value(
                          //             Responsive.width(context) / 4,
                          //             MediaQuery.of(context).size.width < 800
                          //                 ? (Responsive.width(context) - 250) /
                          //                     3
                          //                 : (Responsive.width(context) - 350) /
                          //                     3,
                          //             (Responsive.width(context) - 450) / 3,
                          //             context,
                          //           ),
                          //           child: const Center(
                          //             child: Text(
                          //               "Lives",
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(
                          //                 color: Colors.grey,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Center(
                                  child: Text("Hello Sohel"),
                                ),
                                // ProfileStatusGallery(
                                Center(
                                  child: Text("Hello Sohel"),
                                ),
                                // ProfileStatusGallery(
                                Center(
                                  child: Text("Hello Sohel"),
                                ),
                                // ProfileStatusGallery(
                                //   controller: widget.controller,
                                // ),
                                // ProfileRequestGallery(
                                //   controller: widget.controller,
                                // ),
                                // ProfileLivesGallery(
                                //   controller: widget.controller,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //child: StockUpdate(),
                  ),
                ],
              ),
      ),
    );
  }
}











//****** Older Code ******** */






// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:trainshop/controller/controller.dart';
// import 'package:trainshop/controller/network/trycatch.dart';
// import 'package:trainshop/controller/responsive/responsive.dart';
// import 'package:trainshop/main.dart';
// import 'package:trainshop/screens/admin/about_us.dart';
// import 'package:trainshop/screens/admin/admin_shop_home.dart';
// import 'package:trainshop/screens/admin/advertise_home.dart';
// import 'package:trainshop/screens/admin/orders_home.dart';
// import 'package:trainshop/screens/admin/products_home.dart';
// import 'package:trainshop/screens/trainadmin/trainadmin.dart';
// import 'package:trainshop/view/admin/profile/Profile_request_gallery.dart';
// import 'package:trainshop/view/admin/profile/edit_profile.dart';
// import 'package:trainshop/view/admin/profile/profile_info.dart';
// import 'package:trainshop/view/admin/profile/profile_lives_gallery.dart';
// import 'package:trainshop/view/admin/profile/profile_status_gallery.dart';
// import 'package:trainshop/view/admin/shop/stockUpdate.dart';
// import 'package:trainshop/controller/localstorage.dart';

// class ReportHome extends StatefulWidget {
//   final Controller controller;
//   const ReportHome({Key? key, required this.controller}) : super(key: key);

//   @override
//   _ReportHomeState createState() => _ReportHomeState();
// }

// class _ReportHomeState extends State<ReportHome> {
//   String? imageName;
//   late File file;
//   bool isImagSelected = false;
//   final drawerkey = GlobalKey<ScaffoldState>();

// /* ------------------ Upload Single Profile Image so Server ----------------- */

//   changeBackgroundImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       withData: true,
//       //use withData: true, If null is returned in desktop ,
//       //follow https://github.com/miguelpruivo/flutter_file_picker/issues/817
//       type: FileType.image,
//       //allowedExtensions: ['jpg', 'pdf', 'doc'],
//     );
//     if (result != null) {
//       //imagePath = result.files.single.path;
//       Uint8List? imagebytes = result.files.single.bytes;
//       String filename = result.files.single.name;
//       Map<String, dynamic> requestBody = <String, dynamic>{
//         'userid': widget.controller.appStates.userid.value,
//         'imagebytes': imagebytes,
//         'filename': filename,
//       };
//       //print(requestBody);
//       var res = await trycatch(
//         action: 'uploadBackgroundImage',
//         controller: widget.controller,
//         anyvalue: requestBody,
//       );

//       if (res.statusCode == 200) {
//         setState(() {});
//         //isImageSelected = false;
//       }
//     } else {
//       // User canceled the picker
//       print("No image selected");
//     }
//   }

//   changeImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       withData: true,
//       //use withData: true, If null is returned in desktop ,
//       //follow https://github.com/miguelpruivo/flutter_file_picker/issues/817
//       type: FileType.image,
//       //allowedExtensions: ['jpg', 'pdf', 'doc'],
//     );
//     if (result != null) {
//       Uint8List? imageBytes = result.files.single.bytes;
//       //imagePath = result.files.single.path;
//       var filename = result.files.single.name;
//       print('filename is : $filename');

//       Map<String, dynamic> requestBody = {
//         'userid': widget.controller.appStates.userid.value,
//         //image path
//         //'imagepath': imagePath,
//         'imagebytes': imageBytes,
//         'filename': filename,
//       };
//       var res = await trycatch(
//         action: 'uploadSingleImage',
//         controller: widget.controller,
//         anyvalue: requestBody,
//       );
//       if (res.statusCode == 200) {
//         setState(() {});
//         //isImageSelected = false;
//       }
//     } else {
//       // User canceled the picker
//       print("No image selected");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: Responsive.isMobile(context) ? 4 : 3,
//       child: Scaffold(
//         key: drawerkey,
//         endDrawer: Drawer(
//           width: 300,
//           child: Column(
//             children: [
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             EditProfile(controller: widget.controller),
//                       ),
//                     );
//                   },
//                   //hoverColor: Colors.green,
//                   leading: const Icon(Icons.panorama),
//                   title: const Text('Edit Profile'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {
//                   changeImage();
//                 },
//                 child: const ListTile(
//                   // onTap: () {
//                   //   Navigator.pop(context); //close popup menu
//                   //   changeImage();
//                   // },
//                   leading: Icon(Icons.settings),
//                   title: Text('Change Profile Image'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {
//                   //Navigator.pop(context); //close popup menu
//                   changeBackgroundImage();
//                 },
//                 child: const ListTile(
//                   leading: Icon(Icons.settings),
//                   title: Text('Change Background Image'),
//                 ),
//               ),
//               widget.controller.appStates.isDarkTheme.value
//                   ? PopupMenuItem(
//                       padding: EdgeInsets.zero,
//                       onTap: () {
//                         LocalStorage.themeHandler(widget.controller);
//                       },
//                       child: const ListTile(
//                         leading: Icon(Icons.light_mode),
//                         title: Text('Light Mode'),
//                       ),
//                     )
//                   : PopupMenuItem(
//                       padding: EdgeInsets.zero,
//                       onTap: () {
//                         LocalStorage.themeHandler(widget.controller);
//                       },
//                       child: const ListTile(
//                         leading: Icon(Icons.dark_mode),
//                         title: Text('Dark Mode'),
//                       ),
//                     ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Orders(),
//                       ),
//                     );
//                   },
//                   leading: const Icon(Icons.list),
//                   title: const Text('Orders'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductsHome(
//                           controller: widget.controller,
//                         ),
//                       ),
//                     );
//                   },
//                   leading: const Icon(Icons.production_quantity_limits_sharp),
//                   title: const Text('Products'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 Trainadmin(controller: widget.controller)));
//                   },
//                   leading: const Icon(Icons.train_outlined),
//                   title: const Text('Train Admin'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AdminShopHome(
//                           controller: widget.controller,
//                         ),
//                       ),
//                     );
//                   },
//                   leading: const Icon(Icons.report),
//                   title: const Text('Admin Shop'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => AdvertiseHome(
//                                   controller: widget.controller,
//                                 )));
//                   },
//                   leading: const Icon(Icons.report),
//                   title: const Text('Advertise Home'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 onTap: () {},
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                         context, MaterialPageRoute(builder: (_) => AboutUs()));
//                   },
//                   leading: const Icon(Icons.report),
//                   title: const Text('About Us'),
//                 ),
//               ),
//               PopupMenuItem(
//                 padding: EdgeInsets.zero,
//                 child: ListTile(
//                   hoverColor: Colors.red,
//                   onTap: () {
//                     LocalStorage.logoutHandler(widget.controller);
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MyApp(),
//                         ),
//                         (Route<dynamic> route) => false
//                         //Here (Route<dynamic> route) => false will make sure that all routes before the pushed route be removed.
//                         //Helping Article : https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
//                         );
//                     //print(widget.controller.appStates.isLogedIn.value);
//                   },
//                   leading: const Icon(Icons.logout),
//                   title: const Text('Sign Out'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         appBar: AppBar(
//           elevation: 0,
//           title: const Text("MY PROFILE"),
//           actions: [
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                                Notification Menu                               ||
// // ! ||--------------------------------------------------------------------------------||
//             SizedBox(
//               //color: Colors.yellow,
//               width: 60,
//               height: 60,
//               child: Center(
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       width: 60,
//                       height: 60,
//                       child: PopupMenuButton(
//                         constraints: const BoxConstraints(
//                           minWidth: 300,
//                           maxHeight: 400,
//                         ),
//                         tooltip: "Notifications",
//                         icon: const Icon(
//                           Icons.mail,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                         itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/rocket.png',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/profile.jpeg',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/rocket.png',
//                                 ),
//                               ),
//                               title: Text("Md. Sohel Rana"),
//                               subtitle: Text(
//                                   "Please Send my product as soon as possible."),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       right: 3,
//                       top: 3,
//                       child: Container(
//                         padding: const EdgeInsets.all(3),
//                         constraints: const BoxConstraints(
//                           minHeight: 20,
//                           minWidth: 20,
//                         ),
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           color: Colors.red,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '0',
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             IconButton(
//               onPressed: () {
//                 if (drawerkey.currentState!.isEndDrawerOpen) {
//                   drawerkey.currentState!.closeEndDrawer();
//                 } else {
//                   drawerkey.currentState!.openEndDrawer();
//                 }
//               },
//               icon: const Icon(
//                 Icons.settings,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(
//               width: 16,
//             ),
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                              Profile Settings Menu                             ||
// // ! ||--------------------------------------------------------------------------------||
//             // SizedBox(
//             //   //color: Colors.yellow,
//             //   width: 60,
//             //   height: 60,
//             //   child: Center(
//             //     child: PopupMenuButton(
//             //       tooltip: "Settings",
//             //       child: const CircleAvatar(
//             //         backgroundColor: Colors.green,
//             //         radius: 20,
//             //         child: Icon(
//             //           Icons.settings,
//             //           color: Colors.white,
//             //           size: 30,
//             //         ),
//             //         // backgroundImage: AssetImage(
//             //         //   'assets/images/profile.jpeg',
//             //         // ),
//             //       ),
//             //       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {},
//             //           child: ListTile(
//             //             onTap: () {
//             //               Navigator.pop(context);
//             //               Navigator.push(
//             //                 context,
//             //                 MaterialPageRoute(
//             //                   builder: (context) =>
//             //                       EditProfile(controller: widget.controller),
//             //                 ),
//             //               );
//             //             },
//             //             //hoverColor: Colors.green,
//             //             leading: const Icon(Icons.panorama),
//             //             title: const Text('Edit Profile'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {
//             //             changeImage();
//             //           },
//             //           child: const ListTile(
//             //             // onTap: () {
//             //             //   Navigator.pop(context); //close popup menu
//             //             //   changeImage();
//             //             // },
//             //             leading: Icon(Icons.settings),
//             //             title: Text('Change Profile Image'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {
//             //             //Navigator.pop(context); //close popup menu
//             //             changeBackgroundImage();
//             //           },
//             //           child: const ListTile(
//             //             leading: Icon(Icons.settings),
//             //             title: Text('Change Background Image'),
//             //           ),
//             //         ),
//             //         widget.controller.appStates.isDarkTheme.value
//             //             ? PopupMenuItem(
//             //                 padding: EdgeInsets.zero,
//             //                 onTap: () {
//             //                   LocalStorage.themeHandler(widget.controller);
//             //                 },
//             //                 child: const ListTile(
//             //                   leading: Icon(Icons.light_mode),
//             //                   title: Text('Light Mode'),
//             //                 ),
//             //               )
//             //             : PopupMenuItem(
//             //                 padding: EdgeInsets.zero,
//             //                 onTap: () {
//             //                   LocalStorage.themeHandler(widget.controller);
//             //                 },
//             //                 child: const ListTile(
//             //                   leading: Icon(Icons.dark_mode),
//             //                   title: Text('Dark Mode'),
//             //                 ),
//             //               ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           onTap: () {},
//             //           child: const ListTile(
//             //             leading: Icon(Icons.report),
//             //             title: Text('Report a Bug'),
//             //           ),
//             //         ),
//             //         PopupMenuItem(
//             //           padding: EdgeInsets.zero,
//             //           child: ListTile(
//             //             hoverColor: Colors.red,
//             //             onTap: () {
//             //               LocalStorage.logoutHandler(widget.controller);
//             //               Navigator.pushAndRemoveUntil(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                     builder: (context) => const MyApp(),
//             //                   ),
//             //                   (Route<dynamic> route) => false
//             //                   //Here (Route<dynamic> route) => false will make sure that all routes before the pushed route be removed.
//             //                   //Helping Article : https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
//             //                   );
//             //               //print(widget.controller.appStates.isLogedIn.value);
//             //             },
//             //             leading: const Icon(Icons.logout),
//             //             title: const Text('Sign Out'),
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             /* ---------------------------- // Theme Handler ---------------------------- */
//             // ValueListenableBuilder<bool>(
//             //   valueListenable: widget.controller.appStates.isDarkTheme,
//             //   builder: (context, data, child) {
//             //     return Switch(
//             //       value: data,
//             //       onChanged: (value) =>
//             //           LocalStorage.themeHandler(widget.controller),
//             //     );
//             //   },
//             // ),
//             const SizedBox(
//               width: 10,
//             ),
//           ],
//         ),
//         body: Responsive.isMobile(context)
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                            Layout For Mobile Devices                           ||
// // ! ||--------------------------------------------------------------------------------||
//             ? Column(
//                 children: [
//                   Container(
//                     color: Colors.grey.withOpacity(0.1),
//                     child: TabBar(
//                       //dividerColor: Colors.yellow,
//                       // unselectedLabelColor: Colors.red,
//                       // labelColor: Colors.yellow,
//                       isScrollable: true,
//                       indicatorColor: Colors.green,
//                       indicatorWeight: 3,
//                       tabs: [
//                         Tab(
//                           child: SizedBox(
//                             width: Responsive.width(context) / 4,
//                             child: const Center(
//                               child: Text(
//                                 "Profile",
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Tab(
//                           child: SizedBox(
//                             width: Responsive.width(context) / 4,
//                             child: const Center(
//                               child: Text(
//                                 "Status",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Tab(
//                           child: SizedBox(
//                             width: Responsive.width(context) / 4,
//                             child: const Center(
//                               child: Text(
//                                 "Requests",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Tab(
//                           child: SizedBox(
//                             width: Responsive.width(context) / 4,
//                             child: const Center(
//                               child: Text(
//                                 "Lives",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         ProfileInfo(controller: widget.controller),
//                         ProfileStatusGallery(
//                           controller: widget.controller,
//                         ),
//                         ProfileRequestGallery(
//                           controller: widget.controller,
//                         ),
//                         ProfileLivesGallery(
//                           controller: widget.controller,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
// // ! ||--------------------------------------------------------------------------------||
// // ! ||                            Layout For Desktp Devices                           ||
// // ! ||--------------------------------------------------------------------------------||
//             : Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //first part
//                   SizedBox(
//                     width: Responsive.value(
//                       Responsive.width(context),
//                       MediaQuery.of(context).size.width < 800 ? 250.0 : 350.0,
//                       450.0,
//                       context,
//                     ),
//                     child: ProfileInfo(controller: widget.controller),
//                   ),
//                   //Last part
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       children: [
//                         Container(
//                           color: Colors.grey.withOpacity(0.1),
//                           child: TabBar(
//                             isScrollable:
//                                 Responsive.value(true, true, false, context),
//                             indicatorColor: Colors.green,
//                             indicatorWeight: 3,
//                             tabs: [
//                               Tab(
//                                 child: SizedBox(
//                                   //color: Colors.green,
//                                   width: Responsive.value(
//                                     Responsive.width(context) / 4,
//                                     MediaQuery.of(context).size.width < 800
//                                         ? (Responsive.width(context) - 250) / 3
//                                         : (Responsive.width(context) - 350) / 3,
//                                     (Responsive.width(context) - 450) / 3,
//                                     context,
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       "Status",
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Tab(
//                                 child: SizedBox(
//                                   width: Responsive.value(
//                                     Responsive.width(context) / 4,
//                                     MediaQuery.of(context).size.width < 800
//                                         ? (Responsive.width(context) - 250) / 3
//                                         : (Responsive.width(context) - 350) / 3,
//                                     (Responsive.width(context) - 450) / 3,
//                                     context,
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       "Request",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Tab(
//                                 child: SizedBox(
//                                   width: Responsive.value(
//                                     Responsive.width(context) / 4,
//                                     MediaQuery.of(context).size.width < 800
//                                         ? (Responsive.width(context) - 250) / 3
//                                         : (Responsive.width(context) - 350) / 3,
//                                     (Responsive.width(context) - 450) / 3,
//                                     context,
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       "Lives",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: TabBarView(
//                             children: [
//                               ProfileStatusGallery(
//                                 controller: widget.controller,
//                               ),
//                               ProfileRequestGallery(
//                                 controller: widget.controller,
//                               ),
//                               ProfileLivesGallery(
//                                 controller: widget.controller,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     //child: StockUpdate(),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
