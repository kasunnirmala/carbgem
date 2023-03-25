import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/auth_wizard/auth_wizard.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:im_stepper/stepper.dart';

enum JobTitle { doctor, physician, others }

class AuthWizardForm extends StatefulWidget {
  const AuthWizardForm({Key? key}) : super(key: key);
  @override
  _AuthWizardFormState createState() => _AuthWizardFormState();
}

class _AuthWizardFormState extends State<AuthWizardForm> {
  // await context.read<ActivationCubit>().registerActivationCode();
  int activeState = 0;
  String pageTitle = "Label_Title_login";
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthWizardCubit, AuthWizardState>(
        listener: (context, state) {
          setState(() {
            activeState = state.activeStep;
            pageTitle = state.pageTitle;
          });
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title:
                  Text(pageTitle.tr(), style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue.withOpacity(0.9),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0),
          body: Padding(
            padding: EdgeInsets.all(8),
            child: WillPopScope(
              onWillPop: () async =>
                  context.read<AuthWizardCubit>().onBackClicked(activeState),
              child: Align(
                alignment: const Alignment(0, -1 / 3),
                child: Column(
                  children: [
                    IconStepper(
                      icons: [
                        Icon(FontAwesomeIcons.chevronCircleRight),
                        Icon(FontAwesomeIcons.chevronCircleRight),
                        Icon(FontAwesomeIcons.chevronCircleRight),
                        Icon(FontAwesomeIcons.chevronCircleRight),
                        Icon(FontAwesomeIcons.chevronCircleRight)
                      ],
                      stepRadius: 15,
                      activeStep: activeState,
                      lineLength: 25,
                      enableNextPreviousButtons: false,
                      onStepReached: (index) =>
                          context.read<AuthWizardCubit>().onStateClicked(index),
                      steppingEnabled: false,
                    ),
                    Expanded(
                        child: context
                            .read<AuthWizardCubit>()
                            .getView(activeState)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
