import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/localstorage.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/view/admin/products/addproduct.dart';
import 'package:trainshop/view/admin/products/admin_product_item.dart';
// import 'package:trainshop/view/status/info.dart';
// import 'package:trainshop/view/status/train_route.dart';

class ProductsHome extends StatefulWidget {
  final Controller controller;
  final String? category;
  const ProductsHome({
    Key? key,
    required this.controller,
    this.category,
  }) : super(key: key);

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  //Products List Will Come from Database
  List<dynamic> list = [];

  //get all products from database
  Future<int> getproducts() async {
    int statusCode = 0;
    await getdata(
      x: 'getproducts/${widget.controller.appStates.userid.value}',
      jwt: widget.controller.appStates.jwt.value,
    ).then((res) {
      if (res.statusCode == 200) {
        list = jsonDecode(res.body);
        //print(list);
        statusCode = res.statusCode;
      } else {
        statusCode = res.statusCode;
      }
    });
    return statusCode;
  }

  /* ----------------------- DELETE PRODUCT ----------------------- */
  Future<void> deleteCurrentProduct(productId) async {
    Future<int> deleteProduct() async {
      int status;
      var response = await postdata(
        x: 'deleteproduct/$productId',
        jwt: widget.controller.appStates.jwt.value,
        body: {},
      );

      if (response.statusCode == 200) {
        status = response.statusCode;
      } else {
        if (response.statusCode == 203) {
          //logout if invalid / Expired token or User not found
          LocalStorage.logoutHandler(widget.controller);
          status = response.statusCode;
        } else {
          status = response.statusCode;
        }
      }
      return status;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to delete?'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cencel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.pop(context);
                await deleteProduct().then((value) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.teal,
                    //closeIconColor: Colors.yellow,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(milliseconds: 2000),
                    width: 300,
                    content: Center(
                      child: value == 200
                          ? const Text(
                              'Deleted Successfully!',
                            )
                          : const Text(
                              'Failed to Delete!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar,
                  );
                  if (value == 200) {
                    widget.controller.appStates.refresh.value =
                        !widget.controller.appStates.refresh.value;
                  }
                }).catchError((err) => {print(err)});
              },
            ),
          ],
        );
      },
    );
  }

  //fetch product Image
  // Future<int> deleteproduct(String id) async {
  //   int status = 0;
  //   await postdata(
  //       x: 'deleteproduct',
  //       jwt: widget.controller.appStates.jwt.value,
  //       body: {
  //         'productid': id,
  //       }).then((res) {
  //     if (res.statusCode == 200) {
  //       status = 200;
  //     } else {
  //       status = 500;
  //     }
  //   });
  //   return status;

  //   //return res;
  // }

  @override
  void initState() {
    //getproducts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Products"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addproduct(
                  controller: widget.controller,
                ),
              ),
            ).then((value) {
              setState(() {});
              //print('I ama back');
            });
          },
          tooltip: "Add Product",
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              //Tab Bar
              width: Responsive.width(context),
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.green,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: Responsive.width(context) / 5,
                      //height: 40,
                      child: const Center(
                        child: Text(
                          "Drinks",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: Responsive.width(context) / 5,
                      //height: 40,
                      child: const Center(
                        child: Text(
                          "Snacks",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: Responsive.width(context) / 5,
                      //height: 40,
                      child: const Center(
                        child: Text(
                          "Fruits",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: Responsive.width(context) / 5,
                      //height: 40,
                      child: const Center(
                        child: Text(
                          "Drinks",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: Responsive.width(context) / 5,
                      //height: 40,
                      child: const Center(
                        child: Text(
                          "Meal",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //TabBar View for Mobile Screen
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ValueListenableBuilder(
                        valueListenable: widget.controller.appStates.refresh,
                        builder: (context, value, child) {
                          return FutureBuilder<int>(
                              future: getproducts(),
                              builder: (context, snapshot) {
                                if (snapshot.data == 200) {
                                  print(list);
                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 350,
                                      mainAxisExtent: 350,
                                      //childAspectRatio: 1 / 2.5,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return AdminProductItem(
                                        deleteCurrentProduct:
                                            deleteCurrentProduct,
                                        productInfo: list[index],
                                        controller: widget.controller,
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: Text("Data Loading..."),
                                  );
                                }
                              });
                        }),
                  ),
                  const Center(
                    child: Text("Hello Tisha"),
                  ),
                  const Center(
                    child: Text("Hello Rony"),
                  ),
                  const Center(
                    child: Text("Hello Rocky"),
                  ),
                  const Center(
                    child: Text("Hello Rocky"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
