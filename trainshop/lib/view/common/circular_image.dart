import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/trycatch.dart';

class CircularImage extends StatelessWidget {
  final String userid;
  final Controller controller;
  const CircularImage({
    Key? key,
    required this.userid,
    required this.controller,
  }) : super(key: key);

  Future<dynamic> fetch() async {
    var res = await trycatch(
        action: 'contentProfileImage',
        controller: controller,
        anyvalue: userid);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    //Fetch Image from the server
    return FutureBuilder<dynamic>(
      future: fetch(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Card(
            shape: const CircleBorder(),
            elevation: 1,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(
                snapshot.data,
              ),
            ),
          );
        } else {
          return const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
