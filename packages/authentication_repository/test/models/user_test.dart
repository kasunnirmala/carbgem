// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main(){
//   group('User', () {
//     const id = 'mock_id';
//     const email = 'mock_email';
//     const phone = '+81555323';
//     const emailVerified = false;
//     test('user equality',(){
//       expect(
//         User(id: id, email: email, phoneNumber: phone, name: null, emailVerified: emailVerified),
//         User(id: id, email: email, phoneNumber: phone, name: null, emailVerified: emailVerified)
//       );
//     });
//     test('isEmpty returns True for empty user', () {
//       expect(User.empty.isEmpty, isTrue);
//     });
//     test('isEmpty returns False for non-empty user', (){
//       expect(User(id: id).isEmpty, isFalse);
//     });
//     test('isNotEmpty returns False for empty user', (){
//       expect(User.empty.isNotEmpty, isFalse);
//     });
//     test('isNotEmpty returns True for non-empty user', (){
//       expect(User(id: id).isNotEmpty, isTrue);
//     });
//     test('isEmailVerified is the same as emailVerified', (){
//       expect(User(id: id, emailVerified: emailVerified).isEmailVerified, equals(emailVerified));
//     });
//     test('isPhoneRegister returns True if phone is not null', (){
//       expect(User(id: id, phoneNumber: phone).isRegisterPhone, isTrue);
//     });
//     test('isPhoneRegister returns False if phone is null', (){
//       expect(User(id: id).isRegisterPhone, isFalse);
//     });
//   });
// }