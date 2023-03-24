import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/services/secure_storage_service.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

part 'login_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class LoginCubit extends Cubit<LoginState>{
  final AuthenticationRepository _authenticationRepository;
  // TODO: delete bitteapiclient afterward
  final BitteApiClient _bitteApiClient;
  final SecureStorage _storage = SecureStorage();
  LoginCubit(this._authenticationRepository, this._bitteApiClient) : super(LoginState()){
    getStorageData();
  }

  Future<void> getStorageData() async {
    String email = await _storage.readSecureData(key: 'email');
    String password = await _storage.readSecureData(key: 'password');
    emit(state.copyWith(
      email: (email=="") ? Email.pure() : Email.dirty(email),
      password: (password=="") ? Password.pure() : Password.dirty(password),
      status: (email=="") ? LoginStatus.pure : LoginStatus.initialReady
    ));
  }

  Future<void> cleanUpStorageData() async {
    if (state.rememberLogin){
      await _storage.writeSecureData(key: 'email', value: state.email.value);
      await _storage.writeSecureData(key: 'password', value: state.password.value);
    } else {
      await _storage.deleteSecureData(key: 'email');
      await _storage.deleteSecureData(key: 'password');
    }
  }

  void emailChanged(String value){
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: LoginValidationState().validate(status: Formz.validate([email, state.password])),
    ));
  }
  
  void passwordChanged(String value){
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: LoginValidationState().validate(status: Formz.validate([state.email, password])),
    ));
  }

  void rememberLoginChanged(bool value){
    emit(state.copyWith(
      rememberLogin: value
    ));
  }

  // void changeLocale(String value, BuildContext context){
  //   emit(state.copyWith(languageLocale: value));
  //   context.setLocale(Locale(state.languageLocale));
  // }

  Future<String> logIn() async {
    if (!state.status.isValidated) return "";
    emit(state.copyWith(status: LoginStatus.submissionInProgress));
    try{
      await _authenticationRepository.logIn(email: state.email.value, password: state.password.value);
      await cleanUpStorageData();
      emit(state.copyWith(status: LoginStatus.submissionSuccess, errorMessage: ""));
      return state.errorMessage;
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: LoginStatus.submissionFailure, errorMessage: errorMessage));
      return state.errorMessage;
    }
  }

}