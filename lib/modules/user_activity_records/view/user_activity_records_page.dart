import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/user_activity_records/user_activity_records.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserActivityRecordsPage extends StatelessWidget {
  const UserActivityRecordsPage({Key? key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: UserActivityRecordsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserActivityRecordsCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
      child: Scaffold(
        appBar: appBarWithBackArrowModified(context: context, pageNumber: 0, pageName: "Label_Title_userActivity"),
        endDrawer: CustomDrawer(),
        bottomNavigationBar: CustomNavigationBar(),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: UserActivityRecordForm(),
          ),
        ),
      ),
    );
  }
}
