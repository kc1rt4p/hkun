part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class ShowNewsScreen extends AuthState {}

class ShowHkunScreen extends AuthState {}
