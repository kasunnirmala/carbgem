import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_list_per_case/image_list_per_case.dart';
import 'package:carbgem/widgets/widgets.dart';

class ImageListPerCasePage extends StatelessWidget {
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String specimenId;
  final bool showMenu;
  ImageListPerCasePage({required this.caseId, required this.patientName, required this.caseName, required this.patientId, required this.specimenId, required this.showMenu});
  static Page page({required String caseId, required String patientName,required String caseName, required String patientId, required String specimenId, required bool showMenu,}) => MaterialPage<void>(child: ImageListPerCasePage(
    caseId: caseId, caseName: caseName, patientName: patientName, patientId: patientId, specimenId: specimenId, showMenu: showMenu,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 7, pageName: "Label_Title_case_top", subParameter: patientId, subParameter2nd: patientName),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => ImageListPerCaseCubit(
              context.read<AuthenticationRepository>(), context.read<BitteApiClient>(),
              caseId, caseName, patientId, patientName, specimenId, showMenu
          ),
          child: ImageListPerCaseForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
