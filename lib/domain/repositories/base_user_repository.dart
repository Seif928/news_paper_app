// domain/repositories/base_auth_repository.dart
import 'package:news_paper_app/domain/entities/user_entity.dart';

abstract class BaseAuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<UserEntity> signInWithGoogle();

  Future<void> logout();

  UserEntity? getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}
