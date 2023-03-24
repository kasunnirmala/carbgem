import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:carbgem/modules/forgot_password/forgot_password.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}): super(key: key);
  static Route route(){
    return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrow(context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: BlocProvider<ForgotPasswordCubit>(
            create: (_) => ForgotPasswordCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
            child: const ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }
}
