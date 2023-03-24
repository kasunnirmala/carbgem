import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:bitte_api/bitte_api.dart';

part 'image_list_per_case_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class ImageListPerCaseCubit extends Cubit<ImageListPerCaseState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final String caseId;
  final String caseTag;
  final String patientTag;
  final String patientId;
  final String specimenId;
  final bool showMenu;
  
  ImageListPerCaseCubit(this._authenticationRepository, this._bitteApiClient, this.caseId, this.caseTag, this.patientId, this.patientTag, this.specimenId, this.showMenu) : super(ImageListPerCaseState(
    caseId: caseId, caseTag: caseTag, patientId: patientId, patientTag: patientTag, specimenId: specimenId, showMenu:  showMenu
  )){
    imageListGet();
  }

  Future<void> imageListGet() async {
    emit(state.copyWith(status: ImageListPerCaseStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageListPerCaseStatus.error, errorMessage: 'Fetching ID Token Failure'));
      } else {
        ImageResult imageResult = await _bitteApiClient.caseImageListAPI(idToken: idToken, caseId: state.caseId);
        emit(state.copyWith(imageResult: imageResult, status: ImageListPerCaseStatus.success));
      }
    } on Exception catch (e){
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: ImageListPerCaseStatus.error, errorMessage: errorMessage));
    }
  }
  Future<void> deleteCase() async {
    emit(state.copyWith(status: ImageListPerCaseStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageListPerCaseStatus.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        int statusCode = await _bitteApiClient.deleteCaseAPI(caseId: state.caseId, tokenId: idToken);
        emit(state.copyWith(status: ImageListPerCaseStatus.deleteSuccess));
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: ImageListPerCaseStatus.error, errorMessage: errorMessage));
    }
  }

  void changeStatus() {
    emit(state.copyWith(status: ImageListPerCaseStatus.deleteConfirm));
  }
  void resetStatus() {
    emit(state.copyWith(status: ImageListPerCaseStatus.success));
  }
}