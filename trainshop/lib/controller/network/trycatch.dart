import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/model/response.dart';

Future<dynamic> trycatch({
  required String action,
  required Controller controller,
  dynamic anyvalue,
}) async {
  dynamic response;
  //print('Current user Id is : ${controller.appStates.userid.value}');
  try {
    switch (action) {
      //Authentication Request
      //Login
      // case 'login':
      //   {
      //     //print('Try  : login function Called');
      //     String url = "http://localhost:5000/login";
      //     response = await http.post(
      //       Uri.parse(url),
      //       headers: <String, String>{
      //         'Content-Type': 'application/json; charset=UTF-8',
      //       },
      //       body: jsonEncode(
      //         {
      //           "email": controller.appStates.email.value,
      //           "password": controller.appStates.password.value,
      //         },
      //       ),
      //     );
      //   }
      //   break;
      // Sign Up
      case 'signUp':
        {
          //print('Try  : signUp function Called');
          String url = "http://localhost:5000/create";
          //Blank Image file
          // final ByteData byteImage =
          //     await rootBundle.load('assets/images/blank_profile.png');
          // final ByteBuffer bufferImage = byteImage.buffer;
          // final Uint8List uint8listImage = bufferImage.asUint8List(
          //   byteImage.offsetInBytes,
          //   byteImage.lengthInBytes,
          // );
          // final String base64Image = base64Encode(uint8listImage);
          // //print(base64Image);

          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              {
                "username": controller.appStates.username.value,
                "email": controller.appStates.email.value,
                "password": controller.appStates.password.value,
                "countryid": controller.appStates.countryid.value,
                //"imageString": base64Image,
              },
            ),
          );
        }
        break;
      // Reset Password (Verify Email for Password reset)
      case 'verifyEmail':
        {
          //print('Try  : verifyEmail function Called');
          String url = "http://localhost:5000/account";
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              {
                "email": controller.appStates.verifyEmail.value,
              },
            ),
          );
        }
        break;
      //Verify OTP for Password Reset
      case 'verifyOtp':
        {
          //print('Try  : verifyOtp function Called');
          String url = "http://localhost:5000/otpverification";
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              {
                "email": controller.appStates.verifyEmail.value,
                "otp": controller.appStates.otp.value,
              },
            ),
          );
        }
        break;
      //Password Change request
      case 'changePass':
        {
          //print('Try  : changePass function Called');
          String url = "http://localhost:5000/updatepass";
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              {
                "email": controller.appStates.verifyEmail.value,
                "password": controller.appStates.password.value,
              },
            ),
          );
        }
        break;
      /* ------------------- Get User Information on booting app ------------------ */
      case 'getUserInfo':
        {
          //print('Try  : getUserInfo function Called');
          String url = "http://localhost:5000/getUserInfo";
          response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${controller.appStates.jwt.value}',
            },
          );
          //print('Getuserinfo Response body is : ${response.body}');
        }
        break;
      //Get Request from server
      // case 'getAllRequest':
      //   {
      //     //print('Try  : getAllRequest function Called');
      //     String url =
      //         "http://localhost:5000/getAllRequest/${controller.appStates.selectedtrainId.value}";
      //     response = await http.get(
      //       Uri.parse(url),
      //       headers: <String, String>{
      //         'Content-Type': 'application/json; charset=UTF-8',
      //         'Authorization': 'Bearer ${controller.appStates.jwt.value}',
      //       },
      //     );
      //   }
      //   break;
      /* -------------------------- //Get Single Request -------------------------- */
      case 'getSingleRequest':
        {
          //print('Try  : getSingleRequest function Called');
          String url =
              "http://localhost:5000/getSingleRequest/$anyvalue"; //here anyvalue is request id
          response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${controller.appStates.jwt.value}',
            },
          );
        }
        break;
      /* -------------------------- Add Reply to Request -------------------------- */
      case 'addReplyToRequest':
        {
          //print('Try  : addReplyToRequest function Called');
          String url =
              "http://localhost:5000/addReplyToRequest/${anyvalue['requestid']}";
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${controller.appStates.jwt.value}',
            },
            body: jsonEncode(anyvalue),
          );
          //print(response.body);
        }
        break;

      /* ---------------------------- Get Background Image --------------------------- */
      case 'getBackgroundImage':
        {
          // //print(
          //     'Try  : getBackgroundImage Called : Response received from Server');
          String url =
              "http://localhost:5000/backgroundImage/${controller.appStates.userid.value}";
          var res = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          response = res;
          // if (res.statusCode == 200) {
          //   response = res.bodyBytes;
          //   ////print(response);
          // } else {
          //   //Send null if no image found
          //   response = null;
          // }
        }
        break;
      /* ---------------------------- Get Profile Image --------------------------- */
      case 'getProfileImage':
        {
          String url =
              "http://localhost:5000/getimage/${controller.appStates.userid.value}";
          var res = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          response = res;
          // response = Response(
          //   statusCode: res.statusCode,
          //   body: res.body,
          //   bodyBytes: res.bodyBytes,
          // );
          //   //print('getProfileImage status : ${res.statusCode}');
          //   if (res.statusCode == 200) {
          //     response = res.bodyBytes;
          //     ////print(response);
          //   } else {
          //     //Convert ByteData to Uint8List
          //     // final ByteData byteData = await rootBundle.load(
          //     //   'assets/images/blank_profile.png',
          //     // );
          //     // final ByteBuffer buffer = byteData.buffer;
          //     // Uint8List data = buffer.asUint8List(
          //     //   byteData.offsetInBytes,
          //     //   byteData.lengthInBytes,
          //     // );
          //     // ////print(data);
          //     // response = data;

          //     //Send null if no image found
          //     response = null;
          //   }
        }
        break;
      /* ------------------- Get Request or Status Content Image ------------------ */
      case 'contentProfileImage':
        {
          //print('Try  : contentProfileImage function Called');
          //print('Request Owner id is : $anyvalue');
          String url = "http://localhost:5000/getimage/$anyvalue";
          var res = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          //print('contentProfileImage status : ${res.statusCode}');
          if (res.statusCode == 200) {
            ////print('contentProfileImage response is : $res');
            response = res.bodyBytes;
            ////print(response);
          } else {
            //Send null if no image found
            response = null;
          }
        }
        break;

