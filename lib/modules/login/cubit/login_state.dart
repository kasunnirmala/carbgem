part of 'login_cubit.dart';

enum LoginStatus {
  pure, valid, invalid, submissionInProgress, submissionSuccess,
  submissionFailure, initialReady
}

const _validateStatus = <LoginStatus>{
  LoginStatus.valid, LoginStatus.initialReady
};

extension LoginStatusX on LoginStatus{
  bool get isPure => this == LoginStatus.pure;
  bool get isValid => this == LoginStatus.valid;
  bool get isInitialReady => this == LoginStatus.initialReady;
  bool get isValidated => _validateStatus.contains(this);
  bool get isInvalid => this==LoginStatus.invalid;
  bool get isSubmissionInProgress => this == LoginStatus.submissionInProgress;
  bool get isSubmissionFailure => this == LoginStatus.submissionFailure;
  bool get isSubmissionSuccess => this == LoginStatus.submissionSuccess;
}

class LoginValidationState {
  LoginStatus validate({required FormzStatus status}){
    switch(status){
      case FormzStatus.valid:
        return LoginStatus.valid;
      case FormzStatus.invalid:
        return LoginStatus.invalid;
      case FormzStatus.submissionInProgress:
        return LoginStatus.submissionInProgress;
      case FormzStatus.submissionFailure:
        return LoginStatus.submissionFailure;
      case FormzStatus.submissionSuccess:
        return LoginStatus.submissionSuccess;
      case FormzStatus.pure:
      default:
        return LoginStatus.pure;
    }
  }
}

class LoginState extends Equatable{
  final Email email;
  final Password password;
  final bool rememberLogin;
  final String errorMessage;
  // final String languageLocale;
  final LoginStatus status;
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = LoginStatus.pure,
    this.rememberLogin = true,
    this.errorMessage = "",
    // this.languageLocale = "ja",
  });

  @override
  List<Object?> get props => [email, password, status, rememberLogin, errorMessage,
    // languageLocale
  ];

  LoginState copyWith({
    Email? email, Password? password, LoginStatus? status, bool? rememberLogin,
    String? errorMessage, String? languageLocale,
  }){
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      rememberLogin: rememberLogin ?? this.rememberLogin,
      errorMessage: errorMessage ?? this.errorMessage,
      // languageLocale: languageLocale?? this.languageLocale,
    );
  }
}