import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_bloc.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_event.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_state.dart';
import 'package:roonyx_assignment/data/repositories/authentication_repository.dart';
import 'package:roonyx_assignment/data/repositories/user_repository.dart';
import 'package:roonyx_assignment/ui/SplashPage.dart';
import 'package:roonyx_assignment/ui/home/HomePage.dart';
import 'package:roonyx_assignment/ui/login/LoginPage.dart';

class App extends StatelessWidget {

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const App({
    Key? key, required this.authenticationRepository,
    required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ) ..add(AppStarted()),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            print("dfgdfg " + state.status.toString());
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator?.push(HomePage.route());
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator?.push(LoginPage.route());
                break;
              default:
                _navigator?.push(SplashPage.route());
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
