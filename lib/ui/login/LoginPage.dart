
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_bloc.dart';
import 'package:roonyx_assignment/bloc/login/login_bloc.dart';
import 'package:roonyx_assignment/data/repositories/authentication_repository.dart';
import 'package:roonyx_assignment/ui/login/LoginForm.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository:
            RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: LoginForm(),
      ),
    );
  }
}
