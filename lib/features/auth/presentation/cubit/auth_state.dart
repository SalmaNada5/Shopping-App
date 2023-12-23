part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailure extends AuthState {}

final class SignUpSuccess extends AuthState {}

final class SignUpFailure extends AuthState {}

final class EmailValidationChangedState extends AuthState {}

final class PasswordValidationChangedState extends AuthState {}

final class NameValidationChangedState extends AuthState {}