// ! ||--------------------------------------------------------------------------------||
// ! ||                             Update User Information                            ||
// ! ||--------------------------------------------------------------------------------||
      case 'updateProfileInfo':
        {
          //print('Try  : updateUserInfo function Called');
          String url = "http://localhost:5000/updateProfileInfo";
          response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(anyvalue),
          );
        }
        break;
      /* ------------------------- Upload Background Image ------------------------ */
      case 'uploadBackgroundImage':
        {
          //print('Try  : uploadBackgroundImage function Called');
          String url = "http://localhost:5000/upbgimage";
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(url),
          );

          request.files.add(
            http.MultipartFile.fromBytes(
              'backgroundimage', //key should be matched with multer
              anyvalue['imagebytes'],
              filename: anyvalue['filename'],
            ),
          );
          ////print(anyvalue);

          request.fields.addAll(
            {'userid': anyvalue['userid']},
          ); //anyvalue is Map<String,dynamic> coming from edit profile page.
          response = await request.send();
        }
        break;
      /* -------------------------- Upload Profile Image -------------------------- */
      case 'uploadSingleImage':
        {
          //print('Try  : uploadSingleImage function Called');
          String url = "http://localhost:5000/uploadSingleImage";
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(url),
          );

          request.files.add(
            http.MultipartFile.fromBytes(
              'singlepicture',
              anyvalue['imagebytes'],
              filename: anyvalue[
                  'filename'], // NB. Filename is compulsary if MultipartFile.fromBytes is used
            ),
          );

          request.fields.addAll(
            //must be Map<String, String>
            {'userid': anyvalue['userid']},
          );
          response = await request.send();
        }
        break;
