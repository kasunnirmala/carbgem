import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bitte_api/bitte_api.dart';

part 'image_classification_result_detail_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos
class ImageClassificationResultDetailCubit extends Cubit<ImageClassificationResultDetailState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final String imageId;
  final String finalJudgement;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final String specimenId;
  ImageClassificationResultDetailCubit(
      this._authenticationRepository, this._bitteApiClient, this.imageId, this.finalJudgement, this.patientId, this.patientName, this.caseId, this.caseName,
      this.specimenId
      ) : super(ImageClassificationResultDetailState(
    imageId: imageId, finalJudgement: finalJudgement, patientId: patientId, patientName: patientName, caseId: caseId, caseName: caseName,
    specimenId: specimenId,
  )){
    getDetectionHistory();
  }

  Future<void> determineFinalFungiJudgement({required String value}) async {
    emit(state.copyWith(status: ImageClassificationResultDetailStatus.loading, selectJudgement: value));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "Fetching ID Token failure"));
      } else if (state.selectJudgement==""){
        emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "No Final Judgement is selected"));
      } else {
        int statusCode = await _bitteApiClient.determineFinalFungiJudgementAPI(fungiJudgementName: state.selectJudgement, historyId: state.fungiResult.historyId, idToken: idToken);
        if (statusCode == 200) {
          emit(state.copyWith(status: ImageClassificationResultDetailStatus.selectFungiSuccess,finalJudgement: state.selectJudgement));
        } else {
          emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "Registering Fungi Judgement API Failure"));
        }
      }
    } on Exception {
      emit(state.copyWith(status: ImageClassificationResultDetailStatus.error));
    }
  }

  Future<void> getDetectionHistory() async {
    emit(state.copyWith(status: ImageClassificationResultDetailStatus.loading));
    try {
      List<FungiType> fungiList = await _bitteApiClient.fungiListFullAPI();
      fungiList.sort((a,b) => a.fungiName.compareTo(b.fungiName));
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "Fetching ID Token Failure"));
      } else {
        FungiResult fungiResult = await _bitteApiClient.getFungiDetectResultAPI(idToken: idToken, imageId: state.imageId);
        bool closeTop2 = ((fungiResult.fungiList[0].confidenceRate-fungiResult.fungiList[1].confidenceRate)<0.1);
        if (closeTop2){
          FungiIndividual fungi1 = await _bitteApiClient.fungiIndividualAPI(fungiId: "${fungiResult.fungiList[0].fungiCode}");
          FungiIndividual fungi2 = await _bitteApiClient.fungiIndividualAPI(fungiId: "${fungiResult.fungiList[1].fungiCode}");
          bool gramNegativeTop2 = ((fungi1.fungiType=="GNC" || fungi1.fungiType=="GNR") && (fungi2.fungiType=="GNC" || fungi2.fungiType=="GNR"));
          emit(state.copyWith(
            fungiResult: fungiResult, status: ImageClassificationResultDetailStatus.success, fungiList: fungiList,
            lowConfidenceScore: false, closeTop2: false, gramNegativeTop2: false,
          ));
        } else {
          emit(state.copyWith(
              fungiResult: fungiResult, status: ImageClassificationResultDetailStatus.success, fungiList: fungiList,
              lowConfidenceScore: false, closeTop2: false
          ));
        }
      }
    } on Exception {
      emit(state.copyWith(status: ImageClassificationResultDetailStatus.error));
    }
  }

  void changeJudgement({required String selectJudgement}){
    emit(state.copyWith(status: ImageClassificationResultDetailStatus.selectFungi, selectJudgement: selectJudgement));
  }
  Future<void> imageDetach() async {
    emit(state.copyWith(status: ImageClassificationResultDetailStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "Fetching ID Token failure"));
      } else {
        int statusCode = await _bitteApiClient.caseDetachAPI(imageIdList: [int.parse(state.imageId)], idToken: idToken);
        if (statusCode == 200) {
          emit(state.copyWith(status: ImageClassificationResultDetailStatus.detachSuccess));
        } else {
          emit(state.copyWith(status: ImageClassificationResultDetailStatus.error, errorMessage: "Detaching Fungi API Failure"));
        }
      }
    } on Exception {
      emit(state.copyWith(status: ImageClassificationResultDetailStatus.error));
    }
  }
}