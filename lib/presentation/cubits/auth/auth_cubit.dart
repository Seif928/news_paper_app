// presentation/cubits/auth/auth_cubit.dart
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/user_entity.dart';
import 'package:news_paper_app/domain/repositories/base_user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial()) {
    _authSubscription = _repository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else if (state is! AuthInitial) {
        emit(AuthInitial());
      }
    });
  }

  final BaseAuthRepository _repository;
  late final StreamSubscription<UserEntity?> _authSubscription;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading(loginMethod: LoginMethod.email));
    try {
      await _repository.login(email: email, password: password);
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading(loginMethod: LoginMethod.email));
    try {
      await _repository.register(name: name, email: email, password: password);
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  // presentation/cubits/auth/auth_cubit.dart
  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(AuthLoading(loginMethod: LoginMethod.email));
    try {
      await _repository.sendPasswordResetEmail(email: email);
      emit(PasswordResetEmailSent());
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> logout() => _repository.logout();
  Future<void> signInWithGoogle() async {
    emit(AuthLoading(loginMethod: LoginMethod.google));
    try {
      await _repository.signInWithGoogle();
    } on ServerException catch (e) {
      if (e.message == 'Sign in cancelled.') {
        emit(AuthInitial());
        return;
      }
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
