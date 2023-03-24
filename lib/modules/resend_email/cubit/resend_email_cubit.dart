import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

part 'resend_email_state.dart';

class ResendEmailCubit extends Cubit<ResendEmailState>{
  final AuthenticationRepository _authenticationRepository;
  ResendEmailCubit(this._authenticationRepository) : super(ResendEmailState.resendStart) ;

  Future<void> resendEmail() async {
    emit(ResendEmailState.resendInProgress);
    try{
      await _authenticationRepository.verifyEmail();
      emit(ResendEmailState.resendComplete);
    } on Exception {
      emit(ResendEmailState.resendFailure);
    }
  }

  Future<void> logOut() async {
    emit(ResendEmailState.resendInProgress);
    try {
      await _authenticationRepository.logOut();
      emit(ResendEmailState.resendComplete);
    } on Exception {
      emit(ResendEmailState.resendFailure);
    }
  }
}