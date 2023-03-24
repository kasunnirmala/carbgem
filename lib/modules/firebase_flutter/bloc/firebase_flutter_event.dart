/// Event has 2 subclasses:
/// UserChanged: notifies the bloc that the current user has changed
/// LogoutRequested: notifies the bloc that the current user has requested to be logged out
part of 'firebase_flutter_bloc.dart';

abstract class FirebaseFlutterEvent extends Equatable{
  const FirebaseFlutterEvent();

  @override
  List<Object> get props => [];
}

class FirebaseFlutterLogoutRequested extends FirebaseFlutterEvent {}

class FirebaseFlutterUserChanged extends FirebaseFlutterEvent{
  final User user;
  @visibleForTesting
  const FirebaseFlutterUserChanged(this.user);
  @override
  List<Object> get props => [user];
}