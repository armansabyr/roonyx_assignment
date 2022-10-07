import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_state.dart';
import 'package:roonyx_assignment/bloc/authentication/authentication_event.dart';
import 'package:roonyx_assignment/data/repositories/authentication_repository.dart';
import 'package:roonyx_assignment/data/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(const AuthenticationState.unknown()){
          on<AppStarted>((event, emit) async {
            final bool hasToken = await authenticationRepository.hasToken();

            if (hasToken) {
              emit(AuthenticationState.authenticated());
            } else {
              emit(AuthenticationState.unauthenticated());
            }
          });
          on<LoggedIn>((event, emit) {
            emit(AuthenticationState.authenticated());
          });
          on<LoggedOut>((event, emit) async {
            emit(AuthenticationState.unknown());
            await authenticationRepository.logOut();
            emit(AuthenticationState.unauthenticated());
          });
        }
  // AuthenticationState get initialState => AuthenticationState.unknown();

  // @override
  // Stream<AuthenticationState> mapEventToState(
  //     AuthenticationState currentState,
  //     AuthenticationEvent event,
  //     ) async* {
  //   if (event is AppStarted) {
  //     final bool hasToken = await authenticationRepository.hasToken();
  //
  //     if (hasToken) {
  //       yield AuthenticationState.authenticated();
  //     } else {
  //       yield AuthenticationState.unauthenticated();
  //     }
  //   }
  //
  //   if (event is LoggedIn) {
  //     yield AuthenticationState.authenticated();
  //   }
  //
  //   if (event is LoggedOut) {
  //     yield AuthenticationState.unknown();
  //     await authenticationRepository.logOut();
  //     yield AuthenticationState.unauthenticated();
  //   }
  //
  // }
}