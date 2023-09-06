import 'package:flutter/material.dart';
import 'package:trainshop/view/admin/orderlist.dart';

class OrdersHome extends StatefulWidget {
  const OrdersHome({Key? key}) : super(key: key);

  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends State<OrdersHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("OrdersHome"),
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  isScrollable: false,
                  indicatorColor: Colors.green,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      child: Text(
                        "New",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Processing",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Complete",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(children: [
                  Orderlist(),
                  Text("I am New"),
                  Text("I am New"),
                ]),
              ),
            ],
          )),
    );
  }
}
