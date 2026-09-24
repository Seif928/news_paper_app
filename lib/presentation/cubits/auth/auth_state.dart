part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final LoginMethod? loginMethod;
  const AuthLoading({this.loginMethod});

  @override
  List<Object> get props => [loginMethod!];
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class PasswordResetEmailSent extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

enum LoginMethod { email, google }
