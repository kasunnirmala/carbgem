part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable{
  final Email email;
  final FormzStatus status;
  final String errorMessage;

  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = "",
  });

  @override
  // TODO: implement props
  List<Object?> get props => [email, status, errorMessage];

  ForgotPasswordState copyWith({Email? email, FormzStatus? status, String? error}) {
    return ForgotPasswordState(email: email ?? this.email, status : status ?? this.status, errorMessage: error?? this.errorMessage);
  }
}