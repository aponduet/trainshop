import 'package:flutter/material.dart';
import 'package:trainshop/view/admin/order_item.dart';

class Orderlist extends StatefulWidget {
  const Orderlist({Key? key}) : super(key: key);

  @override
  _OrderlistState createState() => _OrderlistState();
}

class _OrderlistState extends State<Orderlist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        //top: 10,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 650,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 150,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const OrderItem();
        },
      ),
    );
  }
}
