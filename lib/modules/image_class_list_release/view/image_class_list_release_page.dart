import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_class_list_release/image_class_list_release.dart';

class ImageClassListReleasePage extends StatelessWidget {
  final String caseName;
  final String caseId;
  final String patientId;
  final String patientName;
  ImageClassListReleasePage({required this.caseId, required this.caseName, required this.patientId, required this.patientName});
  static Page page({
    required String caseName, required String caseId, required String patientId, required String patientName
  }) => MaterialPage<void>(child: ImageClassListReleasePage(caseId: caseId, caseName: caseName, patientName: patientName, patientId: patientId,));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 10, pageName: "", subParameter: patientName, subParameter2nd: patientId, subParameter3rd: caseName, subParameter4th: caseId),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => ImageClassListReleaseCubit(context.read<BitteApiClient>(), context.read<AuthenticationRepository>(), caseId, caseName, patientId, patientName),
          child: ImageClassListReleaseForm(caseName: caseName),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
