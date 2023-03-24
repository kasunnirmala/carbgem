import 'package:carbgem/modules/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state.status == FormzStatus.submissionSuccess) {
          getAlert(
            context: context,
            title: 'Label_forgotPassword_emailSent'.tr(),
            msg: 'Label_forgotPassword_checkEmail'.tr(),
            clickFunction: false,
            okButton: false,
          );
        }
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
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
          // color: Colors.white,
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _EmailInputForm(),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ForgotPasswordCubit>().forgotPassword();
                        },
                        child: (state.status == FormzStatus.submissionInProgress)
                            ? CircularProgressIndicator()
                            : Text("Label_forgotPassword_button_resendEmail".tr()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmailInputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return Focus(child: Builder(builder: (BuildContext context) {
            final bool hasFocus = Focus.of(context).hasFocus;
            return TextField(
              key: const Key('email_input_resendForm'),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Label_forgotPassword_inputEmail'.tr(),
                helperText: '',
                errorText: (!hasFocus && state.email.invalid)
                    ? 'Label_forgotPassword_invalidEmail'.tr()
                    : null,
              ),
              onChanged: (value) {
                context.read<ForgotPasswordCubit>().emailChanged(value);
              },
            );
          }));
        });
  }
}
