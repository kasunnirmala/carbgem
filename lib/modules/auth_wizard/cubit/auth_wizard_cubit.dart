import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
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
}
