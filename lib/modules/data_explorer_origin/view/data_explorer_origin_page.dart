import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/data_explorer_origin/cubit/data_explorer_origin_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_explorer_origin_form.dart';

class DataExplorerOriginPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: DataExplorerOriginPage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 21, pageName: "入院外来区分による絞り込み"),
      bottomNavigationBar: CustomNavigationBar(),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => DataExplorerOriginCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: DataExplorerOriginForm(),
        ),
      ),
    );
  }
}

