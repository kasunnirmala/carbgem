part of 'patient_not_classified_image_list_cubit.dart';
enum PatientNotClassifiedImageStatus {error, loading, success}
class PatientNotClassifiedImageState extends Equatable{
  final List<ImagePath> imageList;
  final PatientNotClassifiedImageStatus status;
  final String backValue;
  const PatientNotClassifiedImageState({
    this.imageList = const [],
    this.status = PatientNotClassifiedImageStatus.loading,
    this.backValue = ""
  });

  @override
  List<Object?> get props => [status, imageList];

  PatientNotClassifiedImageState copyWith({List<ImagePath>? imageList, PatientNotClassifiedImageStatus? status, String? backValue}){
    return PatientNotClassifiedImageState(
        imageList: imageList ?? this.imageList, backValue: backValue ?? this.backValue,
        status: status ?? this.status);
  }
}