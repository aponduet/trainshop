import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/food_image.jpeg',
            width: double.maxFinite,
            height: 200,
            fit: BoxFit.cover,
            //color: Colors.black.withOpacity(0.1),
          ),
          // const Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Text(
          //     "Sohels Food Corner",
          //     textAlign: TextAlign.start,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 24,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
          const ListTile(
            title: Text(
              "Sohels Food Corner",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            subtitle: Text(
              "Poradah Railway Station",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const ListTile(
            title: Text(
              "Here you will find all kinds of foods which will help you to enjoy your journey.Here you will find all kinds of foods which will help you to enjoy your journey",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const ListTile(
            tileColor: Colors.white,
            title: Text(
              'Payment Options',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
