import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roonyx_assignment/data/data/login.dart';
import 'package:roonyx_assignment/src/api_provider.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  ApiProvider apiProvider = ApiProvider();
  final storage = const FlutterSecureStorage();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    var value = await storage.read(key: 'access_token');

    yield value == null ?
    AuthenticationStatus.unauthenticated : AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  void logIn({
    required String username,
    required String password,
  }) async {

    assert(username != null);
    assert(password != null);

    username = username.toLowerCase();
    username = username.replaceAll(' ', '');

    LoginResponse loginResponse;
    loginResponse =  await apiProvider.logIn(
        username: username,
        password: password);

    if (loginResponse.accessToken != null) {
      _controller.add(AuthenticationStatus.authenticated);
      // Write value
      await storage.write(
          key: 'access_token',
          value: loginResponse.accessToken);

      //counting expires at
      var expiresAt = DateTime.now().millisecondsSinceEpoch
          + (int.parse(loginResponse.expiresIn) * 1000);
      await storage.write(
          key: 'expires_at',
          value: expiresAt.toString());
    }
  }

  Future<bool> hasToken() async {
    return await storage.containsKey(key: "access_token");
  }

  Future<void> logOut() async {
    _controller.add(AuthenticationStatus.unauthenticated);
    await storage.delete(key: 'access_token');
  }

  void dispose() => _controller.close();


}
