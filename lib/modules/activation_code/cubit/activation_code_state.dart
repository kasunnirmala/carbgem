part of 'activation_code_cubit.dart';

class ActivationState extends Equatable {
  final ActivationCode activationPassword;
  final FormzStatus status;
  final String errorMessage;
  const ActivationState({
    this.activationPassword = const ActivationCode.pure(),
    this.errorMessage = "",
    this.status = FormzStatus.pure});

  @override
  List<Object?> get props => [activationPassword, status, errorMessage];

  ActivationState copyWith({ActivationCode? activationPassword, FormzStatus? status, String? errorMessage}) {
    return ActivationState(
        activationPassword: activationPassword ?? this.activationPassword,
        status: status ?? this.status, errorMessage: errorMessage?? this.errorMessage);
  }
}