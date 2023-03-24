import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_classification_result_detail/image_classification_result_detail.dart';
import 'package:carbgem/widgets/widgets.dart';

class ImageClassificationResultDetailPage extends StatelessWidget {
  // const ImageClassificationResultDetailPage({Key? key}): super(key: key);
  final String imageId;
  final String finalJudgement;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String specimenId;
  ImageClassificationResultDetailPage({
    required this.imageId, required this.finalJudgement, required this.caseId, required this.caseName,
    required this.patientId, required this.patientName, required this.specimenId,
  });
  static Page page({
    required String imageId, required String finalJudgement, required String caseId,
    required String patientName, required String patientId, required String caseName,
    required String specimenId,
  }) => MaterialPage<void>(child: ImageClassificationResultDetailPage(
    imageId: imageId, finalJudgement: finalJudgement, caseName: caseName, caseId: caseId,
    patientId: patientId, patientName: patientName, specimenId: specimenId,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (patientId=="unspecified") ?
      appBarWithBackArrowModified(context: context, pageNumber: 5, pageName: "Label_Title_species_result_1") : (patientId=="unknown") ?
      appBarWithBackArrowModified(context: context, pageNumber: 1, pageName: "Label_Title_species_result_1" ,subParameter: '', subParameter2nd: "", subParameter3rd: "", subParameter4th: "", subParameter5th: "") :
      appBarWithBackArrowModified(
          context: context, pageNumber: 10, pageName: "Label_Title_species_result_1",subParameter: patientName, subParameter2nd: patientId,
          subParameter3rd: caseName, subParameter4th: caseId, subParameter5th: specimenId
      ),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => ImageClassificationResultDetailCubit(
            context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), imageId, finalJudgement,
            patientId, patientName, caseId, caseName, specimenId,
          ),
          child: ImageClassificationResultDetailForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}