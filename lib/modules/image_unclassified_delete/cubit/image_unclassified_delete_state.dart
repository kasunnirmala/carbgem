part of 'image_unclassified_delete_cubit.dart';
enum ImageUnclassifiedDeleteStatus {error, loading, success, deleteConfirm, initial}
class ImageUnclassifiedDeleteState extends Equatable {
  final List<ImagePath> imageList;
  final String selectedImageId;
  final String errorMessage;
  final ImageUnclassifiedDeleteStatus status;

  const ImageUnclassifiedDeleteState({
    this.imageList = const [], this.selectedImageId = "", this.errorMessage = "",
    this.status = ImageUnclassifiedDeleteStatus.initial,
  });

  @override
  List<Object?> get props => [imageList, selectedImageId, errorMessage, status];

  ImageUnclassifiedDeleteState copyWith({
    List<ImagePath>? imageList, String? selectedImageId, String? errorMessage,
    ImageUnclassifiedDeleteStatus? status,
  }) {
    return ImageUnclassifiedDeleteState(
      imageList: imageList?? this.imageList, selectedImageId: selectedImageId?? this.selectedImageId,
      errorMessage: errorMessage?? this.errorMessage, status: status?? this.status,
    );
  }
}