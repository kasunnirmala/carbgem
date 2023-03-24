import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/case_list_per_patient/case_list_per_patient.dart';
import 'package:carbgem/widgets/widgets.dart';

class CaseListPerPatientPage extends StatelessWidget {
  final String patientId;
  final String patientName;
  CaseListPerPatientPage({required this.patientId, required this.patientName});
  static Page page({required String patientId, required String patientName}) => MaterialPage<void>(child: CaseListPerPatientPage(patientId: patientId, patientName: patientName));
  static Route route(patientId, patientName){
    return MaterialPageRoute(builder: (_) => CaseListPerPatientPage(patientId: patientId, patientName: patientName));
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaseListPerPatientCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), patientId, patientName),
      child: BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
        builder: (context, state) => Scaffold(
          appBar: appBarWithBackArrowModified(context: context, pageNumber: 3, pageName: "Label_Title_case_list"),
          endDrawer: CustomDrawer(),
          bottomNavigationBar: CustomNavigationBar(),
          body: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Theme.of(context).canvasColor,
                    ],
                    radius: 0.8,
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CaseListPerPatientForm(patientName),
            ),
          ),
        ),
      ),
    );
  }
}
