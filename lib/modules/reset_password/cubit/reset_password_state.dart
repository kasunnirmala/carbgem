part of 'reset_password_cubit.dart';
class ResetPasswordState extends Equatable {
  final Password oldPassword;
  final Password newPassword;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  const ResetPasswordState({
    this.oldPassword = const Password.pure(),
    this.newPassword = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}