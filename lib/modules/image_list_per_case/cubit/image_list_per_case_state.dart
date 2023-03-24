part of 'image_list_per_case_cubit.dart';
enum ImageListPerCaseStatus {loading, error, success, showMenu, deleteConfirm, deleteSuccess}
class ImageListPerCaseState extends Equatable{
  final ImageResult imageResult;
  final String patientId;
  final String patientTag;
  final String caseId;
  final String caseTag;
  final ImageListPerCaseStatus status;
  final String errorMessage;
  final String backMessage;
  final String specimenId;
  final bool showMenu;
  const ImageListPerCaseState({
    this.imageResult = ImageResult.empty,
    this.caseId = '',
    this.status = ImageListPerCaseStatus.loading,
    this.errorMessage = '',
    this.backMessage = '',
    this.caseTag = "",
    this.patientTag="",
    this.patientId="",
    this.specimenId="",
    this.showMenu=false,
  });

  @override
  List<Object?> get props => [imageResult, caseId, status, errorMessage, caseTag, patientTag, patientId, specimenId, showMenu];

  ImageListPerCaseState copyWith({
    ImageResult? imageResult, String? caseId, ImageListPerCaseStatus? status,
    String? errorMessage, String? backMessage, String? caseTag,
    String? patientId, String? patientTag, String? specimenId, bool? showMenu
  }){
    return ImageListPerCaseState(
      imageResult: imageResult ?? this.imageResult,
      caseId: caseId ?? this.caseId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      backMessage: backMessage ?? this.backMessage,
      caseTag: caseTag ?? this.caseTag,
      patientTag: patientTag?? this.patientTag,
      patientId: patientId?? this.patientId,
      specimenId: specimenId?? this.specimenId,
        showMenu: showMenu?? this.showMenu
    );
  }
}