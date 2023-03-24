import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/drug_detail_description/drug_detail_description.dart';
import 'package:carbgem/widgets/widgets.dart';

class DrugDetailDescriptionPage extends StatelessWidget {
  // const DrugDetailDescriptionPage({Key? key}): super(key: key);
  final String fungiName;
  final String fungiId;
  final String imageId;
  final String finalJudgement;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String drugCode;
  final String inputAreaId;
  final String specimenId;
  final String inputAreaName;
  final int sourcePage;
  DrugDetailDescriptionPage({
    required this.drugCode, required this.fungiId, required this.fungiName,
    required this.imageId, required this.finalJudgement, required this.caseId,
    required this.caseName, required this.patientName, required this.patientId,
    required this.inputAreaId, required this.specimenId, required this.inputAreaName,
    required this.sourcePage,
  });

  static Page page({
    required String imageId, required String finalJudgement, required String caseId,
    required String patientName, required String patientId, required String caseName,
    required String fungiName, required String fungiId, required String drugCode,
    required String inputAreaId, required String specimenId, required String inputAreaName,
    required int sourcePage,
  }) => MaterialPage<void>(child: DrugDetailDescriptionPage(
    imageId: imageId, finalJudgement: finalJudgement, caseName: caseName, caseId: caseId,
    patientId: patientId, patientName: patientName, fungiId: fungiId, fungiName: fungiName,
    drugCode: drugCode, inputAreaId: inputAreaId, specimenId: specimenId, inputAreaName: inputAreaName,
    sourcePage: sourcePage,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (inputAreaId!='') ? appBarWithBackArrowModified(
        context: context, pageNumber: 2, pageName: "Label_Title_antibioticsDetail"
      ) :
      appBarWithBackArrowModified(
        context: context, pageNumber: 16, subParameter: fungiName, subParameter2nd: finalJudgement,
        subParameter3rd: patientId, subParameter4th: patientName, subParameter5th: caseId,
        subParameter6th: caseName, subParameter7th: fungiId, subParameter8th: "$sourcePage",
        subParameter9th: imageId, subParameter10th: specimenId, pageName: "Label_Title_antibioticsDetail"
      ),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => DrugDetailDescriptionCubit(
            context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), fungiId, fungiName,
            imageId, finalJudgement, caseName, caseId, patientName, patientId, drugCode, specimenId,
            inputAreaId, inputAreaName, sourcePage,
          ),
          child: DrugDetailDescriptionForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
