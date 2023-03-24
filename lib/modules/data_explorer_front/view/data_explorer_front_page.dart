import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/data_explorer_front/cubit/data_explorer_front_cubit.dart';
import 'package:carbgem/modules/data_explorer_front/data_explorer_front.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataExplorerFrontPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: DataExplorerFrontPage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Label_Title_dataExplorer_front'.tr(), style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.withOpacity(0.9),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0
      ),
      bottomNavigationBar: CustomNavigationBar(),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => DataExplorerFrontCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: DataExplorerFrontForm(),
        ),
      ),
    );
  }
}
