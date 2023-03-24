import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/phone_register/phone_register.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PhoneRegisterPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: PhoneRegisterPage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithoutLead(context: context),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
            create: (_) => PhoneRegisterCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
            child: PhoneRegisterForm()),
      ),
    );
  }
}
