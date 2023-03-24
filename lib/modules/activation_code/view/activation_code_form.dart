import 'package:carbgem/modules/activation_code/activation_code.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';


enum JobTitle { doctor, physician, others }

class ActivationForm extends StatefulWidget {
  const ActivationForm({Key? key}) : super(key: key);
  @override
  _ActivationFormState createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivationCubit, ActivationState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        } else if (state.status.isSubmissionSuccess) {
             getAlert(context: context,
                title: 'Label_activation_code_alert_title'.tr(),
                msg: 'Label_activation_code_alert_msg'.tr(),
               clickFunction: true,
               okButton: true,
               okFunction: () => context.read<BasicHomeCubit>().pageChanged(value: 0),
             );
             // TODO: Please check the below code work correctly!!
             // context.read<BasicHomeCubit>().pageChanged(value: 0);
        }
      },
      child: WillPopScope(
        onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              _ActivationCodeInput(),
              SizedBox(height: 10,),
              _ActivateButton(),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("■有効化コードについて")),
              SizedBox(height: 10),
              Text("有効化コードは医療機関ごとに発行させて頂きます。"),
              SizedBox(height: 20,),
              Text("本アプリのご利用をご希望される場合には、以下の利用申請フォームよりご連絡をお願いいたします。"),
              SizedBox(height: 20,),
              RoundedLoadingButton(
                height: 40,
                color: Theme.of(context).colorScheme.secondary,
                controller: _btnController,
                child: Text('利用申請フォーム'),
                onPressed: () {
                  _launchInBrowser();
                  _btnController.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivationCodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationCubit, ActivationState>(
      buildWhen: (previous, current) => previous.activationPassword != current.activationPassword,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            key: const Key('activationForm_codeInput_textField'),
            onChanged: (pwd) => context.read<ActivationCubit>().passwordChanged(pwd),
            decoration: InputDecoration(
              labelText: 'Label_activation_code_input'.tr(), helperText: '', errorText: state.activationPassword.invalid ? 'Label_activation_code_input_error'.tr() : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              prefixIcon: Icon(FontAwesomeIcons.lock),
            ),
          ),);
      },);
  }
}

class _ActivateButton extends StatefulWidget {
  @override
  __ActivateButtonState createState() => __ActivateButtonState();
}

class __ActivateButtonState extends State<_ActivateButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationCubit, ActivationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return RoundedLoadingButton(
          color: Theme.of(context).colorScheme.secondary,
          controller: _btnController,
          key: const Key('activationForm_activate_button'),
          onPressed: state.status.isValidated ? () async {
            await context.read<ActivationCubit>().registerActivationCode();
            _btnController.reset();
          }: null,
          child: Text("Label_activation_code_button_text".tr()),);
      },);
  }
}

// open by browser
_launchInBrowser() async {
  const url = 'https://forms.gle/KDaEh39zVw8pHFyU8';
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'このURLにはアクセスできません';
  }
}
