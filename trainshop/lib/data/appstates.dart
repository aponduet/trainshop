import 'package:flutter/foundation.dart';

class AppStates {
  //Themes
  final ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);
  //Authentication
  final ValueNotifier<bool> isLogedIn = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isfavorite = ValueNotifier<bool>(false);
  final ValueNotifier<String> username = ValueNotifier<String>('');
  final ValueNotifier<String> shopname = ValueNotifier<String>('');
  final ValueNotifier<String> userid = ValueNotifier<String>('');
  final ValueNotifier<String> verifyEmail = ValueNotifier<String>('');
  final ValueNotifier<String> email = ValueNotifier<String>('');
  final ValueNotifier<String> password = ValueNotifier<String>('');
  final ValueNotifier<String> otp = ValueNotifier<String>('');
  final ValueNotifier<String> jwt = ValueNotifier<String>('');
  // final ValueNotifier<String> selectedTrain =
  //     ValueNotifier<String>('Sundarban');

  final ValueNotifier<String> deliveryStationId = ValueNotifier<String>('');
  final ValueNotifier<String> deliveryStationName = ValueNotifier<String>('');
  // final ValueNotifier<String> selectedTrainName = ValueNotifier<String>('');
  // final ValueNotifier<String> toStationName = ValueNotifier<String>('');
  // final ValueNotifier<String> fromStationName = ValueNotifier<String>('');
  // final ValueNotifier<String> selectedtrainId = ValueNotifier<String>('');
  //final ValueNotifier<int> trainId = ValueNotifier<int>(762);
  // final ValueNotifier<String> toStationId = ValueNotifier<String>('');
  // final ValueNotifier<String> fromStationId = ValueNotifier<String>('');

  final ValueNotifier<bool> isOffLine = ValueNotifier<bool>(false);
  //Refresh
  final ValueNotifier<bool> refreshProfilePic = ValueNotifier<bool>(true);
  final ValueNotifier<bool> refresh = ValueNotifier<bool>(true);
  final ValueNotifier<String> countryName = ValueNotifier<String>('');
  final ValueNotifier<String> countryid = ValueNotifier<String>('');
//
  final ValueNotifier<int> totalReplyItem = ValueNotifier<int>(0);
  final ValueNotifier<int> totalItem = ValueNotifier<int>(0);
  final ValueNotifier<Map<String, dynamic>> selectedItemInfo =
      ValueNotifier<Map<String, dynamic>>({});
  final ValueNotifier<bool> refreshMessageBoard = ValueNotifier<bool>(false);
}
