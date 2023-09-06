import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/localstorage.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/main.dart';
import 'package:trainshop/screens/admin/profile_home.dart';

AppBar appBar({
  required BuildContext context,
  required Controller controller,
  required String title,
  bool showTrainSelectDropdown = false,
}) {
  dynamic imageData;
  bool refreshProfilePic = true;
  Future<dynamic> getImage() async {
    dynamic res = await trycatch(
      action: 'getProfileImage',
      controller: controller,
    );
    if (res.statusCode == 200) {
      return res.bodyBytes;
    } else {
      return null;
    }
    //return res;
  }

  return AppBar(
    //From Station Select Input
    elevation: 0,
    title: Text(title),
    actions: [
      //Theme Changing Button
      // SizedBox(
      //   width: Responsive.value(150.0, 200.0, 250.0, context),
      //   height: 30,
      //   child: Center(
      //     child: selectdropdown(),
      //   ),
      // ),
      const SizedBox(
        width: 10,
      ),
      SizedBox(
        //color: Colors.yellow,
        width: 60,
        height: 60,
        child: Center(
          child: PopupMenuButton(
            tooltip: "Profile",
            child: Card(
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.white54,
                  width: 1,
                ),
              ),
              elevation: 1,
              /* ------------------------- //Appbar profile Image ------------------------- */
              child: ValueListenableBuilder<bool>(
                valueListenable: controller.appStates.refreshProfilePic,
                builder: (context, value, child) {
                  return Builder(
                    builder: (context) {
                      Widget a = imageData != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: MemoryImage(imageData),
                            )
                          : const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person, size: 20),
                            );
                      if (refreshProfilePic) {
                        getImage().then((value) {
                          imageData =
                              value; //here value is na object of response;
                          refreshProfilePic = false;
                          print('getimage is called from builder');
                          controller.appStates.refreshProfilePic.value =
                              !(controller.appStates.refreshProfilePic.value);
                        }).catchError((e) {
                          print('Error Occurs');
                        });
                      }
                      return a;
                    },
                  );
                },
              ),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () {},
                child: ListTile(
                  onTap: () {
                    Navigator.pop(
                        context); //use this to close the popup before navigate to new page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileHome(controller: controller),
                      ),
                    );
                  },
                  //hoverColor: Colors.green,
                  leading: const Icon(Icons.panorama),
                  title: const Text('View Profile'),
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Account Settings'),
                ),
              ),
              controller.appStates.isDarkTheme.value
                  ? PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        LocalStorage.themeHandler(controller);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.light_mode),
                        title: Text('Light Mode'),
                      ),
                    )
                  : PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        LocalStorage.themeHandler(controller);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.dark_mode),
                        title: Text('Dark Mode'),
                      ),
                    ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.report),
                  title: Text('Report a Bug'),
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                child: ListTile(
                  hoverColor: Colors.red,
                  onTap: () {
                    LocalStorage.logoutHandler(controller);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                        (Route<dynamic> route) => false
                        //Here (Route<dynamic> route) => false will make sure that all routes before the pushed route be removed.
                        //Helping Article : https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
                        );
                    //print(controller.appStates.isLogedIn.value);
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
    ],
  );
}
