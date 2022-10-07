import 'dart:async';

import 'package:uuid/uuid.dart';

import '../data/user.dart';


class UserRepository {
  late User user;

  Future<User> getUser() async {
    if (user != null) return user;
    return Future.delayed(
      const Duration(milliseconds: 300),
          () => user = User(Uuid().v4()),
    );
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
