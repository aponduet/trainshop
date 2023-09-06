import 'package:flutter/material.dart';

class PaymentHome extends StatefulWidget {
  const PaymentHome({Key? key}) : super(key: key);

  @override
  _PaymentHomeState createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: Center(
        child: Container(
          //color: Colors.yellow,
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    //height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/food_image.jpeg',
                          width: 700,
                          height: 200,
                          fit: BoxFit.cover,
                          //color: Colors.black.withOpacity(0.1),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Tainjourney",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.grey,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Trainjourney is a project of Appsvill Ltd. It is developed to share train location with travellers and also makes easy to get informed about train approximate location",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0),
                          child: Text(
                            "Head Office",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Noor Tower, \nD/23, Road #01, Aftabnagar, \nBadda, Dhaka-1212, Bangladesh. \nEmail : support@appsvill.com \nTel: +880 1745874523",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
