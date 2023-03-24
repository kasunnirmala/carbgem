import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:carbgem/modules/sign_up/sign_up.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}): super(key: key);
  static Route route(){
    return MaterialPageRoute(builder: (_) => const SignUpPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Label_Title_signUp".tr(), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.withOpacity(0.9),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: BlocProvider<SignUpCubit>(
            create: (_) => SignUpCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
            child: const SignUpForm(),
          ),
        ),
      ),
    );
  }
}
