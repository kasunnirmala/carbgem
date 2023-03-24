part of 'case_summary_cubit.dart';
enum CaseSummaryStatus{error, loading, success}
class CaseSummaryState extends Equatable{
  final FungiSummaryAPI fungiSummaryAPI;
  final String caseId;
  final String caseName;
  final String patientId;
  final String patientName;
  final String specimenId;
  final CaseSummaryStatus status;
  final String errorMessage;

  const CaseSummaryState({
    this.fungiSummaryAPI = FungiSummaryAPI.empty, this.status = CaseSummaryStatus.loading,
    this.caseId = "", this.caseName = "", this.patientId = "", this.patientName = "",
    this.errorMessage="", this.specimenId="",
  });

  @override
  List<Object?> get props => [fungiSummaryAPI, caseId, caseName, patientId, patientName, errorMessage, specimenId];

  CaseSummaryState copyWith({
    FungiSummaryAPI? fungiSummaryAPI, String? caseId, String? caseName, String? patientId,
    String? patientName, CaseSummaryStatus? status, String? errorMessage,
    String? specimenId,
  }) {
    return CaseSummaryState(
      fungiSummaryAPI: fungiSummaryAPI?? this.fungiSummaryAPI, status: status?? this.status,
      caseId: caseId?? this.caseId, caseName: caseName?? this.caseName,
      patientId: patientId?? this.patientId, patientName: patientName?? this.patientName,
      errorMessage: errorMessage?? this.errorMessage, specimenId: specimenId?? this.specimenId,
    );
  }
}