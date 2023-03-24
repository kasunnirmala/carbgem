import 'dart:async';

import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';
import 'package:flutter/foundation.dart';
import 'package:carbgem/flavors.dart';

part 'firebase_flutter_state.dart';
part 'firebase_flutter_event.dart';

/// Responsible for managing the global state of the application
/// has dependency on AuthenticationRepository and subscribes to user stream
/// to emit new states in response to changes in the current user
/// Responds to incoming events and transforms into states
/// subscribes to user stream from authentication repos
/// adds a UserChanged event internally to process changes in the current user

class FirebaseFlutterBloc
    extends Bloc<FirebaseFlutterEvent, FirebaseFlutterState> {
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  late final StreamSubscription<User> _userSubscription;
  FirebaseFlutterBloc(
      {required AuthenticationRepository authenticationRepository,
      required bitte.BitteApiClient bitteApiClient})
      : _authenticationRepository = authenticationRepository,
        _bitteApiClient = bitteApiClient,
        super(F.appFlavor == Flavor.DEVELOPMENT
            ? authenticationRepository.currentUser.isEmpty
                ? FirebaseFlutterState.unauthenticated()
                : authenticationRepository.currentUser.isEmailVerified
                    ? FirebaseFlutterState.authenticated(
                        authenticationRepository.currentUser)
                    : FirebaseFlutterState.authenticatedUnverified(
                        authenticationRepository.currentUser)
            : authenticationRepository.currentUser.isEmpty
                ? FirebaseFlutterState.unauthenticated()
                : authenticationRepository.currentUser.isRegisterPhone
                    ? FirebaseFlutterState.authenticated(
                        authenticationRepository.currentUser)
                    : authenticationRepository.currentUser.isEmailVerified
                        ? FirebaseFlutterState.authenticatedPhoneUnregistered(
                            authenticationRepository.currentUser)
                        : FirebaseFlutterState.authenticatedUnverified(
                            authenticationRepository.currentUser)) {
    _userSubscription = _authenticationRepository.user.listen(_onUserChanged);
  }

  void _onUserChanged(User user) => add(FirebaseFlutterUserChanged(user));

  FirebaseFlutterState _mapUserChangedToState(
      FirebaseFlutterUserChanged event, FirebaseFlutterState state) {
    if (F.appFlavor == Flavor.DEVELOPMENT) {
      return event.user.isEmpty
          ? FirebaseFlutterState.unauthenticated()
          : event.user.isEmailVerified
              ? FirebaseFlutterState.authenticated(event.user)
              : FirebaseFlutterState.authenticatedUnverified(event.user);
    } else {
      return event.user.isEmpty
          ? FirebaseFlutterState.unauthenticated()
          : event.user.isRegisterPhone
              ? FirebaseFlutterState.authenticated(event.user)
              : event.user.isEmailVerified
                  ? FirebaseFlutterState.authenticatedPhoneUnregistered(
                      event.user)
                  : FirebaseFlutterState.authenticatedUnverified(event.user);
    }
  }

  @override
  Stream<FirebaseFlutterState> mapEventToState(
      FirebaseFlutterEvent event) async* {
    if (event is FirebaseFlutterUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is FirebaseFlutterLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
