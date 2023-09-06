import 'package:flutter/material.dart';

class Responsive {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  static dynamic value(
      dynamic mobile, dynamic tablet, dynamic desktop, BuildContext context) {
    //  Return any value depending on screen sizes.
    double constraints = MediaQuery.of(context).size.width;
    // If our width is more than 1100 then we consider it a desktop
    if (constraints >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 650 we consider it as tablet
    else if (constraints >= 650) {
      return tablet;
    } else {
      // Or less then that we called it mobile
      return mobile;
    }
  }
}
