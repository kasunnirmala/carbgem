import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/auth_wizard/auth_wizard.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  onBackPressed(context: context, pageNumber: 0, navNumber: 0),
              child: Align(
                alignment: const Alignment(0, -1 / 3),
                child: Column(
                  children: [
                    Expanded(
                      child: DotStepper(
                        // direction: Axis.vertical,
                        dotCount: 5,
                        dotRadius: 15,

                        /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
                        activeStep: activeState,
                        shape: Shape.rectangle,
                        spacing: 20,

                        // DOT-STEPPER DECORATIONS
                        fixedDotDecoration: FixedDotDecoration(
                          color: Colors.red,
                        ),

                        indicatorDecoration: IndicatorDecoration(
                          // style: PaintingStyle.stroke,
                          // strokeWidth: 8,
                          color: Colors.deepPurple,
                        ),
                        lineConnectorDecoration: LineConnectorDecoration(
                          color: Colors.red,
                          strokeWidth: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: LoginPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
