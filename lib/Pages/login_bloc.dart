import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc(): super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        // Simulate a login process
        await Future.delayed(Duration(seconds: 2));
        if (event.username == 'user' && event.password == 'pass') {
          yield LoginSuccess();
        } else {
          yield LoginFailure(error: 'Invalid username or password');
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}