import 'dart:async';

import 'package:assignment_bluestacks/core/helpers/shared_preference.dart';
import 'package:bloc/bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void setPristine() {
    emit(LoginInitial());
  }

  void login(userName, password) {
    print('$userName, $password');
    emit(LoginLoading());

    // simulate API call & delay for 2 seconds
    Timer(Duration(seconds: 2), () async {
      if (userName == '9898989898' && password == "password123") {
        await SharedPreferencesHelper().setIsLoggedIn(true);
        emit(LoginSuccess());
      } else if (userName == '9876543210' && password == "password123") {
        await SharedPreferencesHelper().setIsLoggedIn(true);
        emit(LoginSuccess());
      } else {
        emit(LoginError("Invalid email/password"));
      }
    });
  }
}
