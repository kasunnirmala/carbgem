import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';

part 'image_unclassified_delete_state.dart';

class ImageUnclassifiedDeleteCubit extends Cubit<ImageUnclassifiedDeleteState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  ImageUnclassifiedDeleteCubit(this._authenticationRepository, this._bitteApiClient) : super(ImageUnclassifiedDeleteState()){
    getImageList();
  }
  Future<void> getImageList() async {
    emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        List<ImagePath> imageList = await _bitteApiClient.unclassifiedImageToPatientListAPI(idToken: idToken);
        emit(state.copyWith(imageList: imageList, status: ImageUnclassifiedDeleteStatus.initial));
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.error, errorMessage: errorMessage));
    }
  }
  void setDeleteImage({required String imageId}) {
    emit(state.copyWith(selectedImageId: imageId, status: ImageUnclassifiedDeleteStatus.deleteConfirm));
  }
  void resetState() {
    emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.initial));
  }
  Future<void> deleteImage() async {
    emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        int statusCode = await _bitteApiClient.deleteImageAPI(imageIdList: [int.parse(state.selectedImageId)], tokenId: idToken);
        List<ImagePath> imageList = await _bitteApiClient.unclassifiedImageToPatientListAPI(idToken: idToken);
        emit(state.copyWith(imageList: imageList, status: ImageUnclassifiedDeleteStatus.success));
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: ImageUnclassifiedDeleteStatus.error, errorMessage: errorMessage));
    }
  }
}