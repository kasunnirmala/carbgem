import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bitte_api/bitte_api.dart';

part 'image_classification_result_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class ImageClassificationResultCubit extends Cubit<ImageClassificationResultState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final String imageId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String caseId;
  ImageClassificationResultCubit(
      this._authenticationRepository, this._bitteApiClient, this.imageId,
      this.patientName, this.patientId, this.caseName, this.caseId,
      ) : super(ImageClassificationResultState(
    imageId: imageId, patientId: patientId, patientName: patientName,
    caseId: caseId, caseName: caseName,
  )){
    getDetectionHistory();
  }

  Future<void> getDetectionHistory() async {
    emit(state.copyWith(status: ImageClassificationResultStatus.loading));
    try {
      _authenticationRepository.idToken.then((value) {
        if (value == null) {
         throw Exception();
        } else {
          _bitteApiClient.getFungiDetectResultAPI(
              idToken: value, imageId: state.imageId).then((fungiResult) {
            _bitteApiClient.getFinalJudgement(idToken: value, imageId: state.imageId).then((finalJudgement) {
              emit(state.copyWith(finalJudgement: finalJudgement,
                  status: ImageClassificationResultStatus.success, fungiResult: fungiResult));
            });
          }).catchError((e) {
            emit(state.copyWith(
                status: ImageClassificationResultStatus.error));
          });
        }
      });
    } on Exception {
      emit(state.copyWith(
          status: ImageClassificationResultStatus.error));
    }
  }

  void changeBack({required String backValue}) {
    emit(state.copyWith(backNavigator: backValue));
    getDetectionHistory();
    emit(state.copyWith(backNavigator: ""));
  }
}