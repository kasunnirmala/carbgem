import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/data_explorer_size/cubit/data_explorer_size_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_explorer_size_form.dart';

class DataExplorerSizePage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: DataExplorerSizePage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithBackArrowModified(context: context, pageNumber: 21, pageName: "病床数による絞り込み"),
        bottomNavigationBar: CustomNavigationBar(),
        endDrawer: CustomDrawer(),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) => DataExplorerSizeCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
            child: DataExplorerSizeForm(),
          ),
        ));
  }
}
