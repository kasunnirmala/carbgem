import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/data_explorer_sex/data_explorer_sex.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataExplorerSexPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: DataExplorerSexPage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 21, pageName: "性別による絞り込み"),
      bottomNavigationBar: CustomNavigationBar(),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => DataExplorerSexCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: DataExplorerSexForm(),
        ),
      ),
    );
  }
}
