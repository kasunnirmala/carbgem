part of 'drug_list_per_fungi_cubit.dart';

enum DrugListPerFungiStatus{error, loading, success, addNew, drugJudgement, drugJudgementLoading}

class DrugListPerFungiState extends Equatable{
  final bitte.User currentUser;
  final List<bitte.DrugAntibiogram> drugList;
  final List<bitte.DrugAntibiogram> displayDrugList;
  final List<String> whoAwareList;
  final List<String> whoAwareSelected;
  final DrugListPerFungiStatus status;
  final double threshold;
  final double thresholdSpectrum;
  final String fungiId;
  final String fungiName;
  final String specimenId;
  final String areaId;
  final String year;
  final String bedSize;
  final String sex;
  final String origin;
  final String ageGroup;
  final String caseId;
  final String caseName;
  final String imageId;
  final String finalJudgement;
  final String patientStatusId;
  final String patientId;
  final String patientName;
  final String errorMessage;
  final bool descendingSpectrum;
  final bool descendingWhoAware;
  final bool descendingSusceptibility;
  final int tabIndex;
  final int sourcePage;
  const DrugListPerFungiState({
    this.drugList = const [],
    this.displayDrugList = const [],
    this.status = DrugListPerFungiStatus.loading,
    this.threshold = 90.0,
    this.thresholdSpectrum = 30.0,
    this.fungiId = "",
    this.specimenId = "1",
    this.areaId = "0",
    this.year = "2019",
    this.bedSize = "ALL",
    this.sex = "ALL",
    this.origin = "ALL",
    this.ageGroup = "ALL",
    this.caseId = "",
    this.imageId = "",
    this.patientStatusId ="1",
    this.fungiName = "",
    this.caseName = "",
    this.patientName = "",
    this.patientId = "",
    this.finalJudgement = "",
    this.errorMessage = "",
    this.currentUser = bitte.User.empty,
    this.descendingSpectrum = false,
    this.descendingWhoAware = true,
    this.descendingSusceptibility = true,
    this.tabIndex = 0,
    this.whoAwareList = const ["Access","Watch","Reserve","Uncategorized"],
    this.whoAwareSelected = const ["Access","Watch","Reserve","Uncategorized"],
    this.sourcePage = 0,
  });

  @override
  List<Object?> get props => [
    drugList, displayDrugList, status, threshold, fungiId,
    specimenId, areaId, year, bedSize, sex, origin, ageGroup,
    caseId, imageId, patientStatusId,
    fungiName, caseName, patientId, patientName, finalJudgement,
    errorMessage, currentUser, descendingSpectrum, descendingWhoAware, descendingSusceptibility,
    tabIndex, thresholdSpectrum, whoAwareList, whoAwareSelected, sourcePage,
  ];

  DrugListPerFungiState copyWith({
    List<bitte.DrugAntibiogram>? drugList, DrugListPerFungiStatus? status, double? threshold, String? fungiId, String? specimenId,
    String? areaId, String? year, String? bedSize, String? sex, String? origin, String? ageGroup,
    List<bitte.DrugAntibiogram>? displayDrugList, String? caseId, String? imageId, String? patientStatusId,
    String? fungiName, String? caseName, String? patientId, String? patientName, String? finalJudgement,
    String? errorMessage, bitte.User? currentUser, bool? descendingSpectrum, bool? descendingWhoAware, bool? descendingSusceptibility,
    int? tabIndex, double? thresholdSpectrum, List<String>? whoAwareSelected, int? sourcePage
  }){
    return DrugListPerFungiState(
      drugList: drugList ?? this.drugList, status: status ?? this.status, threshold: threshold ?? this.threshold,
      fungiId: fungiId ?? this.fungiId, specimenId: specimenId ?? this.specimenId, areaId: areaId ?? this.areaId,
      year: year ?? this.year, bedSize: bedSize ?? this.bedSize, sex: sex ?? this.sex, origin: origin?? this.origin,
      ageGroup: ageGroup ?? this.ageGroup, displayDrugList: displayDrugList ?? this.displayDrugList,
      caseId: caseId?? this.caseId, imageId: imageId?? this.imageId,
      patientStatusId: patientStatusId ?? this.patientStatusId, fungiName: fungiName?? this.fungiName,
      caseName: caseName?? this.caseName, patientId: patientId?? this.patientId, patientName: patientName?? this.patientName,
      finalJudgement: finalJudgement?? this.finalJudgement, errorMessage: errorMessage?? this.errorMessage,
      currentUser: currentUser?? this.currentUser,
      descendingSpectrum: descendingSpectrum?? this.descendingSpectrum, descendingWhoAware: descendingWhoAware?? this.descendingWhoAware,
      descendingSusceptibility: descendingSusceptibility?? this.descendingSusceptibility, tabIndex: tabIndex?? this.tabIndex,
      thresholdSpectrum: thresholdSpectrum?? this.thresholdSpectrum, whoAwareSelected: whoAwareSelected?? this.whoAwareSelected,
      sourcePage: sourcePage?? this.sourcePage
    );
  }
}