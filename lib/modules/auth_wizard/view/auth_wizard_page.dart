import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/auth_wizard/cubit/auth_wizard_cubit.dart';
import 'package:carbgem/modules/auth_wizard/view/auth_wizard_form.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWizardPage extends StatelessWidget {
  const AuthWizardPage({Key? key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: AuthWizardPage());
  static Route route() {
    return MaterialPageRoute(builder: (_) => const AuthWizardPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthWizardCubit(context.read<BitteApiClient>(),
          context.read<AuthenticationRepository>()),
      child: AuthWizardForm(),
    );
  }
}
