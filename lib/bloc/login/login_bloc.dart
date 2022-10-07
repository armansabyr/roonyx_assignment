import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:roonyx_assignment/data/data/password.dart';
import 'package:roonyx_assignment/data/data/username.dart';
import 'package:roonyx_assignment/data/repositories/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
          on<LoginUsernameChanged>((event, emit) {
            emit(_mapUsernameChangedToState(event, state));
          });
          on<LoginPasswordChanged>((event, emit) {
            print("pass");
            emit(_mapPasswordChangedToState(event, state));
          });
          on<LoginSubmitted>((event, emit) async {
            print("catched");
            emit(_mapLoginSubmittedToState(event, state));
          });
        }

  final AuthenticationRepository _authenticationRepository;

  // @override
  // Stream<LoginState> mapEventToState(
  //     LoginEvent event,
  //     ) async* {
  //   if (event is LoginUsernameChanged) {
  //     yield _mapUsernameChangedToState(event, state);
  //   } else if (event is LoginPasswordChanged) {
  //     yield _mapPasswordChangedToState(event, state);
  //   } else if (event is LoginSubmitted) {
  //     yield* _mapLoginSubmittedToState(event, state);
  //   }
  // }

  LoginState _mapUsernameChangedToState(
      LoginUsernameChanged event,
      LoginState state,
      ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event,
      LoginState state,
      ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  LoginState _mapLoginSubmittedToState(
      LoginSubmitted event,
      LoginState state,
      ) {
    if (state.status.isValidated) {
      // return state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        return state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        return state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else {
      return state;
    }
  }
}
