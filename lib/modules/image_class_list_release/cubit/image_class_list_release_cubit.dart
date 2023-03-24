import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_class_list_release_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class ImageClassListReleaseCubit extends Cubit<ImageClassListReleaseState>{
  final BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  final String caseId;
  final String caseName;
  final String patientId;
  final String patientName;
  ImageClassListReleaseCubit(this._bitteApiClient, this._authenticationRepository, this.caseId, this.caseName, this.patientId, this.patientName) :
        super(ImageClassListReleaseState(caseId: caseId, caseName: caseName, patientId: patientId, patientName: patientName)){
    imageListGet();
  }

  Future<void> imageListGet() async {
    emit(state.copyWith(status: ImageClassListReleaseStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageClassListReleaseStatus.error, errorMessage: 'Fetching ID Token Failure'));
      } else {
        ImageResult imageResult = await _bitteApiClient.caseImageListAPI(idToken: idToken, caseId: state.caseId);
        emit(state.copyWith(imageList: imageResult.imageList, status: ImageClassListReleaseStatus.success));
      }
    } on Exception catch (e){
      emit(state.copyWith(status: ImageClassListReleaseStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> detachCaseList() async {
    emit(state.copyWith(status: ImageClassListReleaseStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if(idToken == null){
        emit(state.copyWith(status: ImageClassListReleaseStatus.error, errorMessage: 'Fetching ID Token Failure'));
      } else {
        int statusCode = await _bitteApiClient.caseDetachAPI(imageIdList: state.selectedImageIdList, idToken: idToken);
        if (statusCode==200){
          imageListGet();
          emit(state.copyWith(status: ImageClassListReleaseStatus.detachSuccess));
        } else {
          emit(state.copyWith(status: ImageClassListReleaseStatus.error, errorMessage: 'Detaching case API Failure'));
        }
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: ImageClassListReleaseStatus.error, errorMessage: e.toString()));
    }
  }

  void changeSelectedList({required List<int> selectedList}) {
    emit(state.copyWith(selectedImageIdList: selectedList, status: ImageClassListReleaseStatus.success));
  }
}