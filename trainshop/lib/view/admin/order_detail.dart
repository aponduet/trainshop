import 'package:flutter/material.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/view/admin/order_product_grid.dart';
import 'package:trainshop/view/admin/order_status.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        body: Responsive.isMobile(context)
            ? Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                        indicatorColor: Colors.green,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            child: Text(
                              "Status",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Items",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        OrderStatus(),
                        OrderProductGrid(),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: Responsive.value(300.0, 300.0, 400.0, context),
                    child: const OrderStatus(),
                  ),
                  const Expanded(
                    child: OrderProductGrid(),
                  )
                ],
              ),
      ),
    );
  }
}
