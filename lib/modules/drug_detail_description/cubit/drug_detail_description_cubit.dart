import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:equatable/equatable.dart';

part 'drug_detail_description_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class DrugDetailDescriptionCubit extends Cubit<DrugDetailDescriptionState>{
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  final String fungiId;
  final String fungiName;
  final String imageId;
  final String finalJudgement;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final String drugCode;
  final String specimenId;
  final String inputAreaId;
  final String inputAreaName;
  final int sourcePage;
  DrugDetailDescriptionCubit(
      this._authenticationRepository, this._bitteApiClient, this.fungiId, this.fungiName,
      this.imageId, this.finalJudgement, this.caseName, this.caseId, this.patientName,
      this.patientId, this.drugCode, this.specimenId, this.inputAreaId, this.inputAreaName,
      this.sourcePage,
      ) : super(DrugDetailDescriptionState(
    fungiId: fungiId, drugCode: drugCode, specimenId: specimenId, inputAreaId: inputAreaId,
    inputAreaName: inputAreaName, sourcePage: sourcePage, fungiName: fungiName, finalJudgement: finalJudgement,
    patientId: patientId, patientName: patientName, caseName: caseName, caseId: caseId, imageId: imageId,
  )){
    drugInfoGet();
  }

  void changeOrigin({required String value}){
    emit(state.copyWith(origin: value, status: DrugDetailDescriptionStatus.success));
  }
  void changeSex({required String value}){
    emit(state.copyWith(sex: value, status: DrugDetailDescriptionStatus.success));
  }
  void changeAgeGroup({required String value}){
    emit(state.copyWith(ageGroup: value, status: DrugDetailDescriptionStatus.success));
  }
  void changeBedSize({required String value}){
    emit(state.copyWith(bedSize: value, status: DrugDetailDescriptionStatus.success));
  }

  Future<void> drugInfoGet({bool update=false}) async {
    if (update) {
      emit(state.copyWith(status: DrugDetailDescriptionStatus.filterLoading));
    } else {
      emit(state.copyWith(status: DrugDetailDescriptionStatus.loading));
    }
    try {
      String? idToken = await _authenticationRepository.idToken;
      if(idToken==null) {
        emit(state.copyWith(status: DrugDetailDescriptionStatus.error));
      } else {
        bitte.User currentUser = await _bitteApiClient.fetchUser(idToken: idToken);
        bitte.DrugTimeSeriesAnti drugResult = await _bitteApiClient.drugDetailsAPI(
          idToken: idToken, fungiId: state.fungiId, drugCode: state.drugCode,
          specimenId: state.specimenId, areaId: state.inputAreaId!="" ? state.inputAreaId : currentUser.areaId, bedSize: state.bedSize,
          sex: state.sex, origin: state.origin, ageGroup: state.ageGroup,
          hospitalId: currentUser.hospitalId
        );
        emit(state.copyWith(drugTimeSeriesAnti: drugResult, status: DrugDetailDescriptionStatus.success, currentUser: currentUser, areaId: currentUser.areaId));
      }
    } on Exception catch(e) {
      print(e.toString());
      emit(state.copyWith(status: DrugDetailDescriptionStatus.error));
    }
  }

  Future<void> selectDrug() async {
    emit(state.copyWith(status: DrugDetailDescriptionStatus.judgementLoading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if(idToken==null) {
        emit(state.copyWith(status: DrugDetailDescriptionStatus.error));
      } else {
        int statusCode = await _bitteApiClient.caseFeedbackDrugAPI(idToken: idToken, caseId: caseId, drugCode: state.drugTimeSeriesAnti.drugCode);
        if (statusCode!=200) {
          emit(state.copyWith(status: DrugDetailDescriptionStatus.error));
        } else {
          emit(state.copyWith(status: DrugDetailDescriptionStatus.judgementSuccess));
        }
      }
    } on Exception {
      emit(state.copyWith(status: DrugDetailDescriptionStatus.error));
    }
  }
}