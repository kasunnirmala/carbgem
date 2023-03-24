import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_wizard_state.dart';

class AuthWizardCubit extends Cubit<AuthWizardState> {
  final BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  AuthWizardCubit(this._bitteApiClient, this._authenticationRepository)
      : super(AuthWizardState());

  void initLoginStep() {
    emit(state.copyWith(activeStep: 0));
  }

  void registerStep() {
    emit(state.copyWith(activeStep: 1));
  }

  void messageStep() {
    emit(state.copyWith(activeStep: 2));
  }

  void loginStep() {
    emit(state.copyWith(activeStep: 3));
  }

  void otpStep() {
    emit(state.copyWith(activeStep: 4));
  }
}
