import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/responsive/responsive.dart';
import 'package:trainshop/screens/admin/orders_home.dart';
import 'package:trainshop/screens/admin/payment_home.dart';
import 'package:trainshop/screens/admin/products_home.dart';
import 'package:trainshop/screens/admin/profile_home.dart';
import 'package:trainshop/screens/admin/report_home.dart';

class Landing extends StatefulWidget {
  final Controller controller;

  const Landing({Key? key, required this.controller}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 4; //Landing Index

  themeHandler() async {
    bool value = !widget.controller.appStates.isDarkTheme.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeValue', value);
    widget.controller.appStates.isDarkTheme.value = value;
  }

  // //Used to show title of selected item in Appbar
  // List<String> titleList = [
  //   'Status',
  //   'Request',
  //   'Lives',
  //   'Food Shops',
  //   'Admin'
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //widget.controller.appStates.navTitleText.value = titleList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const OrdersHome(),
      ProductsHome(
        controller: widget.controller,
      ),
      ReportHome(controller: widget.controller),
      const PaymentHome(),
      // RequestHome(
      //   controller: widget.controller,
      // ),
      // LiveHome(
      //   controller: widget.controller,
      // ),
      // FoodsHome(
      //   controller: widget.controller,
      // ),
      // AdminHome(
      //   controller: widget.controller,
      // ),
      ProfileHome(
        controller: widget.controller,
      ),
    ];

    //
    return Responsive.isMobile(context)
        ? Scaffold(
            bottomNavigationBar: Responsive.isMobile(context)
                ? BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: Colors.grey,
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.green,
                    onTap: _onItemTapped,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.list,
                        ),
                        label: 'Orders',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.production_quantity_limits,
                        ),
                        label: 'Products',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.payment,
                        ),
                        label: 'Checkout',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.subscriptions,
                        ),
                        label: 'Subscription',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home,
                        ),
                        label: 'Home',
                      ),
                    ],
                  )
                : null,
            body: widgetOptions.elementAt(_selectedIndex),
          )
        : Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // create a navigation rail
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: Responsive.height(context) >
                              (80.0 * widgetOptions.length)
                          ? Responsive.height(context)
                          : (80.0 * widgetOptions.length),
                      child: NavigationRail(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: _onItemTapped,
                        labelType:
                            NavigationRailLabelType.all, //all,selected,none
                        backgroundColor: Colors.green,
                        destinations: const <NavigationRailDestination>[
                          // navigation destinations
                          NavigationRailDestination(
                            icon: Icon(Icons.train_outlined),
                            selectedIcon: Icon(Icons.list_outlined),
                            label: Text('Orders'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.list),
                            selectedIcon: Icon(Icons.list),
                            label: Text('Products'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.payment_outlined),
                            selectedIcon: Icon(Icons.payment),
                            label: Text('Payment'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.subscriptions_outlined),
                            selectedIcon: Icon(Icons.subscriptions),
                            label: Text('Reports'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.home),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                        ],
                        selectedIconTheme:
                            const IconThemeData(color: Colors.white),
                        unselectedIconTheme:
                            const IconThemeData(color: Colors.black),
                        selectedLabelTextStyle:
                            const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Center(
                    child: widgetOptions.elementAt(_selectedIndex),
                  ),
                )
              ],
            ),
          );
  }
}















/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/main.dart';

class Landing extends StatelessWidget {
  final Controller controller;
  const Landing({Key? key, required this.controller}) : super(key: key);

  themeHandler() async {
    bool value = !controller.appStates.isDarkTheme.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeValue', value);
    controller.appStates.isDarkTheme.value = value;
  }

  logoutHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('userinfo') ?? '';
    bool removesuccess = await prefs.remove('userinfo');
    controller.appStates.jwt.value = '';
    controller.appStates.isLogedIn.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing"),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: controller.appStates.isDarkTheme,
            builder: (context, data, child) {
              return Switch(
                value: data,
                onChanged: (value) => themeHandler(),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                logoutHandler();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
              icon: const Icon(Icons.logout_outlined),
              label: const Text("Logout")),
        ),
      ),
    );
  }
}

*/
