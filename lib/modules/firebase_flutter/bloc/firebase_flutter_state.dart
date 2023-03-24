part of 'firebase_flutter_bloc.dart';

enum FirebaseFlutterStatus {
  unauthenticated, authenticatedUnverified, authenticatedPhoneUnregistered, authenticated
}
class FirebaseFlutterState extends Equatable{
  final FirebaseFlutterStatus status;
  final User user;

  const FirebaseFlutterState._({required this.status, this.user = User.empty});

  const FirebaseFlutterState.unauthenticated() : this._(status: FirebaseFlutterStatus.unauthenticated);
  const FirebaseFlutterState.authenticatedUnverified(User user): this._(status: FirebaseFlutterStatus.authenticatedUnverified, user: user);
  const FirebaseFlutterState.authenticatedPhoneUnregistered(User user): this._(status: FirebaseFlutterStatus.authenticatedPhoneUnregistered, user: user);
  const FirebaseFlutterState.authenticated(User user): this._(status: FirebaseFlutterStatus.authenticated, user: user);

  @override
  List<Object?> get props => [status, user];
}