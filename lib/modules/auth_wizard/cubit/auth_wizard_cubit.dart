import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/basic_home/cubit/basic_home_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_wizard_state.dart';

class AuthWizardCubit extends Cubit<AuthWizardState> {
  final BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  AuthWizardCubit(this._bitteApiClient, this._authenticationRepository)
      : super(AuthWizardState());

  void initLoginStep() {
    emit(state.copyWith(activeStep: 0, pageTitle: "Label_Title_login"));
  }

  void registerStep() {
    emit(state.copyWith(activeStep: 1, pageTitle: "Label_Title_signUp"));
  }

  void messageStep() {
    emit(state.copyWith(activeStep: 2));
  }

  void loginStep() {
    emit(state.copyWith(activeStep: 3, pageTitle: "Label_Title_login"));
  }

  void otpStep() {
    emit(state.copyWith(activeStep: 4));
  }

  Widget getView(int activeState) {
    switch (activeState) {
      case 0:
      case 3:
        return LoginPage();
      case 1:
        return SignUpPage();
      default:
        return LoginPage();
    }
  }

  Future<bool> onBackClicked(int activeState) {
    onStateClicked(activeState - 1);
    return Future<bool>.value(false);
  }

  void onStateClicked(int activeState) {
    switch (activeState) {
      case 0:
        initLoginStep();
        break;
      case 1:
        registerStep();
        break;
      case 2:
        messageStep();
        break;
      case 3:
        loginStep();
        break;
      case 4:
        otpStep();
        break;
    }
  }
}
