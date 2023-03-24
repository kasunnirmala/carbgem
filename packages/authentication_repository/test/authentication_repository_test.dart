// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:cache/cache.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
//
// const _mockFirebaseUid = 'mock_uid';
// const _mockFirebaseEmail = 'mock_email';
// const _mockFirebasePhone = 'mock_phone';
// const _emailVerified = true;
//
// class MockCacheClient extends Mock implements CacheClient{}
//
// class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
//
// class MockFirebaseUser extends Mock implements firebase_auth.User {}
//
// class MockUserCredential extends Mock implements firebase_auth.UserCredential {}
//
// class MockPhoneCredential extends Mock implements firebase_auth.PhoneAuthCredential {}
//
// class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}
//
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
//     if (call.method == 'Firebase#initializeCore') {
//       return [{
//         'name': defaultFirebaseAppName, 'options': {
//           'apiKey': '123', "appId":'123', 'messagingSenderId': '123','projectId': '123',
//         }, 'pluginConstants': const <String, String>{},
//       }];
//     }
//     if (call.method == 'Firebase#initializeApp') {
//       final arguments = call.arguments as Map<String, dynamic>;
//       return <String, dynamic>{
//         'name': arguments['appName'], 'options': arguments['options'], 'pluginConstants': const <String, String>{},
//       };
//     }
//     return null;
//   });
//   TestWidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//   const email = 'test@gmail.com';
//   const password = 't0ps3cret42';
//   const verificationId = 'mockVerificationId';
//   const smsCode = '53634';
//   const user = User(id: _mockFirebaseUid, email: _mockFirebaseEmail, phoneNumber: _mockFirebasePhone, emailVerified: _emailVerified);
//   firebase_auth.AuthCredential credential = FakeAuthCredential();
//   verifyComplete(_){}
//   verifyFailed(_){}
//   phoneCodeSent(_x,_y){}
//   codeRetrieve(_){}
//
//   group('Authentication Repository', (){
//     late CacheClient cache;
//     late firebase_auth.FirebaseAuth firebaseAuth;
//     late AuthenticationRepository authenticationRepository;
//
//     setUpAll((){
//       registerFallbackValue<firebase_auth.AuthCredential>(FakeAuthCredential());
//     });
//
//     setUp((){
//       cache = MockCacheClient();
//       firebaseAuth = MockFirebaseAuth();
//       authenticationRepository = AuthenticationRepository(cache: cache, firebaseAuth: firebaseAuth);
//     });
//
//     test('creates FirebaseAuth instance internally when not injected', () {
//       expect(() => AuthenticationRepository(), isNot(throwsException));
//     });
//
//     group('signUp', (){
//       setUp((){
//         when(() => firebaseAuth.createUserWithEmailAndPassword(
//             email: any(named: 'email'), password: any(named: 'password')
//         )).thenAnswer((_) => Future.value(MockUserCredential()));
//         when(() => firebaseAuth.currentUser?.sendEmailVerification()).thenAnswer((_){});
//       });
//
//       test('calls signUp', () async {
//         await authenticationRepository.signUp(email: email, password: password);
//         verify(() => firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
//       });
//
//       test('succeeds when createUserWithEmailAndPassword succeeds', () async{
//         expect(authenticationRepository.signUp(email: email, password: password), completes);
//       });
//
//       test('throw SignUpFailure when createUserWithEmailAndPassword throw', () async {
//         when(() => firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).thenThrow(firebase_auth.FirebaseAuthException(code: 'test-error'));
//         expect(authenticationRepository.signUp(email: email, password: password), throwsA(isA<SignUpFailure>()));
//       });
//     });
//
//     group('verifyEmail', (){
//       setUp((){
//         when(() => firebaseAuth.currentUser?.sendEmailVerification()).thenAnswer((_){});
//       });
//       test('calls verifyEmail', () async {
//         await authenticationRepository.verifyEmail();
//         verify(() => firebaseAuth.currentUser?.sendEmailVerification()).called(1);
//       });
//       test('succeeds when sendEmailVerification succeeds', () async {
//         expect(authenticationRepository.verifyEmail(), completes);
//       });
//       test('throw EmailVerifiedFailure when sendEmailVerification throw', () async {
//         when(() => firebaseAuth.currentUser?.sendEmailVerification()).thenThrow(Exception());
//         expect(authenticationRepository.verifyEmail(), throwsA(isA<EmailVerifiedFailure>()));
//       });
//     });
//
//     group('registerPhone', (){
//       setUp((){
//         when(() => firebaseAuth.verifyPhoneNumber(
//             phoneNumber: _mockFirebasePhone, verificationCompleted: any(named: 'verificationCompleted'),
//             verificationFailed: any(named: 'verificationFailed'), codeSent: any(named: 'codeSent'),
//             codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'))).thenAnswer((_) => Future.value(MockPhoneCredential()));
//       });
//       test('calls registerPhone', () async {
//         await authenticationRepository.registerPhone(
//             phoneNumber: _mockFirebasePhone, phoneCodeSent: phoneCodeSent,
//             phoneVerificationFailed: verifyFailed, phoneVerificationCompleted: verifyComplete,
//             phoneCodeAutoRetrievalTimeout: codeRetrieve);
//         verify(() => firebaseAuth.verifyPhoneNumber(
//             phoneNumber: _mockFirebasePhone, verificationCompleted: verifyComplete, verificationFailed: verifyFailed,
//             codeSent: phoneCodeSent, codeAutoRetrievalTimeout: codeRetrieve)).called(1);
//       });
//       test('succeeds when registerPhone succeeds', () async {
//         expect(authenticationRepository.registerPhone(
//             phoneNumber: _mockFirebasePhone, phoneCodeSent: phoneCodeSent,
//             phoneVerificationFailed: verifyFailed, phoneVerificationCompleted: verifyComplete,
//             phoneCodeAutoRetrievalTimeout: codeRetrieve), completes);
//       });
//       test('throw PhoneRegisterFailure when registerPhone throw', () async {
//         when(() => firebaseAuth.verifyPhoneNumber(
//             phoneNumber: _mockFirebasePhone, verificationCompleted: verifyComplete, verificationFailed: verifyFailed,
//             codeSent: phoneCodeSent, codeAutoRetrievalTimeout: codeRetrieve)).thenThrow(Exception());
//         expect(authenticationRepository.registerPhone(
//             phoneNumber: _mockFirebasePhone, phoneCodeSent: phoneCodeSent,
//             phoneVerificationFailed: verifyFailed, phoneVerificationCompleted: verifyComplete,
//             phoneCodeAutoRetrievalTimeout: codeRetrieve), throwsA(isA<PhoneRegisterFailure>()));
//       });
//     });
//     group('verifyAndLink', (){
//       setUp((){
//         when(() => firebaseAuth.currentUser?.linkWithCredential(any(named: 'credential'))).thenAnswer((_) {});
//       });
//       test('calls verifyAndLink', () async {
//         await authenticationRepository.verifyAndLink(verificationId: verificationId, smsCode: smsCode);
//         verify(() => firebaseAuth.currentUser?.linkWithCredential(credential)).called(1);
//       });
//       test("succeeds when verifyAndLink succeeds", () async {
//         expect(authenticationRepository.verifyAndLink(verificationId: verificationId, smsCode: smsCode), completes);
//       });
//       test('throw PhoneLinkFailure when verifyAndLink throw', () async {
//         when(() => firebaseAuth.currentUser?.linkWithCredential(credential)).thenThrow(Exception());
//         expect(authenticationRepository.verifyAndLink(verificationId: verificationId, smsCode: smsCode), throwsA(isA<PhoneLinkFailure>()));
//       });
//     });
//     group('logIn',(){
//       setUp((){
//         when(() => firebaseAuth.signInWithEmailAndPassword(
//             email: any(named: 'email'), password: any(named: 'password'
//         ))).thenAnswer((_) => Future.value(MockUserCredential()));
//       });
//       test('calls logIn', () async {
//         await authenticationRepository.logIn(email: email, password: password);
//         verify(() => firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).called(1);
//       });
//       test('succeeds when login succeeds', () async {
//         expect(authenticationRepository.logIn(email: email, password: password), completes);
//       });
//       test('throw LoginFailure when login throws', () async {
//         when(() => firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).thenThrow(Exception());
//         expect(authenticationRepository.logIn(email: email, password: password), throwsA(isA<LoginFailure>()));
//       });
//     });
//     group('logOut', (){
//       test('call logOut', () async {
//         when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
//         await authenticationRepository.logOut();
//         verify(() => firebaseAuth.signOut()).called(1);
//       });
//       test('throws logOutFailure if logOut throws', () async{
//         when(() => firebaseAuth.signOut()).thenThrow(Exception());
//         expect(authenticationRepository.logOut(), throwsA(isA<LogoutFailure>()));
//       });
//     });
//     group('user', () {
//       test('emits User.empty when firebase user is null', () async{
//         when(() => firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));
//         await expectLater(authenticationRepository.user, emitsInOrder(<User>[User.empty]));
//       });
//       test('emits User when firebase user is not null',() async {
//         final firebaseUser = MockFirebaseUser();
//         when(() => firebaseUser.uid).thenReturn(_mockFirebaseUid);
//         when(() => firebaseUser.email).thenReturn(_mockFirebaseEmail);
//         when(() => firebaseUser.phoneNumber).thenReturn(_mockFirebasePhone);
//         when(() => firebaseUser.emailVerified).thenReturn(_emailVerified);
//         when(() => firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(firebaseUser));
//         await expectLater(authenticationRepository.user, emitsInOrder(<User>[user]));
//         verify(() => cache.write(key: AuthenticationRepository.userCacheKey, value: user)).called(1);
//       });
//     });
//     group('currentUser', () {
//       test('return User.empty when cached user is null', () {
//         when(() => cache.read(key: AuthenticationRepository.userCacheKey)).thenReturn(null);
//         expect(authenticationRepository.currentUser, equals(User.empty));
//       });
//       test('return User when cached user is not null', () async {
//         when(() => cache.read(key: AuthenticationRepository.userCacheKey)).thenReturn(user);
//         expect(authenticationRepository.currentUser, equals(user));
//       });
//     });
//   });
// }