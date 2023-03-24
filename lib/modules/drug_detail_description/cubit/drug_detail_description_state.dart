part of 'drug_detail_description_cubit.dart';
enum DrugDetailDescriptionStatus {error, loading, success, filterLoading, judgementSuccess, judgementLoading}
class DrugDetailDescriptionState extends Equatable {
  final bitte.User currentUser;
  final bitte.DrugTimeSeriesAnti drugTimeSeriesAnti;
  final DrugDetailDescriptionStatus status;
  final String fungiId;
  final String drugCode;
  final String specimenId;
  final String areaId;
  final String bedSize;
  final String sex;
  final String origin;
  final String ageGroup;
  final String inputAreaId;
  final String inputAreaName;
  final int sourcePage;
  final String fungiName;
  final String finalJudgement;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final String imageId;

  const DrugDetailDescriptionState({
    this.drugTimeSeriesAnti = bitte.DrugTimeSeriesAnti.empty,
    this.status = DrugDetailDescriptionStatus.loading,
    this.fungiId = "", this.drugCode = "", this.specimenId = "1",
    this.areaId = "0", this.bedSize = "ALL", this.sex = "ALL",
    this.origin = "ALL", this.ageGroup = "ALL",
    this.currentUser = bitte.User.empty, this.inputAreaId="",
    this.inputAreaName = "", this.sourcePage=0,
    this.fungiName="", this.finalJudgement="", this.patientId="",
    this.patientName="", this.caseId="", this.caseName="",
    this.imageId="",
  });

  @override
  List<Object?> get props => [
    fungiId, drugCode, specimenId, areaId, bedSize, sex, origin, ageGroup,
    drugTimeSeriesAnti, status, currentUser, inputAreaId, inputAreaName,
    sourcePage, fungiName, finalJudgement, patientName, patientId,
    caseName, caseId, imageId,
  ];

  DrugDetailDescriptionState copyWith({
    bitte.DrugTimeSeriesAnti? drugTimeSeriesAnti, DrugDetailDescriptionStatus? status, String? fungiId,
    String? drugCode, String? specimenId, String? areaId, String? bedSize, String? sex, String? origin, String? ageGroup,
    bitte.User? currentUser, String? inputAreaId, String? inputAreaName, int? sourcePage, String? fungiName,
    String? finalJudgement, String? patientId, String? patientName, String? caseId, String? caseName,
    String? imageId,
  }) {
    return DrugDetailDescriptionState(
      drugTimeSeriesAnti: drugTimeSeriesAnti ?? this.drugTimeSeriesAnti, status: status ?? this.status,
      fungiId: fungiId ?? this.fungiId, drugCode: drugCode ?? this.drugCode, specimenId: specimenId ?? this.specimenId,
      areaId: areaId ?? this.areaId, bedSize: bedSize ?? this.bedSize, sex: sex ?? this.sex,
      origin: origin ?? this.origin, ageGroup: ageGroup ?? this.ageGroup, currentUser: currentUser?? this.currentUser,
      inputAreaId: inputAreaId?? this.inputAreaId, inputAreaName: inputAreaName?? this.inputAreaName,
      sourcePage: sourcePage?? this.sourcePage, fungiName: fungiName?? this.fungiName,
      finalJudgement: finalJudgement?? this.finalJudgement, patientName: patientName?? this.patientName,
      patientId: patientId?? this.patientId, caseId: caseId?? this.caseId, caseName: caseName?? this.caseName,
      imageId: imageId?? this.imageId,
    );
  }
}