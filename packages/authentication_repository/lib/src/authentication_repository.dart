import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

// throw if there's a sign up failure
class SignUpFailure implements Exception{}
// throw if there's a login failure
class LoginFailure implements Exception{}
// throw if there's email verification failure
class EmailVerifiedFailure implements Exception{}
// throw if there's a phone register failure
class PhoneRegisterFailure implements Exception{}
// throw if there's phone link failure
class PhoneLinkFailure implements Exception{}
// throw if there's a logout failure
class LogoutFailure implements Exception{}

class ResetPasswordEmailFailure implements Exception{}

class AuthenticationEmailAlreadyExists implements Exception{}
class AuthenticationInvalidCredential implements Exception{}
class AuthenticationInvalidIdToken implements Exception{}
class AuthenticationInvalidPassword implements Exception{}
class AuthenticationInvalidPhoneNumber implements Exception{}
class AuthenticationPhoneAlreadyExists implements Exception{}
class AuthenticationUserNotFound implements Exception{}
class AuthenticationInvalidEmail implements Exception{}
class AuthenticationInvalidVerificationCode implements Exception{}
class AuthenticationCodeExpired implements Exception{}
class AuthenticationQuotaExceed implements Exception{}
class AuthenticationWrongPassword implements Exception{}
class AuthenticationWeakPassword implements Exception{}
class AuthenticationUserTokenExpired implements Exception{}
class AuthenticationNullUser implements Exception{}
class AuthenticationAlreadyExists implements Exception{}
class NoNetworkConnection implements Exception{}

// extension to convert firebase User to User class
extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, phoneNumber: phoneNumber, emailVerified: emailVerified);
  }
}

class AuthenticationRepository{
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthenticationRepository({CacheClient? cache, firebase_auth.FirebaseAuth? firebaseAuth}):
        _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  // User cache key: for testing only
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';
  // getter a stream of User which emit the current user when the authentication state changes
  Stream<User> get user{
    return _firebaseAuth.authStateChanges().map((firebaseUser){
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }
  // return the cached user. default to User.empty if there's no cached user
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }
  Future<String?> get idToken async {
    return _firebaseAuth.currentUser?.getIdToken();
  }
  // create new user with the provided email and password
  // throw a signup failure if an exception occurs
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).whenComplete(() => verifyEmail()).timeout(Duration(seconds: 10));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e){
      throw _getAuthenticationException(e: e, defaultException: SignUpFailure());
    }
  }
  Future<void> signUpEmailPhone({
    required String email, required String password, required String phoneNumber,
    required firebase_auth.PhoneCodeSent phoneCodeSent,
    required firebase_auth.PhoneVerificationFailed phoneVerificationFailed,
    required firebase_auth.PhoneVerificationCompleted phoneVerificationCompleted,
    required firebase_auth.PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout,
  }) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).whenComplete(() async {
        await _firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber, verificationCompleted: phoneVerificationCompleted,
            verificationFailed: phoneVerificationFailed, codeSent: phoneCodeSent,
            codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
      }).timeout(Duration(seconds: 30));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e){
      throw _getAuthenticationException(e: e, defaultException: SignUpFailure());
    }
  }

  Future<void> verifyEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: EmailVerifiedFailure());
    }
  }

  Future<void> registerPhone({
    required String phoneNumber,
    required firebase_auth.PhoneCodeSent phoneCodeSent,
    required firebase_auth.PhoneVerificationFailed phoneVerificationFailed,
    required firebase_auth.PhoneVerificationCompleted phoneVerificationCompleted,
    required firebase_auth.PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: phoneNumber,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
      ).timeout(Duration(seconds: 30));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: PhoneRegisterFailure());
    }
  }

  Future<void> verifyAndLink({required String verificationId, required String smsCode}) async {
    try {
      final firebase_auth.AuthCredential _credential = firebase_auth.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await _firebaseAuth.currentUser?.linkWithCredential(_credential).timeout(Duration(seconds: 30));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: PhoneLinkFailure());
    }
  }

  Future<void> linkCredential({required firebase_auth.PhoneAuthCredential credential}) async {
    try {
      await _firebaseAuth.currentUser?.linkWithCredential(credential).timeout(Duration(seconds: 30));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: PhoneLinkFailure());
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).timeout(Duration(seconds: 60));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: LoginFailure());
    }
  }

  Future<void> forgotPassword({required String emailAddress}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailAddress);
    } on Exception catch (e){
     throw _getAuthenticationException(e: e, defaultException: ResetPasswordEmailFailure());
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut().timeout(Duration(seconds: 10));
    } on TimeoutException {
      throw TimeoutException("Connection Timeout. Please retry!");
    } on Exception catch (e) {
      throw _getAuthenticationException(e: e, defaultException: LogoutFailure());
    }
  }
  Exception _getAuthenticationException({required Exception e, required Exception defaultException}){
    String e1 = e.toString();
    int idx1 = e1.indexOf('/');
    int idx2 = e1.indexOf(']');
    String e2 = e1.substring(idx1+1,idx2);
    print("_getAuthenticationException: $e2");
    switch(e2) {
      case 'wrong-password':
        return AuthenticationWrongPassword();
      case "user-not-found":
        return AuthenticationUserNotFound();
      case 'invalid-email':
        return AuthenticationInvalidEmail();
      case 'email-already-exists':
      case 'email-already-in-use':
        return AuthenticationEmailAlreadyExists();
      case 'invalid-credential':
        return AuthenticationInvalidCredential();
      case 'invalid-id-token':
        return AuthenticationInvalidIdToken();
      case 'invalid-password':
        return AuthenticationInvalidPassword();
      case 'invalid-phone-number':
        return AuthenticationInvalidPhoneNumber();
      case 'phone-number-already-exists':
        return AuthenticationPhoneAlreadyExists();
      case 'invalid-verification-code':
        return AuthenticationInvalidVerificationCode();
      case 'code-expired':
        return AuthenticationCodeExpired();
      case 'quota-exceeded':
        return AuthenticationQuotaExceed();
      case 'weak-password':
        return AuthenticationWeakPassword();
      case 'user-token-expired':
        return AuthenticationUserTokenExpired();
      case 'null-user':
        return AuthenticationNullUser();
      case 'credential-already-in-use':
        return AuthenticationAlreadyExists();
      case 'network-request-failed':
        return NoNetworkConnection();
      default:
        return defaultException;
    }
  }
}