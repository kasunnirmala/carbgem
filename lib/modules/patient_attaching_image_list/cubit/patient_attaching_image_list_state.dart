part of 'patient_attaching_image_list_cubit.dart';

enum PatientListStatusInPatientAttaching {error, loading, success, addNew}

class PatientAttachingImageListState extends Equatable{
  final List<Patient> patientList;
  final List<Case> caseList;
  final List<ImagePath> imageList;
  final List selectedImage;
  final String selectedPatientId;
  final String selectedCaseId;
  final String errorMessage;
  final PatientListStatusInPatientAttaching status;
  const PatientAttachingImageListState({
    this.patientList = const [],
    this.caseList = const [],
    this.imageList = const [],
    this.selectedImage = const [],
    this.selectedPatientId = "",
    this.selectedCaseId = "",
    this.status = PatientListStatusInPatientAttaching.loading,
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [patientList, imageList, status, selectedImage, selectedPatientId, selectedCaseId, caseList];

  PatientAttachingImageListState copyWith({
    List<Patient>? patientList, List<ImagePath>? imageList, PatientListStatusInPatientAttaching? status,
    List? selectedImage, String? selectedPatientId, String? errorMessage, List<Case>? caseList, String? selectedCaseId,
  }){
    return PatientAttachingImageListState(
      patientList: patientList ?? this.patientList,
      imageList: imageList ?? this.imageList,
      status: status ?? this.status, selectedImage: selectedImage ?? this.selectedImage,
      selectedPatientId: selectedPatientId ?? this.selectedPatientId,
      errorMessage: errorMessage?? this.errorMessage,
      caseList: caseList?? this.caseList,
      selectedCaseId: selectedCaseId?? this.selectedCaseId,
    );
  }
}