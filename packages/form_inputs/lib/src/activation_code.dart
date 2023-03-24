import 'package:formz/formz.dart';

enum ActivationValidationError {invalid}
class ActivationCode extends FormzInput<String, ActivationValidationError>{
  const ActivationCode.pure() : super.pure('');
  const ActivationCode.dirty([String value='']): super.dirty(value);

  @override
  ActivationValidationError? validator(String? value) {
    return value!="" ? null : ActivationValidationError.invalid;
  }

}
