import 'package:carbgem/modules/phone_register/cubit/phone_register_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PhoneRegisterForm extends StatelessWidget {
  const PhoneRegisterForm({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneRegisterCubit, PhoneRegisterState>(
      listener: (context, state){
        if (state.status.isSubmissionFailure){
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        } else if (state.status == FormzStatusPhone.submissionCodeSuccess) {
          getAlert(context: context, title: 'Label_PhoneRegister_completeRegistration'.tr(), msg: 'Label_PhoneRegister_relogin'.tr(),
            clickFunction: true, okButton: true, okFunction: () => context.read<PhoneRegisterCubit>().logOut(),
          );
        }
      },
      child: BlocBuilder<PhoneRegisterCubit, PhoneRegisterState>(
        builder: (context, state){
          return Align(
            alignment: Alignment(0,-1/3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  state.status.isCodeForm ? _SmsInput() : Container(),
                  SizedBox(height: 10,),
                  state.status.isCodeForm ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SubmitCodeButton(),
                      SizedBox(height: 20,),
                      LogOutButton(),
                    ],
                  ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SendSmsButton(),
                      SizedBox(height: 20,),
                      LogOutButton(),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SmsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneRegisterCubit, PhoneRegisterState>(
      buildWhen: (previous, current) => previous.smsCode!=current.smsCode,
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width*0.8,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            key: const Key("register_sms_textField"),
            onChanged: (smsCode) => context.read<PhoneRegisterCubit>().smsChanged(smsCode),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.lock),
              labelText: "Label_PhoneRegister_inputCode".tr(), helperText: "", errorText: state.smsCode.invalid ? "Label_activation_code_input_error".tr() : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),);
      },);
  }
}
class _SendSmsButton extends StatefulWidget {
  @override
  __SendSmsButtonState createState() => __SendSmsButtonState();
}

class __SendSmsButtonState extends State<_SendSmsButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneRegisterCubit, PhoneRegisterState>(
        buildWhen: (previous, current) => previous.status!=current.status,
        builder: (context, state) {
          return RoundedLoadingButton(
            color: Theme.of(context).colorScheme.secondary,
            controller: _btnController,
            key: const Key("send_sms_button_phone_register_form"),
            onPressed: () async {
              await context.read<PhoneRegisterCubit>().registerPhone();
              _btnController.success();
            },
            child:  Container(
              width: MediaQuery.of(context).size.width*0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mobile_friendly),
                  SizedBox(width: 20,),
                  Text('Label_PhoneRegister_smsCode'.tr()),
                ],
              ),
            ),
          );
        }
    );
  }
}

class _SubmitCodeButton extends StatefulWidget {
  @override
  __SubmitCodeButtonState createState() => __SubmitCodeButtonState();
}

class __SubmitCodeButtonState extends State<_SubmitCodeButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneRegisterCubit,PhoneRegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return RoundedLoadingButton(
          color: Theme.of(context).colorScheme.secondary,
          controller: _btnController,
          key: const Key("register_code_submitButton"),
          onPressed: state.status.isValidated ? () async {
            await context.read<PhoneRegisterCubit>().verifyAndLink();
            _btnController.success();
          } : null,
          child: Text("Label_PhoneRegister_registerCode".tr()),);
      },);
  }
}