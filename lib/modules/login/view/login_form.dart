import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/auth_wizard/auth_wizard.dart';
import 'package:carbgem/modules/forgot_password/forgot_password.dart';
import 'package:carbgem/modules/sign_up/sign_up.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // context.setLocale(Locale("ja"));
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()

            /// It's a bottom notification.If it's not needed, delete this.
            ..showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/CarbGeM_wide.png',
                  height: 120,
                ),
              ),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(0, 3))
                          ]),
                      child: Column(
                        children: [
                          // SizedBox(height: 10,),
                          // _LanguageSelector(),
                          SizedBox(
                            height: 20,
                          ),
                          _EmailInput(),
                          SizedBox(
                            height: 10,
                          ),
                          _PasswordInput(),
                          _RememberLoginCheckbox(),
                          SizedBox(
                            height: 10,
                          ),
                          _LoginButton(),
                          SizedBox(
                            height: 10,
                          ),
                          _SignUpButton(),
                          _ForgotPasswordButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Focus(
              child: Builder(builder: (BuildContext context) {
                final bool hasFocus = Focus.of(context).hasFocus;
                return TextField(
                  style: Theme.of(context).textTheme.bodyText1,
                  key: const Key('loginForm_emailInput_textField'),
                  controller: (state.status.isInitialReady)
                      ? TextEditingController(text: state.email.value)
                      : null,
                  onChanged: (email) =>
                      context.read<LoginCubit>().emailChanged(email),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'email'.tr(),
                      helperText: '',
                      errorText: (!hasFocus && state.email.invalid)
                          ? 'invalid_email'.tr()
                          : null),
                );
              }),
            ));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Focus(
            child: Builder(builder: (BuildContext context) {
              final bool hasPasswordFocus = Focus.of(context).hasFocus;
              return TextField(
                style: Theme.of(context).textTheme.bodyText1,
                key: const Key('loginForm_passwordInput_textField'),
                controller: (state.status.isInitialReady)
                    ? TextEditingController(text: state.password.value)
                    : null,
                onChanged: (password) =>
                    context.read<LoginCubit>().passwordChanged(password),
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'password'.tr(),
                  helperText: '',
                  errorText: (!hasPasswordFocus && state.password.invalid)
                      ? 'invalid_password'.tr()
                      : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatefulWidget {
  @override
  __LoginButtonState createState() => __LoginButtonState();
}

class __LoginButtonState extends State<_LoginButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return RoundedLoadingButton(
          color: Theme.of(context).colorScheme.secondary,
          controller: _btnController,
          key: const Key('loginForm_logIn_button'),
          onPressed: state.status.isValidated
              ? () async {
                  String errorMessage =
                      await context.read<LoginCubit>().logIn();
                  if (errorMessage != "") {
                    _btnController.reset();
                    if (errorMessage == "No Internet Connection Detects") {
                      warningAlertDialog(
                        context: context,
                        title: 'warning_alert_title'.tr(),
                        msg: 'noInternetConnection'.tr(),
                      );
                      context.read<LoginCubit>().emit(state.copyWith(
                          status: LoginStatus.valid, errorMessage: ""));
                    } else if (errorMessage == "Wrong Password") {
                      warningAlertDialog(
                        context: context,
                        title: 'warning_alert_title'.tr(),
                        msg: 'passwordNotMatch'.tr(),
                      );
                    } else if (errorMessage == "Log In Failure") {
                      warningAlertDialog(
                        context: context,
                        title: 'warning_alert_title'.tr(),
                        msg: "warning_alert_unknown_failure".tr(),
                      );
                    }
                  }
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login),
              SizedBox(
                width: 20,
              ),
              Text('login'.tr()),
            ],
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      // buildWhen: (previous, current) =>
      //     previous.languageLocale != current.languageLocale,
      builder: (context, state) => TextButton(
        key: const Key("loginForm_createAccount_button"),
        // onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        onPressed: () => context.read<AuthWizardCubit>().registerStep(),
        child: Text('register'.tr()),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      // buildWhen: (previous, current) =>
      //     previous.languageLocale != current.languageLocale,
      builder: (context, state) => TextButton(
        key: const Key("loginForm_forgotPassword_button"),
        onPressed: () =>
            Navigator.of(context).push<void>(ForgotPasswordPage.route()),
        child: Text('forgot_pw'.tr()),
      ),
    );
  }
}

class _RememberLoginCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.rememberLogin != current.rememberLogin,
      builder: (context, state) {
        return Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Checkbox(
              value: state.rememberLogin,
              onChanged: (value) =>
                  context.read<LoginCubit>().rememberLoginChanged(value!),
//               side: BorderSide(width: 1, color: Theme.of(context).accentColor),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              "remember_me".tr(),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        );
      },
    );
  }
}
