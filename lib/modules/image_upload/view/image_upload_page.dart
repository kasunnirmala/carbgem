import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_upload/image_upload.dart';
import 'package:carbgem/widgets/widgets.dart';

class ImageUploadPage extends StatelessWidget {
  final String imageUploadPath;
  final String patientId;
  final String caseId;
  final String patientName;
  final String caseName;
  final String specimenId;
  const ImageUploadPage({
    Key? key, required this.imageUploadPath, required this.patientId, required this.caseId, required this.patientName, required this.caseName,
    required this.specimenId,
  }): super(key: key);
  static Page page({
    required String imageUploadPath, required String patientId, required String caseId, required String patientName, required String caseName,
    required String specimenId,
  }) => MaterialPage<void>(child: ImageUploadPage(
    imageUploadPath: imageUploadPath, caseId: caseId, patientId: patientId, patientName: patientName, caseName: caseName, specimenId: specimenId,
  ));
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageUploadCubit(
        context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), imageUploadPath, patientId, caseId,
        patientName, caseName, specimenId,
      ),
      child: Scaffold(
        appBar: (patientId=="") ?  AppBar(
          centerTitle: true,
          title: Text("Label_Title_upLoadImage".tr(), style: TextStyle(color: Colors.white,fontSize: 17)),
          backgroundColor: Colors.blue.withOpacity(0.9),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0)
            : appBarWithBackArrowModified(
          context: context, pageNumber: 10, pageName: "Label_Title_upLoadImage".tr(), subParameter: patientName, subParameter2nd: patientId, subParameter3rd: caseName, subParameter4th: caseId,
          subParameter5th: specimenId,
        ),
        endDrawer:CustomDrawer(),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child :ImageUploadForm(),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(),
      ),
    );
  }
}
