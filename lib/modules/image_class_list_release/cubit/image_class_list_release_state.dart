part of 'image_class_list_release_cubit.dart';

enum ImageClassListReleaseStatus { loading, success, error, detachSuccess}

class ImageClassListReleaseState extends Equatable{
  final List<int> selectedImageIdList;
  final List<ImagePath> imageList;
  final String caseId;
  final String caseName;
  final String patientId;
  final String patientName;
  final ImageClassListReleaseStatus status;
  final String errorMessage;
  const ImageClassListReleaseState({
    this.selectedImageIdList = const [],
    this.imageList = const [],
    this.patientId = '',
    this.patientName = '',
    this.caseId = '',
    this.caseName = '',
    this.status = ImageClassListReleaseStatus.loading,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
    selectedImageIdList, imageList, caseId, caseName, status, errorMessage,
    patientId, patientName,
  ];

  ImageClassListReleaseState copyWith({
    ImageClassListReleaseStatus? status, List<int>? selectedImageIdList,
    List<ImagePath>? imageList, String? caseId, String? errorMessage,
    String? caseName, String? patientId, String? patientName,
  }){
    return ImageClassListReleaseState(
      status: status ?? this.status, selectedImageIdList: selectedImageIdList?? this.selectedImageIdList,
      imageList: imageList ?? this.imageList, caseId: caseId ?? this.caseId, errorMessage: errorMessage?? this.errorMessage,
      caseName: caseName?? this.caseName, patientId: patientId?? this.patientId, patientName: patientName?? this.patientName,
    );
  }
}