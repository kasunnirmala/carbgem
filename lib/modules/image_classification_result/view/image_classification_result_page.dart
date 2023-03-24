import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_classification_result/image_classification_result.dart';
import 'package:carbgem/widgets/widgets.dart';

class ImageClassificationResultPage extends StatelessWidget {
  // const ImageClassificationResultPage({Key? key}): super(key: key);
  final String imageId;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;

  const ImageClassificationResultPage({Key? key, required this.imageId, required this.caseId, required this.patientName, required this.patientId, required this.caseName}) : super(key: key);
  static Page page({
    required String caseId, required String patientName,required String caseName, required String patientId, required String imageId,
  }) => MaterialPage<void>(child: ImageClassificationResultPage(
    caseId: caseId, caseName: caseName, patientName: patientName, patientId: patientId, imageId: imageId,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 10, pageName: "", subParameter: patientName, subParameter2nd: patientId, subParameter3rd: caseName, subParameter4th: caseId),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => ImageClassificationResultCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), imageId, patientName, patientId, caseName, caseId),
          child: ImageClassificationResultForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
