part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin(this.email, this.password);
}

class AuthLogout extends AuthEvent {}

class AuthInitialize extends AuthEvent {}

class ShowNews extends AuthEvent {}

class ShowHkun extends AuthEvent {}
