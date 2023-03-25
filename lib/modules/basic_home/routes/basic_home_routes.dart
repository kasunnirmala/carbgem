import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/auth_wizard/auth_wizard.dart';
import 'package:carbgem/modules/data_explorer_age/data_explorer_age.dart';
import 'package:carbgem/modules/data_explorer_area/data_explorer_area.dart';
import 'package:carbgem/modules/data_explorer_drug/data_explorer_drug.dart';
import 'package:carbgem/modules/data_explorer_front/data_explorer_front.dart';
import 'package:carbgem/modules/data_explorer_origin/data_explorer_origin.dart';
import 'package:carbgem/modules/data_explorer_sex/data_explorer_sex.dart';
import 'package:carbgem/modules/data_explorer_size/data_explorer_size.dart';
import 'package:carbgem/modules/image_classification_tflite/classifier_page.dart';
import 'package:carbgem/modules/in_app_purchase/view/in_app_purchase.dart';
import 'package:flutter/material.dart';

/// TODO: additional data visualization
List<Page> onGenerateBasicHomeViewPages(
    BasicHomeState state, List<Page<dynamic>> pages) {
  switch (state.pageNavigation) {
    case 3:
      return [PatientListPage.page()];
    case 2:
      return [InfectionMapPage.page()];
    case 1:
      return [
        ImageUploadPage.page(
          imageUploadPath: state.subPageParameter,
          patientId: state.subPageParameter2nd,
          caseId: state.subPageParameter3rd,
          patientName: state.subPageParameter4th,
          caseName: state.subPageParameter5th,
          specimenId: state.subPageParameter6th,
        )
      ];
    case 4:
      return [UserInfoProfilePage.page()];
    case 5:
      return [PatientNotClassifiedImagePage.page()];
    case 6:
      return [PatientAttachingImageListPage.page()];
    case 7:
      return [
        CaseListPerPatientPage.page(
            patientId: state.subPageParameter,
            patientName: state.subPageParameter2nd)
      ];
    case 8:
      return [ImageUnclassifiedDeletePage.page()];
    case 9:
      return [UserActivityRecordsPage.page()];
    case 10:
      return [
        ImageListPerCasePage.page(
            patientName: state.subPageParameter,
            patientId: state.subPageParameter2nd,
            caseName: state.subPageParameter3rd,
            caseId: state.subPageParameter4th,
            specimenId: state.subPageParameter5th,
            showMenu: state.subPageParameter16th)
      ];
    case 11:
      return [
        ImageClassListReleasePage.page(
            patientName: state.subPageParameter,
            patientId: state.subPageParameter2nd,
            caseName: state.subPageParameter3rd,
            caseId: state.subPageParameter4th)
      ];
    case 12:
      return [VersionDisplayPage.page()];
    case 13:
      return [
        ImageClassificationResultDetailPage.page(
          imageId: state.subPageParameter,
          finalJudgement: state.subPageParameter2nd,
          patientId: state.subPageParameter3rd,
          patientName: state.subPageParameter4th,
          caseId: state.subPageParameter5th,
          caseName: state.subPageParameter6th,
          specimenId: state.subPageParameter7th,
        )
      ];
    case 15:
      return [
        ImageClassificationResultPage.page(
            patientId: state.subPageParameter,
            patientName: state.subPageParameter2nd,
            caseId: state.subPageParameter3rd,
            caseName: state.subPageParameter4th,
            imageId: state.subPageParameter5th)
      ];
    case 16:
      return [
        DrugListPerFungiPage.page(
          fungiName: state.subPageParameter,
          finalJudgement: state.subPageParameter2nd,
          patientId: state.subPageParameter3rd,
          patientName: state.subPageParameter4th,
          caseId: state.subPageParameter5th,
          caseName: state.subPageParameter6th,
          fungiCode: state.subPageParameter7th,
          sourcePage: int.parse(state.subPageParameter8th),
          imageId: state.subPageParameter9th,
          specimenId: state.subPageParameter10th,
        )
      ];
    case 17:
      return [
        DrugDetailDescriptionPage.page(
          imageId: state.subPageParameter,
          finalJudgement: state.subPageParameter2nd,
          patientId: state.subPageParameter3rd,
          patientName: state.subPageParameter4th,
          caseId: state.subPageParameter5th,
          caseName: state.subPageParameter6th,
          fungiId: state.subPageParameter7th,
          fungiName: state.subPageParameter8th,
          drugCode: state.subPageParameter9th,
          inputAreaId: state.subPageParameter10th,
          specimenId: state.subPageParameter11th,
          inputAreaName: state.subPageParameter12th,
          sourcePage: int.parse(state.subPageParameter13th),
        )
      ];
    case 18:
      return [
        CaseSummaryPage.page(
          patientName: state.subPageParameter,
          patientId: state.subPageParameter2nd,
          caseName: state.subPageParameter3rd,
          caseId: state.subPageParameter4th,
          specimenId: state.subPageParameter5th,
        )
      ];
    case 19:
      // return [ActivationPage.page()];
      return [AuthWizardPage.page()];
    case 20:
      return [InAppPurchasePage.page()];
    case 21:
      return [DataExplorerFrontPage.page()];
    case 22:
      return [DataExplorerAreaPage.page()];
    case 23:
      return [DataExplorerDrugPage.page()];
    case 24:
      return [DataExplorerSexPage.page()];
    case 25:
      return [DataExplorerAgePage.page()];
    case 26:
      return [DataExplorerOriginPage.page()];
    case 27:
      return [DataExplorerSizePage.page()];
    // case 28:
    // return [ClassiferPage.page()];
    case 0:
    default:
      return [BasicHome.page()];
  }
}
