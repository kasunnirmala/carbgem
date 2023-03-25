import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/activation_code/activation_code.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivationPage extends StatelessWidget {
  const ActivationPage({Key? key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: ActivationPage());
  static Route route() {
    return MaterialPageRoute(builder: (_) => const ActivationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivationCubit(context.read<BitteApiClient>(),
          context.read<AuthenticationRepository>()),
      child: const ActivationForm(),
    );
  }
}
