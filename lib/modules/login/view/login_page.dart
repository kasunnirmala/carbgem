import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}): super(key: key);
  static Route route(){
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }
  static Page page() => MaterialPage<void>(child: LoginPage());
  @override
  Widget build(BuildContext context) {
    print("password".tr());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Label_Title_login".tr(),style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.withOpacity(0.9),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0
      ),
      body: Container(
        child: SingleChildScrollView(
            child:Padding(
              padding: EdgeInsets.all(8),
              child: BlocProvider(
                create: (_) => LoginCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
                child: const LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
