import 'package:flutter/material.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/view/admin/order_product.dart';

class OrderProductGrid extends StatefulWidget {
  const OrderProductGrid({Key? key}) : super(key: key);

  @override
  _OrderProductGridState createState() => _OrderProductGridState();
}

class _OrderProductGridState extends State<OrderProductGrid> {
  //Products List Will Come from Database
  List<Map<String, dynamic>> productInfo = [
    {
      'product_id': 1,
      'product_name': 'Chicken Birani',
      'product_description':
          'Tasty Chicken with Polaw rice , Salad, Softdrinks and fried chickn.Tasty Chicken with Polaw rice , Salad, Softdrinks and fried chickn.',
      'price': '120tk',
      'quantity': 5,
      'stock': 10,
      'shop_id': 10,
      'shop_name': 'Sohel Hotel & Restaurant',
    },
    {
      'product_id': 2,
      'product_name': 'Beef Rejala',
      'product_description':
          'Softdrinks and fried chickn.Tasty Chicken with Polaw rice , Salad, Softdrinks and fried chickn',
      'price': '220 tk',
      'quantity': 5,
      'stock': 20,
      'shop_id': 11,
      'shop_name': 'Tisha Restaurant & Fuska',
    },
    {
      'product_id': 3,
      'product_name': 'Borhani',
      'product_description':
          'Very Tasty Borhani with lemon flavor and juicy orange.',
      'price': '30 tk',
      'quantity': 5,
      'stock': 10,
      'shop_id': 12,
      'shop_name': 'Sohel Hotel & Restaurant',
    },
    {
      'product_id': 4,
      'product_name': 'Mutton Sandwich',
      'product_description':
          'Bread and mutton sandwith with tomato souse, chili flavor and free water.',
      'price': '150 tk',
      'quantity': 5,
      'stock': 10,
      'shop_id': 14,
      'shop_name': 'Hamim Hotel & Restaurant',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          //color: Colors.yellow,
          child: GridView.builder(
            itemCount: productInfo.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 300,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return OrderProduct(productInfo: productInfo, index: index);
            },
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            height: Responsive.value(50.0, 80.0, 100.0, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have you Received Products?",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Colors.yellow,
                  onPressed: () {},
                  child: const SizedBox(
                    height: 40,
                    child: Center(
                      child: Text("Yes!"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
