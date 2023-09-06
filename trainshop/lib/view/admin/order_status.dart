import 'package:flutter/material.dart';
import 'package:trainshop/controller/responsive/responsive.dart';

class OrderStatus extends StatefulWidget {
  //final Function sendHandler;
  const OrderStatus({
    Key? key,
    //required this.sendHandler,
  }) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool isSeller = true;
  List<String> orderOptions = <String>['Pending', 'Accepted', 'Rejected'];
  String orderStatus = 'Pending';
  List<String> paymentOptions = <String>['Pending', 'Received', 'Not Received'];
  String paymentStatus = 'Pending';
  List<String> deliveryOptions = <String>[
    'Pending',
    'Processing',
    'Ready',
    'Waiting at Station'
  ];
  String deliveryStatus = 'Pending';
  @override
  Widget build(BuildContext context) {
    return //Delivery Information Area
        Card(
      child: SizedBox(
        width: Responsive.value(350.0, 350.0, 400.0, context),
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //Seller Payment Information
              isSeller
                  ?
                  //For Seller Status
                  Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          color: Colors.green,
                          //height: 40,
                          child: const Text(
                            "Status :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Order Status :", //submitted, accepted, rejected, pending
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    color: Colors.white,
                                    child: DropdownButton<String>(
                                      iconEnabledColor: Colors.grey,
                                      dropdownColor: Colors.white,
                                      underline: const SizedBox(),
                                      elevation: 0,
                                      isDense: true,
                                      value: orderStatus,
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          orderStatus = value!;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      items: orderOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Payment Status :", //submitted, accepted, rejected, pending
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    color: Colors.white,
                                    child: DropdownButton<String>(
                                      iconEnabledColor: Colors.grey,
                                      dropdownColor: Colors.white,
                                      underline: const SizedBox(),
                                      elevation: 0,
                                      isDense: true,
                                      value: paymentStatus,
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          paymentStatus = value!;
                                        });
                                      },
                                      items: paymentOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Delivery Status :", //Processing, Ready, Complete, pending
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    color: Colors.white,
                                    child: DropdownButton<String>(
                                      iconEnabledColor: Colors.grey,
                                      //dropdownColor: Colors.white,
                                      underline: const SizedBox(),
                                      elevation: 0,
                                      isDense: true,
                                      value: deliveryStatus,
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          deliveryStatus = value!;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      items: deliveryOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      //Status for Buyer
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          color: Colors.green,
                          //height: 40,
                          child: const Text(
                            "Status :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Order Status : Submitted", //submitted, accepted, rejected, pending
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Payment Status : Pending", //submitted, accepted, rejected, pending
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Delivery Status : Pending", //Processing, Ready, Complete, pending
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          width: double.infinity,
                          child: const Text(
                            "** Pay money before or After cornifming order, we will start processing after receiving money **",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              //Payment Information
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    color: Colors.green,
                    //height: 40,
                    child: const Text(
                      "Payment Information :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    width: double.infinity,
                    //color: Colors.green,
                    //height: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Billed Ammount : Tk 325.00",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Buyer Payment Authority : Bkash",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Buyer Payment A/C : 01478547812",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Seller Payment Authority : Bkash",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Seller Payment A/C : 01478547812",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //Buyer Information
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    color: Colors.green,
                    //height: 40,
                    child: const Text(
                      "Buyer Information :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    width: double.infinity,
                    //color: Colors.green,
                    //height: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "MST. FARZANA TRISHA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Mobile : 01748124578 \nEmail : farjana@gmail.com \nTrain : Sundarban Express. \nDelivery Station: Poradah Railway Station",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Coach No. : KHA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Seat No. : 54 ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //Seller Information
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    color: Colors.green,
                    //height: 40,
                    child: const Text(
                      "Seller Information :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    width: double.infinity,
                    //color: Colors.green,
                    //height: 40,
                    child: const Text(
                      "SOHEL HOTEL & RESTAURANT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      //vertical: 10,
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    //color: Colors.green,
                    //height: 40,
                    child: const Text(
                      "Poradah Railway Station. \nMobile : 01748124578 \nEmail : sohelrana.yy@gmail.com",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
