part of 'case_list_per_patient_cubit.dart';

enum CaseListStatus {
  error, loading, success,
  addNewUrine, addNewUrineError, addNewUrineSuccess,
  addNewBlood, addNewBloodError, addNewBloodSuccess,
  addNewRespiratory, addNewRespiratoryError, addNewRespiratorySuccess,
  addNewSpinal, addNewSpinalError, addNewSpinalSuccess,
  deleteConfirm, deleteSuccess,
}

class CaseListPerPatientState extends Equatable{
  final List<Case> caseList;
  final List<Case> caseUrineList; // id=1
  final List<Case> caseBloodList; // id=2
  final List<Case> caseRespiratoryList; // id=3
  final List<Case> caseSpinalList; // id=4
  final List<Case> caseUrineListFilter; // id=1
  final List<Case> caseBloodListFilter; // id=2
  final List<Case> caseRespiratoryListFilter; // id=3
  final List<Case> caseSpinalListFilter; // id=4
  final CaseListStatus status;
  final String caseTag;
  final String patientId;
  final String patientTag;
  final String searchTextUrine;
  final String searchTextBlood;
  final String searchTextRespiratory;
  final String searchTextSpinal;
  final String errorMessage;
  const CaseListPerPatientState({
    this.caseList = const [],
    this.caseUrineList = const [],
    this.caseBloodList = const [],
    this.caseRespiratoryList = const [],
    this.caseUrineListFilter = const [],
    this.caseBloodListFilter = const [],
    this.caseRespiratoryListFilter = const [],
    this.caseSpinalListFilter = const [],
    this.caseSpinalList = const [],
    this.status = CaseListStatus.loading,
    this.caseTag = "",
    this.patientId = "",
    this.patientTag = "",
    this.searchTextUrine = "",
    this.searchTextBlood = "",
    this.searchTextRespiratory = "",
    this.searchTextSpinal = "",
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [
    caseList, caseUrineList, caseBloodList, caseRespiratoryList, caseSpinalList, status, caseTag, patientId,
    caseUrineListFilter, caseBloodListFilter, caseRespiratoryListFilter, caseSpinalListFilter,
    searchTextUrine, searchTextBlood, searchTextRespiratory, searchTextSpinal, errorMessage
  ];

  CaseListPerPatientState copyWith({
    List<Case>? caseList, CaseListStatus? status, String? caseTag, String? patientTag,
    List<Case>? caseUrineList, List<Case>? caseBloodList, List<Case>? caseRespiratoryList, List<Case>? caseSpinalList,
    List<Case>? caseUrineListFilter, List<Case>? caseBloodListFilter, List<Case>? caseRespiratoryListFilter, List<Case>? caseSpinalListFilter,
    String? searchTextUrine, String? searchTextBlood, String? searchTextRespiratory, String? searchTextSpinal, String? errorMessage,
  }){
    return CaseListPerPatientState(
      caseList: caseList ?? this.caseList,
      status: status ?? this.status,
      caseTag: caseTag ?? this.caseTag,
      patientId: this.patientId,
      patientTag: this.patientTag,
      caseBloodList: caseBloodList ?? this.caseBloodList,
      caseUrineList: caseUrineList ?? this.caseUrineList,
      caseRespiratoryList: caseRespiratoryList ?? this.caseRespiratoryList,
      caseSpinalList: caseSpinalList ?? this.caseSpinalList,
      caseUrineListFilter: caseUrineListFilter ?? this.caseUrineListFilter,
      caseBloodListFilter: caseBloodListFilter ?? this.caseBloodListFilter,
      caseRespiratoryListFilter: caseRespiratoryListFilter ?? this.caseRespiratoryListFilter,
      caseSpinalListFilter: caseSpinalListFilter ?? this.caseSpinalListFilter,
      searchTextUrine: searchTextUrine ?? this.searchTextUrine,
      searchTextBlood: searchTextBlood ?? this.searchTextBlood,
      searchTextRespiratory: searchTextRespiratory ?? this.searchTextRespiratory,
      searchTextSpinal: searchTextSpinal ?? this.searchTextSpinal,
      errorMessage: errorMessage?? this.errorMessage,
    );
  }
}