import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/case_summary/case_summary.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseSummaryPage extends StatelessWidget {
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String specimenId;

  const CaseSummaryPage({Key? key, required this.caseId, required this.patientName, required this.patientId, required this.caseName, required this.specimenId}) : super(key: key);
  static Page page({required String caseId, required String patientName,required String caseName, required String patientId, required String specimenId,}) => MaterialPage<void>(child: CaseSummaryPage(
    caseId: caseId, caseName: caseName, patientName: patientName, patientId: patientId, specimenId: specimenId,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(
        context: context, pageNumber: 10, subParameter: patientName, subParameter2nd: patientId, subParameter3rd: caseName, subParameter4th: caseId,
        subParameter5th: specimenId, pageName: "Label_Title_bacteriaList",
      ),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => CaseSummaryCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), caseId, caseName, patientName, patientId, specimenId),
          child: CaseSummaryForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
