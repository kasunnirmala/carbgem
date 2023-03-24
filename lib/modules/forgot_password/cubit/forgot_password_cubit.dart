import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;

  ForgotPasswordCubit(this._authenticationRepository, this._bitteApiClient) : super(ForgotPasswordState());
  void emailChanged(String value){
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email, status: FormzStatus.valid,
    ));
  }
  Future<void> forgotPassword() async {
    if (state.status == FormzStatus.invalid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.forgotPassword(emailAddress: state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (e){
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: FormzStatus.submissionFailure, error: errorMessage));
    }
  }
}