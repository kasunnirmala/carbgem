import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:bloc/bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'phone_register_state.dart';

class PhoneRegisterCubit extends Cubit<PhoneRegisterState>{
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  String errorMsg = "";
  PhoneRegisterCubit(this._authenticationRepository, this._bitteApiClient) : super(PhoneRegisterState());

  void smsChanged(String value) {
    final sms = SmsCode.dirty(value);
    emit(state.copyWith(smsCode: sms, status: FormzStatusPhone.submissionCodePure));
  }

  Future<void> registerPhone() async {
    final _phoneVerificationCompleted = (firebase_auth.PhoneAuthCredential credential) async {
      await _authenticationRepository.linkCredential(credential: credential);
      emit(state.copyWith(status: FormzStatusPhone.submissionCodeSuccess));
      await _authenticationRepository.logOut();
    };
    final _phoneVerificationFailed = (firebase_auth.FirebaseAuthException authException) {
      this.errorMsg = authException.message ?? "";
      emit(state.copyWith(status: FormzStatusPhone.submissionCodeFailure, errorMessage: authException.message ?? ''));
    };
    final _phoneAutoRetrievalTimeout = (String verId) {
      emit(state.copyWith(status: FormzStatusPhone.submissionCodeFailure, verId: verId, errorMessage: 'Time Out Error'));
    };
    final _phoneCodeSent = (String verId, int? forceResent){
      emit(state.copyWith(status: FormzStatusPhone.submissionCodePure, verId: verId));
    };
    emit(state.copyWith(status: FormzStatusPhone.submissionInProgress));
    try{
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null){
        emit(state.copyWith(errorMessage: 'Fetching ID Token error', status: FormzStatusPhone.submissionCodeFailure));
      } else{
        bitte.User user = await _bitteApiClient.fetchUser(idToken: idToken);
        await _authenticationRepository.registerPhone(
            phoneNumber: user.phoneNumber, phoneCodeSent: _phoneCodeSent,
            phoneVerificationFailed: _phoneVerificationFailed, phoneVerificationCompleted: _phoneVerificationCompleted,
            phoneCodeAutoRetrievalTimeout: _phoneAutoRetrievalTimeout);
      }
    } on Exception catch (e){
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: FormzStatusPhone.submissionFailure, errorMessage: errorMessage));
    }
  }
  Future<void> verifyAndLink() async {
    emit(state.copyWith(status: FormzStatusPhone.submissionCodeInProgress));
    try{
      await _authenticationRepository.verifyAndLink(verificationId: state.verId, smsCode: state.smsCode.value);
      emit(state.copyWith(status: FormzStatusPhone.submissionCodeSuccess));
      // await _authenticationRepository.logOut();
    } on Exception {
      emit(state.copyWith(status: FormzStatusPhone.submissionCodeFailure));
    }
  }
  Future<void> logOut() async {
    await _authenticationRepository.logOut();
  }
}