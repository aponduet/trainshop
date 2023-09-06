import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/controller/network/trycatch.dart';
import 'package:trainshop/model/localstorage/userinfo.dart';

class LocalStorage {
  //Retrive Data from local storage
  static Future<int> getUserInfo(Controller controller) async {
    // helping article : https://medium.flutterdevs.com/using-sharedpreferences-in-flutter-251755f07127
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('userinfo');

    if (data != null) {
      print('tocken found in localstorage');
      UserInfo userInfo = UserInfo.fromJson(jsonDecode(data));
      controller.appStates.jwt.value = userInfo.jwt ?? '';
      controller.appStates.isLogedIn.value = true;
      controller.appStates.isDarkTheme.value = userInfo.isDarkTheme ?? false;

      // var response = await trycatch(
      //   controller: controller,
      //   action: 'getUserInfo',
      // );

      dynamic response = await getdata(
        x: "getUserInfo",
        jwt: controller.appStates.jwt.value,
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var res = jsonDecode(response.body);
        //UserInfo res = UserInfo.fromJson(jsonDecode(response.body));
        controller.appStates.username.value = res['username'] ?? '';
        controller.appStates.email.value = res['email'] ?? '';
        controller.appStates.userid.value = res['_id'] ?? '';
        controller.appStates.deliveryStationId.value =
            res['deliverystation'] == null ? '' : res['deliverystation']['_id'];
        controller.appStates.deliveryStationName.value =
            res['deliverystation'] == null
                ? ''
                : res['deliverystation']['stationname'];
        controller.appStates.countryid.value =
            res['country'] == null ? '' : res['country']['_id'];
        controller.appStates.countryName.value =
            res['country'] == null ? '' : res['country']['countryname'];
        return 200; //if User exist and Token Valid
      } else {
        return 505; //if user not exist and Token Expired
      }
    } else {
      return 500;
    }
  }

  //LogOut handler
  static dynamic logoutHandler(Controller controller) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.getString('userinfo') ?? '';
    //bool isSuccess = await prefs.remove('userinfo');
    if (await prefs.remove('userinfo')) {
      resetAppStates(controller);
      print('Logout Successfull : ');
    } else {
      print('Logout Failed : ');
    }
  }

  //Reset AppStates
  static dynamic resetAppStates(Controller controller) {
    controller.appStates.jwt.value = '';
    // controller.appStates.username.value = '';
    // controller.appStates.email.value = '';
    // controller.appStates.userid.value = '';
    // controller.appStates.selectedtrainId.value = 'Sundarban';
    controller.appStates.isDarkTheme.value = false;
    controller.appStates.isLogedIn.value = false;
    controller.appStates.isfavorite.value = false;
  }

  //Theme Mode Handler
  static dynamic themeHandler(Controller controller) async {
    bool value = !controller.appStates.isDarkTheme.value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo info = UserInfo(
      // username: controller.appStates.username.value,
      // email: controller.appStates.email.value,
      jwt: controller.appStates.jwt.value,
      isDarkTheme: value,
      isLogedIn: controller.appStates.isLogedIn.value,
      //selectedtrainId: controller.appStates.selectedtrainId.value,
    );
    //await prefs.setString('userinfo', jsonEncode(UserInfo.toJson(info)));
    if (await prefs.setString('userinfo', jsonEncode(UserInfo.toJson(info)))) {
      controller.appStates.isDarkTheme.value = value;
      print('Theme data changed successfully');
    }
    //prefs.setBool('themeValue', value);
  }
}
