// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:trainjourney/controller/controller.dart';

// class ProfileImage extends StatelessWidget {
//   final Controller controller;
//   bool isSuccess = true;
//   ProfileImage({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     try {
//       print("Image is fetching ");
//       return CircleAvatar(
//         radius: 20,
//         backgroundImage: NetworkImage(
//           'http://localhost:5000/getimage/4ba79f71-6b52-4269-a7eb-1f2f16ab6605.PNG',
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             "Authorization": "Bearer ${controller.appStates.jwt.value}",
//           },
//         ),
//       );
//     } on SocketException catch (e) {
//       print('I am from Image profile');
//       isSuccess = false;
//       throw const CircleAvatar(
//         radius: 20,
//         backgroundImage: AssetImage(
//           'assets/images/blank_profile.png',
//         ),
//       );
//     }
//     // finally {
//     //   if (!isSuccess) {
//     //     const CircleAvatar(
//     //       radius: 20,
//     //       backgroundImage: AssetImage(
//     //         'assets/images/blank_profile.png',
//     //       ),
//     //     );
//     //   }
//     // }
//   }
// }
