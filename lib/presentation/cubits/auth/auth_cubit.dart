// presentation/cubits/auth/auth_cubit.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/service/notification_service.dart';
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
      final userId = _repository.getCurrentUser()?.id;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'fcmToken': FieldValue.delete()},
        );
      }
      await _repository.login(email: email, password: password);
      await _saveFcmToken();
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
      await _saveFcmToken();
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (_) {
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

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
      await _saveFcmToken();
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

  Future<void> _saveFcmToken() async {
    final token = await NotificationService().getToken();
    final userId = _repository.getCurrentUser()?.id;
    if (token != null && userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
