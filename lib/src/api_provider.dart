import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roonyx_assignment/data/data/login.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final storage = const FlutterSecureStorage();
  var _baseUrl = "jsonplaceholder.typicode.com";
  Future<LoginResponse> logIn({
    required String username,
    required String password,
  }) async {
    assert(username != null);
    assert(password != null);
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    print(Uri.https(_baseUrl, 'posts/42'));
    final response = await http.get(
        Uri.https(_baseUrl, 'posts/42'));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // This is real life example for parsing the response from API
      // return LoginResponse.fromJson(
      //    response.body as Map<String, dynamic>);

      //But now I'll be returning mocked response
      return LoginResponse(accessToken: "Accestoken", expiresIn: '1000');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  }

}