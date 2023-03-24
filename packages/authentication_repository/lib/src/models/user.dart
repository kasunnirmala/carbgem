import 'package:equatable/equatable.dart';
// A user will consist of an email, id, phone, name, emailVerified status, phoneVerified status
// User.empty represents an unauthenticated user
class User extends Equatable {
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String id;
  final bool? emailVerified;

  const User({required this.id, this.email, this.phoneNumber, this.name, bool? emailVerified}): emailVerified =emailVerified?? false;

  @override
  // TODO: implement props
  List<Object?> get props => [email, id, name, phoneNumber, emailVerified];

  // Define empty user
  static const empty = User(id: '');

  // getter to determine whether the current user is empty
  bool get isEmpty => this == User.empty;
  // getter to determine whether the current user is not empty
  bool get isNotEmpty => this != User.empty;
  // getter to determine whether the current user has verified email or not
  bool get isEmailVerified => this.emailVerified ?? false;
  // getter to determine whether the current user has registered phone number or not
  bool get isRegisterPhone => this.phoneNumber!= null ? true : false;
}