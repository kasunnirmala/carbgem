import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/all.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/user_info_profile/user_info_profile.dart';
import 'package:carbgem/widgets/widgets.dart';

class UserInfoProfilePage extends StatelessWidget {
  const UserInfoProfilePage({Key? key}): super(key: key);
  static Page page() => MaterialPage<void>(child: UserInfoProfilePage());
  static Route route(){
    return MaterialPageRoute(builder: (_) => const UserInfoProfilePage());
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoProfileCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
      child: BlocBuilder<BasicHomeCubit, BasicHomeState>(builder: (context,state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Label_Title_profile".tr(), style: TextStyle(color: Colors.white,fontSize: 17)),
            backgroundColor: Colors.blue.withOpacity(0.9),
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0
          ),
          endDrawer: (state.status==BasicHomeStatus.unactivated) ? CustomUnactivatedDrawer() :CustomDrawer(),
          body: Padding(
            padding: EdgeInsets.all(8),
            child: UserInfoProfileForm(),
          ),
        );
      },)
    );
  }
}