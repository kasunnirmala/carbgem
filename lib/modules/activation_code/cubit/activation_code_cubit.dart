import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'activation_code_state.dart';

class ActivationCubit extends Cubit<ActivationState>{
  final BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  ActivationCubit(this._bitteApiClient, this._authenticationRepository) : super(ActivationState());

  void passwordChanged(String value){
    final password = ActivationCode.dirty(value);
    emit(state.copyWith(activationPassword: password, status: Formz.validate([password])));
  }

  Future<void> registerActivationCode() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, errorMessage: "No user idToken is found"));
      } else {
        try {
          int statusCode = await _bitteApiClient.registerActivationCode(activationCode: state.activationPassword.value, idToken: idToken);
          emit(state.copyWith(status: FormzStatus.submissionSuccess, errorMessage: ""));
        } on Exception catch(e) {
          String errorMessage = getErrorMessage(exception: e);
          emit(state.copyWith(status: FormzStatus.submissionFailure, errorMessage: errorMessage));
        }
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: FormzStatus.submissionFailure, errorMessage: errorMessage));
    }
  }
}