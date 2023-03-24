// Exceptions For API Calling
class FetchUserFailureBitte implements Exception{
  final int statusCode;
  FetchUserFailureBitte({required this.statusCode});
}
class RegisterActivationCodeFailure implements Exception{
  final int statusCode;
  RegisterActivationCodeFailure({required this.statusCode});
}
class RegisterUserFailure implements Exception{
  final int statusCode;
  RegisterUserFailure({required this.statusCode});
}
class AddingPatientFailure implements Exception{
  final int statusCode;
  AddingPatientFailure({required this.statusCode});
}
class AddingCaseFailure implements Exception{
  final int statusCode;
  AddingCaseFailure({required this.statusCode});
}
class FinalDrugJudgementFailure implements Exception{
  final int statusCode;
  FinalDrugJudgementFailure({required this.statusCode});
}
class FinalFungiJudgementFailure implements Exception{
  final int statusCode;
  FinalFungiJudgementFailure({required this.statusCode});
}
class AntibiogramDrugInfFilterFailure implements Exception{
  final int statusCode;
  AntibiogramDrugInfFilterFailure({required this.statusCode});
}
class FetchJANISDrugListFailure implements Exception{
  final int statusCode;
  FetchJANISDrugListFailure({required this.statusCode});
}
class FetchPurchaseHistoryFailure implements Exception{
  final int statusCode;
  FetchPurchaseHistoryFailure({required this.statusCode});
}
class CreatePurchaseHistoryFailure implements Exception{
  final int statusCode;
  CreatePurchaseHistoryFailure({required this.statusCode});
}
class FetchBreakdownAreaFailure implements Exception{
  final int statusCode;
  FetchBreakdownAreaFailure({required this.statusCode});
}
class FetchAreaListFailure implements Exception{
  final int statusCode;
  FetchAreaListFailure({required this.statusCode});
}
class FetchHospitalListFailure implements Exception{
  final int statusCode;
  FetchHospitalListFailure({required this.statusCode});
}
class FetchAntibiogramMapFailure implements Exception{
  final int statusCode;
  FetchAntibiogramMapFailure({required this.statusCode});
}
class FetchJANISFungiListFailure implements Exception{
  final int statusCode;
  FetchJANISFungiListFailure({required this.statusCode});
}
class FetchBreakdownAgeFailure implements Exception{
  final int statusCode;
  FetchBreakdownAgeFailure({required this.statusCode});
}
class UserProfileModify implements Exception{
  final int statusCode;
  UserProfileModify({required this.statusCode});
}
class PatientAddFailure implements Exception{
  final int statusCode;
  PatientAddFailure({required this.statusCode});
}
class CaseAddFailure implements Exception{
  final int statusCode;
  CaseAddFailure({required this.statusCode});
}
class FetchBreakdownDrugFailure implements Exception{
  final int statusCode;
  FetchBreakdownDrugFailure({required this.statusCode});
}
class FungiJudgeConfirmFailure implements Exception{
  final int statusCode;
  FungiJudgeConfirmFailure({required this.statusCode});
}
class ImageCaseAttachFailure implements Exception{
  final int statusCode;
  ImageCaseAttachFailure({required this.statusCode});
}
class ImagePatientAttachFailure implements Exception{
  final int statusCode;
  ImagePatientAttachFailure({required this.statusCode});
}
class CaseFeedbackFungiFailure implements Exception{
  final int statusCode;
  CaseFeedbackFungiFailure({required this.statusCode});
}
class CaseFeedbackDrugFailure implements Exception{
  final int statusCode;
  CaseFeedbackDrugFailure({required this.statusCode});
}
class CaseDetachFailure implements Exception{
  final int statusCode;
  CaseDetachFailure({required this.statusCode});
}
class PatientDetachFailure implements Exception{
  final int statusCode;
  PatientDetachFailure({required this.statusCode});
}
class FungiIsFungiJudgeFailure implements Exception{
  final int statusCode;
  FungiIsFungiJudgeFailure({required this.statusCode});
}
class FetchFungiResultFailure implements Exception{
  final int statusCode;
  FetchFungiResultFailure({required this.statusCode});
}
class FungiFinalJudgementFailure implements Exception{
  final int statusCode;
  FungiFinalJudgementFailure({required this.statusCode});
}
class AttachImageToPatientFailure implements Exception{
  final int statusCode;
  AttachImageToPatientFailure({required this.statusCode});
}
class UnclassifiedImageToPatientListFailure implements Exception{
  final int statusCode;
  UnclassifiedImageToPatientListFailure({required this.statusCode});
}
class PatientListFetchFailure implements Exception{
  final int statusCode;
  PatientListFetchFailure({required this.statusCode});
}
class CaseListFetchFailure implements Exception{
  final int statusCode;
  CaseListFetchFailure({required this.statusCode});
}
class FungiUndetectedError implements Exception{}
class FungiDetectionAPIError implements Exception{
  final int statusCode;
  FungiDetectionAPIError({required this.statusCode});
}
class PatientAttachAPIError implements Exception{
  final int statusCode;
  PatientAttachAPIError({required this.statusCode});
}
class CaseImageListFailure implements Exception{
  final int statusCode;
  CaseImageListFailure({required this.statusCode});
}
class DrugDetailsFailure implements Exception{
  final int statusCode;
  DrugDetailsFailure({required this.statusCode});
}
class FungiListFullFailure implements Exception{
  final int statusCode;
  FungiListFullFailure({required this.statusCode});
}
class CaseSummaryFailure implements Exception{
  final int statusCode;
  CaseSummaryFailure({required this.statusCode});
}
class FetchBreakdownOriginFailure implements Exception{
  final int statusCode;
  FetchBreakdownOriginFailure({required this.statusCode});
}
class FetchBreakdownSexFailure implements Exception{
  final int statusCode;
  FetchBreakdownSexFailure({required this.statusCode});
}
class FetchBreakdownSizeFailure implements Exception{
  final int statusCode;
  FetchBreakdownSizeFailure({required this.statusCode});
}
class DeleteImageAPIFailure implements Exception{
  final int statusCode;
  DeleteImageAPIFailure({required this.statusCode});
}
class DeleteCaseAPIFailure implements Exception{
  final int statusCode;
  DeleteCaseAPIFailure({required this.statusCode});
}
class DeletePatientAPIFailure implements Exception{
  final int statusCode;
  DeletePatientAPIFailure({required this.statusCode});
}
class FetchUserRecordAPIFailure implements Exception{
  final int statusCode;
  FetchUserRecordAPIFailure({required this.statusCode});
}
class FungiIndividualAPIFailure implements Exception{
  final int statusCode;
  FungiIndividualAPIFailure({required this.statusCode});
}