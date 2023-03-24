import 'package:bitte_api/bitte_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';


part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  SignUpCubit(this._authenticationRepository, this._bitteApiClient):super(SignUpState()){
    changeSelectCountry(value: "109");
    changeSelectArea(value: "1880");
  }

  void emailChanged(String value){
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: SignUpValidationState().validate(status: Formz.validate([email, state.password, state.confirmedPassword, state.phoneNumber])),
    ));
  }

  void passwordChanged(String value){
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(password: password.value, value: state.confirmedPassword.value);
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: SignUpValidationState().validate(status: Formz.validate([state.email, password, confirmedPassword, state.phoneNumber])),
    ));
  }

  void confirmedPasswordChanged(String value){
    final confirmedPassword = ConfirmedPassword.dirty(password: state.password.value, value: value);
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: SignUpValidationState().validate(status: Formz.validate([state.email, state.password, confirmedPassword, state.phoneNumber])),
    ));
  }

  void phoneNumberChanged(String value){
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: SignUpValidationState().validate(status: Formz.validate([state.email, state.password, state.confirmedPassword, phoneNumber])),
    ));
  }

  Future<String> signUpFirst() async {
    if (state.status != SignUpStatus.valid) return "";
    emit(state.copyWith(status: SignUpStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(email: state.email.value, password: state.password.value);
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(errorMessage: 'Fetching ID Token Failure', status: SignUpStatus.submissionFailure));
      } else {
        await _bitteApiClient.registerUser(
          idToken: idToken, password: state.password.value, countryId: state.selectCountryId,
          hospitalId: state.selectHospitalId, userType: '${state.selectUserType.index}', phoneNumber: state.phoneNumber.value,);
        emit(state.copyWith(status: SignUpStatus.submissionSuccess, errorMessage: ""));
        await _authenticationRepository.logOut();
      }
      return state.errorMessage;
    } on Exception catch(e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(errorMessage: errorMessage, status: SignUpStatus.submissionFailure));
      return state.errorMessage;
    }
  }

  void changeUserType({required SigningCharacter value}){
    emit(state.copyWith(selectUserType: value,
      status: SignUpValidationState().validate(status: Formz.validate([state.email, state.password, state.confirmedPassword, state.phoneNumber])),));
  }
  Future<void> changeSelectArea({required String value}) async {
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      List<HospitalAPI> hospitalList = await _bitteApiClient.getHospitalListAPI(areaId: value);
      emit(state.copyWith(
        selectAreaId: value, hospitalList: (hospitalList.length>0) ? hospitalList : [HospitalAPI.empty], status: SignUpStatus.success,
      ));
    } on Exception catch (e){
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: SignUpStatus.submissionFailure, errorMessage: errorMessage));
    }
  }
  void changeSelectHospital({required String value}) {
    emit(state.copyWith(selectHospitalId: value,
      status: SignUpValidationState().validate(status: Formz.validate([state.email, state.password, state.confirmedPassword, state.phoneNumber])),));
  }
  Future<void> changeSelectCountry({required String value}) async {
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      List<AreaAPI> areaList = await _bitteApiClient.getAreaListAPI(countryId: value);
      areaList.sort((a,b) => int.parse(a.areaId).compareTo(int.parse(b.areaId)));
      emit(state.copyWith(
        selectCountryId: value, areaList: (areaList.length>0) ? areaList : [AreaAPI.empty],
        selectAreaId: (areaList.length>0) ? areaList[0].areaId : "", status: SignUpStatus.success,
      ));
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: SignUpStatus.submissionFailure, errorMessage: errorMessage));
    }
  }
  void changeLocale(String value, BuildContext context){
    emit(state.copyWith(languageLocale: value));
    context.setLocale(Locale(state.languageLocale));
  }
}