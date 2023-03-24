part of 'auth_wizard_cubit.dart';

class AuthWizardState extends Equatable {
  final int activeStep;
  final String pageTitle;
  const AuthWizardState(
      {this.activeStep = 0, this.pageTitle = "Label_Title_login"});

  @override
  List<Object?> get props => [activeStep];

  AuthWizardState copyWith({int? activeStep, String? pageTitle}) {
    return AuthWizardState(
        activeStep: activeStep ?? this.activeStep,
        pageTitle: pageTitle ?? this.pageTitle);
  }
}
