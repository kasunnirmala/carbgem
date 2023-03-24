part of 'phone_register_cubit.dart';

enum FormzStatusPhone {
  pure, valid, invalid, submissionInProgress, submissionSuccess,
  submissionFailure, submissionCodePure, submissionCodeInProgress,
  submissionCodeSuccess, submissionCodeFailure
}
const _validatedFormzStatuses = <FormzStatusPhone>{
  FormzStatusPhone.valid,
  FormzStatusPhone.submissionInProgress,
  FormzStatusPhone.submissionSuccess,
  FormzStatusPhone.submissionFailure,
  FormzStatusPhone.submissionCodePure,
  FormzStatusPhone.submissionCodeInProgress,
  FormzStatusPhone.submissionCodeSuccess,
  FormzStatusPhone.submissionCodeFailure
};

const _validateCode = <FormzStatusPhone>{
  FormzStatusPhone.submissionCodePure,
  FormzStatusPhone.submissionCodeInProgress,
  FormzStatusPhone.submissionCodeSuccess,
  FormzStatusPhone.submissionCodeFailure
};

const _validateFailure = <FormzStatusPhone>{
  FormzStatusPhone.submissionCodeFailure,
  FormzStatusPhone.submissionFailure
};

extension FormzStatusPhoneX on FormzStatusPhone {
  /// Indicates whether the form is untouched.
  bool get isPure => this == FormzStatusPhone.pure;

  /// Indicates whether the form is completely validated.
  bool get isValid => this == FormzStatusPhone.valid;

  /// Indicates whether the form has been validated successfully.
  /// This means the [FormzStatus] is either:
  /// * `FormzStatus.valid`
  /// * `FormzStatus.submissionInProgress`
  /// * `FormzStatus.submissionSuccess`
  /// * `FormzStatus.submissionFailure`
  bool get isValidated => _validatedFormzStatuses.contains(this);

  /// Indicates whether the form contains one or more invalid inputs.
  bool get isInvalid => this == FormzStatusPhone.invalid;

  /// Indicates whether the form is in the process of being submitted.
  bool get isSubmissionInProgress => this == FormzStatusPhone.submissionInProgress;

  /// Indicates whether the form has been submitted successfully.
  bool get isSubmissionSuccess => this == FormzStatusPhone.submissionSuccess;

  /// Indicates whether the form submission failed.
  bool get isCodeForm => _validateCode.contains(this);

  bool get isSubmissionFailure => _validateFailure.contains(this);
}

class PhoneValidationState {
  FormzStatusPhone validate({required FormzStatus status}){
    switch (status){
      case FormzStatus.valid:
        return FormzStatusPhone.valid;
      case FormzStatus.invalid:
        return FormzStatusPhone.invalid;
      case FormzStatus.submissionInProgress:
        return FormzStatusPhone.submissionInProgress;
      case FormzStatus.submissionSuccess:
        return FormzStatusPhone.submissionSuccess;
      case FormzStatus.submissionFailure:
        return FormzStatusPhone.submissionFailure;
      case FormzStatus.pure:
      default:
        return FormzStatusPhone.pure;
    }
  }
}

class PhoneRegisterState extends Equatable {
  final FormzStatusPhone status;
  final SmsCode smsCode;
  final String verId;
  final String errorMessage;
  const PhoneRegisterState({
    this.smsCode = const SmsCode.pure(),
    this.status = FormzStatusPhone.pure,
    this.verId = "", this.errorMessage = ''});

  @override
  // TODO: implement props
  List<Object?> get props => [smsCode, status, verId];

  PhoneRegisterState copyWith({SmsCode? smsCode, FormzStatusPhone? status, String? verId, String? errorMessage}){
    return PhoneRegisterState(smsCode: smsCode ?? this.smsCode, status: status ?? this.status,
        verId: verId ?? this.verId, errorMessage: errorMessage ?? this.errorMessage);
  }
}