// data/datasources/auth_firebase_data_source.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebaseDataSource {
  final firebase.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthFirebaseDataSource(this.firebaseAuth, this.googleSignIn);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException('Login failed. Please try again.');
      }

      return UserModel.fromFirebaseUser(user);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Something went wrong. Please try again.');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = firebase.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException('Google sign-in failed. Please try again.');
      }

      return UserModel.fromFirebaseUser(user);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const ServerException('Sign in cancelled.');
      }
      throw const ServerException('Google sign-in failed. Please try again.');
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Google sign-in failed. Please try again.');
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException('Registration failed. Please try again.');
      }

      await user.updateDisplayName(name);
      await user.reload();
      final updatedUser = firebaseAuth.currentUser!;

      return UserModel.fromFirebaseUser(updatedUser);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Something went wrong. Please try again.');
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Something went wrong. Please try again.');
    }
  }

  Future<void> logout() async {
    await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
  }

  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.'.tr();
      case 'email-already-in-use':
        return 'This email is already registered.'.tr();
      case 'weak-password':
        return 'Password is too weak.'.tr();
      case 'invalid-email':
        return 'Enter a valid email address.'.tr();
      case 'network-request-failed':
        return 'No internet connection.'.tr();
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.'.tr();
      default:
        return 'Authentication failed. Please try again.'.tr();
    }
  }
}
