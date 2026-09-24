// data/repositories/auth_repository_impl.dart

import 'package:news_paper_app/data/datasource/remote_data/firebase_remote_data_source.dart';
import 'package:news_paper_app/domain/entities/user_entity.dart'
    show UserEntity;
import 'package:news_paper_app/domain/repositories/base_user_repository.dart';

class AuthRepositoryImpl implements BaseAuthRepository {
  final AuthFirebaseDataSource firebaseDataSource;

  AuthRepositoryImpl(this.firebaseDataSource);

  @override
  Future<UserEntity> login({required String email, required String password}) {
    return firebaseDataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) {
    return firebaseDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() => firebaseDataSource.logout();

  @override
  UserEntity? getCurrentUser() => firebaseDataSource.getCurrentUser();

  @override
  Future<UserEntity> signInWithGoogle() =>
      firebaseDataSource.signInWithGoogle();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      firebaseDataSource.sendPasswordResetEmail(email: email);

  @override
  Stream<UserEntity?> get authStateChanges =>
      firebaseDataSource.authStateChanges;
}