// ! ||--------------------------------------------------------------------------------||
// ! ||                                  Profile Home                                  ||
// ! ||--------------------------------------------------------------------------------||
    }
  } catch (e) {
    switch (action) {
      //User Authentication
      //updateProfileInfo
      case 'updateProfileInfo':
        {
          //print('Catch  : updateProfileInfo function Called');
          // Map<String, dynamic> res = {
          //   'statusCode': 500,
          //   'body': null,
          // };
          //response = Response.fromJson(res);
          response = null;
        }
        break;
      //Login
      case 'login':
        {
          //print('Catch  : Login function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      //Sign Up
      case 'signUp':
        {
          //print('Catch  : Sign Up function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      //Email Verification
      case 'verifyEmail':
        {
          //print('Catch  : verifyEmail Up function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      //OTP Verification
      case 'verifyOtp':
        {
          //print('Catch  : verifyOtp function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      //Change Password
      case 'changePass':
        {
          //print('Catch  : changePass function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      /* --------------------------- Get user info -------------------------- */
      case 'getUserInfo':
        {
          //Set Existing info if No internet or Server Error
          //print('Catch  : getUserInfo function Called');
          Map<String, dynamic> res = {
            'statusCode': 200,
            'body': jsonEncode({
              'username': controller.appStates.username.value,
              'userid': controller.appStates.userid.value,
            })
          };
          response = Response.fromJson(res);
        }
        break;
      /* ------------------------- Get allrequest error ------------------------- */
      case 'getAllRequest':
        {
          //print('Catch  : getAllRequest function Called');
          Map<String, dynamic> res = {
            'statusCode': 501,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      /* ------------------------- Get Background image Errorx ------------------------ */
      case 'getBackgroundImage':
        {
          //print('Catch  : getBackgroundImage Called : Image Failed to receive from Server');
          // final ByteData byteData = await rootBundle.load(
          //   'assets/images/blank_profile.png',
          // );
          // final ByteBuffer buffer = byteData.buffer;
          // Uint8List data = buffer.asUint8List(
          //   byteData.offsetInBytes,
          //   byteData.lengthInBytes,
          // );
          // response = data;
          //response = null;
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
            'bodyBytes': null,
          };
          response = Response.fromJson(res);
        }
        break;
      /* ------------------------- Get Profile Image Error ------------------------ */
      case 'getProfileImage':
        {
          //print('Catch  : getProfileImage function Called');
          // final ByteData byteData = await rootBundle.load(
          //   'assets/images/blank_profile.png',
          // );
          // final ByteBuffer buffer = byteData.buffer;
          // Uint8List data = buffer.asUint8List(
          //   byteData.offsetInBytes,
          //   byteData.lengthInBytes,
          // );
          // response = data;
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
            'bodyBytes': null,
          };
          response = Response.fromJson(res);
          //response = null;
        }
        break;
      /* ---------------------- Upload Background Image Error --------------------- */
      case 'uploadBackgroundImage':
        {
          //print('Catch  : uploadBackgroundImage function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      /* ---------------------- Upload Profile Image Error --------------------- */
      case 'uploadSingleImage':
        {
          //print('Catch  : uploadSingleImage function Called');
          Map<String, dynamic> res = {
            'statusCode': 500,
            'body': null,
          };
          response = Response.fromJson(res);
        }
        break;
      /* --------------------------- Upload Profile Info -------------------------- */
      case 'updateUserInfo':
        {
          //print('Catch  : updateUserInfo function Called');
          response = null;
        }
        break;
      case 'uploadSingleImage':
        {
          //print('Catch  : uploadSingleImage function Called');
          response = null;
        }
        break;
      /* ------------------------ Get Single Request Error ------------------------ */
      case 'getSingleRequest':
        {
          //print('Catch  : getSingleRequest function Called');
          response = null;
        }
        break;
      /* ------------------------- Add Reply to Request  ------------------------ */
      case 'addReplyToRequest':
        //print('Catch  : addReplyToRequest function Called');
        //print('error is  : $e');
        Map<String, dynamic> res = {
          'statusCode': 500,
          'body': null,
        };
        response = Response.fromJson(res);
        break;
      //default:
    }
  }
  return response;
}
