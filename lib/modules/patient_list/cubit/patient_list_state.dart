part of 'patient_list_cubit.dart';

enum PatientListStatus {error, loading, success, addNew, addNewError, addNewSucess, addNewLoading}

class PatientListState extends Equatable{
  final List<Patient> patientlist;
  final List<Patient> filterPatientList;
  final String searchText;
  final PatientListStatus status;
  final String newPatientTag;
  const PatientListState({
    this.patientlist = const [],
    this.status = PatientListStatus.loading,
    this.newPatientTag = "",
    this.filterPatientList = const [],
    this.searchText = '',
  });

  @override
  List<Object?> get props => [patientlist, status, newPatientTag, searchText, filterPatientList];


  PatientListState copyWith({
    List<Patient>? patientlist, PatientListStatus? status, String? newPatientTag,
    String? searchText, List<Patient>? filterPatientList
  }){
    return PatientListState(
      patientlist: patientlist ?? this.patientlist, newPatientTag: newPatientTag?? this.newPatientTag,
      status: status ?? this.status, searchText: searchText?? this.searchText,
      filterPatientList: filterPatientList?? this.filterPatientList,
    );
  }

}
