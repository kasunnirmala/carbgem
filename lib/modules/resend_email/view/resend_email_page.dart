import 'package:authentication_repository/authentication_repository.dart';
import 'package:carbgem/modules/resend_email/cubit/resend_email_cubit.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ResendEmailPage extends StatelessWidget {
  const ResendEmailPage({Key? key, this.isOnlyWidget = false})
      : super(key: key);
  final bool isOnlyWidget;
  static Page page() => MaterialPage<void>(child: ResendEmailPage());
  static Route route() {
    return MaterialPageRoute(builder: (_) => ResendEmailPage());
  }

  @override
  Widget build(BuildContext context) {
    return isOnlyWidget
        ? BlocProvider(
            create: (_) =>
                ResendEmailCubit(context.read<AuthenticationRepository>()),
            child: ResendEmailForm(),
          )
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.all(10),
              child: BlocProvider(
                create: (_) =>
                    ResendEmailCubit(context.read<AuthenticationRepository>()),
                child: ResendEmailForm(),
              ),
            ),
          );
  }
}

class ResendEmailForm extends StatelessWidget {
  const ResendEmailForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResendEmailCubit, ResendEmailState>(
      listener: (context, state) {
        if (state == ResendEmailState.resendFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("Label_ResendEmail_resendFailure".tr()),
            ));
        }
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Label_ResendEmail_checkEmail".tr(),
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ResendButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _OkButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResendButton extends StatefulWidget {
  @override
  __ResendButtonState createState() => __ResendButtonState();
}

class __ResendButtonState extends State<_ResendButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResendEmailCubit, ResendEmailState>(
      builder: (context, state) {
        return RoundedLoadingButton(
          color: Theme.of(context).colorScheme.secondary,
          key: const Key("resend_email_button"),
          controller: _btnController,
          onPressed: () async {
            await context.read<ResendEmailCubit>().resendEmail();
            await context.read<ResendEmailCubit>().logOut();
          },
          child: Text("Label_ResendEmail_verifyEmail".tr()),
        );
      },
    );
  }
}

class _OkButton extends StatefulWidget {
  @override
  __OkButtonState createState() => __OkButtonState();
}

class __OkButtonState extends State<_OkButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResendEmailCubit, ResendEmailState>(
      builder: (context, state) => RoundedLoadingButton(
        color: Theme.of(context).colorScheme.secondary,
        key: const Key("ok_email_button"),
        controller: _btnController,
        onPressed: () async {
          await context.read<ResendEmailCubit>().logOut();
        },
        child: Text("logout".tr()),
      ),
    );
  }
}
