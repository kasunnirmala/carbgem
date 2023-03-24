import 'package:formz/formz.dart';

enum SmsValidationError {invalid}

class SmsCode extends FormzInput<String, SmsValidationError>{
  const SmsCode.pure(): super.pure('');
  const SmsCode.dirty([String value = '']): super.dirty(value);

  @override
  SmsValidationError? validator(String? value) {
    return null;
  }
}