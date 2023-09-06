import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainshop/model/response.dart';

// ! ||--------------------------------------------------------------------------------||
// ! ||                              Get Data From Server                              ||
// ! ||--------------------------------------------------------------------------------||

Future<dynamic> getdata({
  dynamic x,
  dynamic y,
  dynamic z,
  String? jwt,
}) async {
  dynamic response;
  try {
    String url = "http://localhost:5000";
    if (x == null && y == null && z == null) {
      url = "http://localhost:5000";
    } else if (x != null && y == null && z == null) {
      url = "http://localhost:5000/$x";
    } else if (x != null && y != null && z == null) {
      url = "http://localhost:5000/$x/$y";
    } else if (x != null && y != null && z != null) {
      url = "http://localhost:5000/$x/$y/$z";
    } else {
      url = "http://localhost:5000";
    }
    //print('Network Try is Called : $url');
    response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    );
  } catch (e) {
    print('catch is called from network');
    Map<String, dynamic> res = {
      'statusCode': 500,
      'body': null,
    };
    response = Response.fromJson(res);
  }
  return response;
}

// ! ||--------------------------------------------------------------------------------||
// ! ||                               POST Data to Server                              ||
// ! ||--------------------------------------------------------------------------------||

Future<dynamic> postdata({
  dynamic x,
  dynamic y,
  dynamic z,
  dynamic jwt,
  //Map<String, dynamic>? body,
  dynamic body,
}) async {
  dynamic response;
  try {
    String url = "http://localhost:5000";
    if (x == null && y == null && z == null) {
      url = "http://localhost:5000";
    } else if (x != null && y == null && z == null) {
      url = "http://localhost:5000/$x";
    } else if (x != null && y != null && z == null) {
      url = "http://localhost:5000/$x/$y";
    } else if (x != null && y != null && z != null) {
      url = "http://localhost:5000/$x/$y/$z";
    } else {
      url = "http://localhost:5000";
    }

    response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(body),
    );
  } catch (e) {
    Map<String, dynamic> res = {
      'statusCode': 500,
      'body': null,
    };
    response = Response.fromJson(res);
  }
  return response;
}
// ! ||--------------------------------------------------------------------------------||
// ! ||                               Upload Images with Data and to Server            ||
// ! ||--------------------------------------------------------------------------------||

Future<dynamic> uploadimage({
  required dynamic url,
  required dynamic jwt,
  required dynamic imageBytes, //Uin8List
  dynamic fileName,
  required Map<String, String> body,
}) async {
  dynamic response;
  try {
    String requesturl;
    if (url == null) {
      requesturl = "http://localhost:5000";
    } else {
      requesturl = "http://localhost:5000/$url";
    }
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwt',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(requesturl),
    );
    request.headers.addAll(headers);
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', //key should be matched with multer
        imageBytes,
        filename: fileName,
      ),
    );
    ////print(anyvalue);
    request.fields.addAll(
        body); //anyvalue is Map<String,dynamic> coming from edit profile page.
    dynamic res = await request.send();
    response = await http.Response.fromStream(res);
    return response;
  } catch (e) {
    Map<String, dynamic> res = {
      'statusCode': 500,
      'body': null,
    };
    response = Response.fromJson(res);
  }
}

// ! ||--------------------------------------------------------------------------------||
// ! ||                              Get Image From Server                              ||
// ! ||--------------------------------------------------------------------------------||

Future<dynamic> getimage({
  dynamic url,
  String? jwt,
}) async {
  dynamic response;
  try {
    String imageurl = "";
    if (url == null) {
      imageurl = "http://localhost:5000";
    } else {
      imageurl = "http://localhost:5000/$url";
    }
    //print('Network Try is Called : $url');
    response = await http.get(
      Uri.parse(imageurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    );
  } catch (e) {
    print('Server Down or Client Error');
    Map<String, dynamic> res = {
      'statusCode': 209,
      'body': null,
      'bodyBytes': null,
    };
    response = Response.fromJson(res);
  }
  return response; //original response
}
