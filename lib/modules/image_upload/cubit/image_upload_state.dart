part of 'image_upload_cubit.dart';
enum ImageUploadStatus {error, loading, success, initial, showMenu, uploadInProgress,
  // status when 3 category model return single -> continue to classify
  successSingle ,
  // status when 3 category model return multi or none -> request reupload image
  successMulti, successNone}
class ImageUploadState extends Equatable{
  final String imageFilePathToUpload;
  final String imageId;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final Fungi3Cat fungi3cat;
  final String specimenId;
  final ImageUploadStatus status;
  final bool lockDiscard;

  const ImageUploadState({
    this.imageFilePathToUpload = '',
    this.imageId = '',
    this.status = ImageUploadStatus.initial,
    this.patientId = "", this.patientName = "",
    this.caseId = "", this.caseName = "",
    this.specimenId = "", this.fungi3cat=Fungi3Cat.empty,
    this.lockDiscard = false,
  });

  @override
  List<Object?> get props => [
    imageFilePathToUpload, imageId, status, patientId, patientName, caseId,
    caseName, specimenId, fungi3cat, lockDiscard
  ];

  ImageUploadState copyWith({
    String? imageFilePathToUpload, String? imageId, ImageUploadStatus? status,
    String? patientId, String? caseId, String? patientName, String? caseName,
    String? specimenId, Fungi3Cat? fungi3cat, bool? lockDiscard
  }){
    return ImageUploadState(
      imageFilePathToUpload: imageFilePathToUpload ?? this.imageFilePathToUpload,
      imageId: imageId?? this.imageId, status: status ?? this.status,
      patientId: patientId?? this.patientId, caseId: caseId ?? this.caseId,
      patientName: patientName?? this.patientName, caseName: caseName?? this.caseName,
      specimenId: specimenId?? this.specimenId, fungi3cat: fungi3cat?? this.fungi3cat,
        lockDiscard: lockDiscard?? this.lockDiscard
    );
  }
}