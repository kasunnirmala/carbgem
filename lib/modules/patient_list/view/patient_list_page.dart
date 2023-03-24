import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/patient_list/patient_list.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientListPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: PatientListPage());
  static Route route(){
    return MaterialPageRoute(builder: (_) => PatientListPage());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientListCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
      child: BlocBuilder<PatientListCubit, PatientListState>(
        buildWhen: (previous, current) => previous.filterPatientList!=current.filterPatientList,
        builder: (context, state) => Scaffold(
          appBar: appBarWithBackArrowModified(context: context, pageNumber: 0, pageName: "Label_Title_patient_list", submitSearchFunction: context.read<PatientListCubit>().searchTextChanged),
          endDrawer: CustomDrawer(),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PatientListForm(),
            ),
          ),
          bottomNavigationBar: CustomNavigationBar(),
        ),
      ),
    );
  }
}

