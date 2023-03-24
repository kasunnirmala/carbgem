import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/data_explorer_age/data_explorer_age.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataExplorerAgePage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: DataExplorerAgePage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 21, pageName: "Label_dataExplorer_front_age"),
      bottomNavigationBar: CustomNavigationBar(),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => DataExplorerAgeCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: DataExplorerAgeForm(),
        ),
      ),
    );
  }
}
