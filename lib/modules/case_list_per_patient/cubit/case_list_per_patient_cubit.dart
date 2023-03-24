import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';

part 'case_list_per_patient_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos
class CaseListPerPatientCubit extends Cubit<CaseListPerPatientState>{
  final String patientId;
  final String patientName;
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  
  CaseListPerPatientCubit(this._authenticationRepository, this._bitteApiClient, this.patientId, this.patientName) : super(CaseListPerPatientState(patientId: patientId, patientTag: patientName)){
    caseListGet();
    print(state.caseSpinalList);
  }

  void caseListChanged(List<Case> value){
    emit(state.copyWith(caseList: value,));
  }
  void caseTagChanged(String value){
    emit(state.copyWith(caseTag: value,));
  }

  Future<void> caseListGet() async {
    emit(state.copyWith(status: CaseListStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: CaseListStatus.error, errorMessage: "Failure to fetch user ID Token"));
      } else {
        List<Case> caseList = await _bitteApiClient.caseListAPI(idToken: idToken, patientId: state.patientId);
        print(caseList);
        List<Case> tempUrineList =  [];
        List<Case> tempBloodList =  [];
        List<Case> tempRespiratoryList =  [];
        List<Case> tempSpinalList =  [];
        for (int i=0; i<caseList.length; i++){
          if (caseList[i].specimenId=="1") {
            tempUrineList.add(caseList[i]);
          } else if (caseList[i].specimenId=="2"){
            tempBloodList.add(caseList[i]);
          } else if (caseList[i].specimenId=="3") {
            tempRespiratoryList.add(caseList[i]);
          } else {
            tempSpinalList.add(caseList[i]);
          }
        }
        emit(state.copyWith(
          caseList: caseList, caseSpinalList: tempSpinalList, caseRespiratoryList: tempRespiratoryList,
          caseUrineList: tempUrineList, caseBloodList: tempBloodList, status: CaseListStatus.success,
          caseUrineListFilter: tempUrineList, caseBloodListFilter: tempBloodList, caseSpinalListFilter: tempSpinalList,
          caseRespiratoryListFilter: tempRespiratoryList,
        ));
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: CaseListStatus.error, errorMessage: errorMessage));
    }
  }

  Future<void> caseAdd({required String specimenId}) async {
    emit(state.copyWith(status: CaseListStatus.loading));
    bool alreadyExist = false;
    if (specimenId=="1") {
      for (int i=0; i<state.caseUrineList.length; i++){
        if (state.caseUrineList[i].caseTag == state.caseTag) {
          alreadyExist = true;
          break;
        }
      }
    } else if (specimenId=="2") {
      for (int i=0; i<state.caseBloodList.length; i++){
        if (state.caseBloodList[i].caseTag == state.caseTag) {
          alreadyExist = true;
          break;
        }
      }
    } else if (specimenId=="3") {
      for (int i=0; i<state.caseRespiratoryList.length; i++){
        if (state.caseRespiratoryList[i].caseTag == state.caseTag) {
          alreadyExist = true;
          break;
        }
      }
    } else if (specimenId == "4") {
      for (int i=0; i<state.caseSpinalList.length; i++){
        if (state.caseSpinalList[i].caseTag == state.caseTag) {
          alreadyExist = true;
          break;
        }
      }
    }
    if (alreadyExist) {
      if (specimenId=="1") {
        emit(state.copyWith(status: CaseListStatus.addNewUrineError));
      } else if (specimenId=="2") {
        emit(state.copyWith(status: CaseListStatus.addNewBloodError));
      } else if (specimenId == "3") {
        emit(state.copyWith(status: CaseListStatus.addNewRespiratoryError));
      } else if (specimenId == "4") {
        emit(state.copyWith(status: CaseListStatus.addNewSpinalError));
      }
    } else {
      try {
        String? idToken = await _authenticationRepository.idToken;
        if (idToken==null) {
          emit(state.copyWith(status: CaseListStatus.error));
        } else {
          int responseStatus = await _bitteApiClient.caseAddAPI(caseTag: state.caseTag, specimenId: specimenId, patientId: patientId, idToken: idToken);
          if (responseStatus==200) {
            List<Case> caseList = await _bitteApiClient.caseListAPI(idToken: idToken, patientId: state.patientId);
            List<Case> tempUrineList =  [];
            List<Case> tempBloodList =  [];
            List<Case> tempRespiratoryList =  [];
            List<Case> tempSpinalList =  [];
            for (int i=0; i<caseList.length; i++){
              if (caseList[i].specimenId=="1") {
                tempUrineList.add(caseList[i]);
              } else if (caseList[i].specimenId=="2"){
                tempBloodList.add(caseList[i]);
              } else if (caseList[i].specimenId=="3") {
                tempRespiratoryList.add(caseList[i]);
              } else {
                tempSpinalList.add(caseList[i]);
              }
            }
            if (specimenId=="1") {
              emit(state.copyWith(
                status: CaseListStatus.addNewUrineSuccess,
                caseList: caseList, caseSpinalList: tempSpinalList, caseRespiratoryList: tempRespiratoryList,
                caseUrineList: tempUrineList, caseBloodList: tempBloodList,
                caseUrineListFilter: tempUrineList, caseBloodListFilter: tempBloodList, caseSpinalListFilter: tempSpinalList,
                caseRespiratoryListFilter: tempRespiratoryList,
              ));
            } else if (specimenId=="2") {
              emit(state.copyWith(
                status: CaseListStatus.addNewBloodSuccess,
                caseList: caseList, caseSpinalList: tempSpinalList, caseRespiratoryList: tempRespiratoryList,
                caseUrineList: tempUrineList, caseBloodList: tempBloodList,
                caseUrineListFilter: tempUrineList, caseBloodListFilter: tempBloodList, caseSpinalListFilter: tempSpinalList,
                caseRespiratoryListFilter: tempRespiratoryList,
              ));
            } else if (specimenId=="3") {
              emit(state.copyWith(
                status: CaseListStatus.addNewRespiratorySuccess,
                caseList: caseList, caseSpinalList: tempSpinalList, caseRespiratoryList: tempRespiratoryList,
                caseUrineList: tempUrineList, caseBloodList: tempBloodList,
                caseUrineListFilter: tempUrineList, caseBloodListFilter: tempBloodList, caseSpinalListFilter: tempSpinalList,
                caseRespiratoryListFilter: tempRespiratoryList,
              ));
            } else {
              emit(state.copyWith(
                status: CaseListStatus.addNewSpinalSuccess,
                caseList: caseList, caseSpinalList: tempSpinalList, caseRespiratoryList: tempRespiratoryList,
                caseUrineList: tempUrineList, caseBloodList: tempBloodList,
                caseUrineListFilter: tempUrineList, caseBloodListFilter: tempBloodList, caseSpinalListFilter: tempSpinalList,
                caseRespiratoryListFilter: tempRespiratoryList,
              ));
            }
          } else {
            if (specimenId=="1") {
              emit(state.copyWith(status: CaseListStatus.addNewUrineError));
            } else if (specimenId=="2") {
              emit(state.copyWith(status: CaseListStatus.addNewBloodError));
            } else if (specimenId=="3") {
              emit(state.copyWith(status: CaseListStatus.addNewRespiratoryError));
            } else {
              emit(state.copyWith(status: CaseListStatus.addNewSpinalError));
            }
          }
        }
      } on Exception catch (e) {
        String errorMessage = getErrorMessage(exception: e);
        emit(state.copyWith(status: CaseListStatus.error, errorMessage: errorMessage));
      }
    }
  }

  void searchTextChangedUrine({required String value}) {
    emit(state.copyWith(searchTextUrine: value, status: CaseListStatus.loading));
    if (state.searchTextUrine!=""){
      List<Case> tempList = [];
      for (int i=0; i<state.caseUrineList.length; i++){
        if (state.caseUrineList[i].caseTag.toLowerCase().contains(state.searchTextUrine.toLowerCase())) {
          tempList.add(state.caseUrineList[i]);
        }
      }
      emit(state.copyWith(caseUrineListFilter: tempList, status: CaseListStatus.success));
    } else {
      emit(state.copyWith(caseUrineListFilter: state.caseUrineList, status: CaseListStatus.success));
    }
  }
  void searchTextChangedBlood({required String value}) {
    emit(state.copyWith(searchTextBlood: value, status: CaseListStatus.loading));
    if (state.searchTextBlood!=""){
      List<Case> tempList = [];
      for (int i=0; i<state.caseBloodList.length; i++){
        if (state.caseBloodList[i].caseTag.toLowerCase().contains(state.searchTextBlood.toLowerCase())) {
          tempList.add(state.caseBloodList[i]);
        }
      }
      emit(state.copyWith(caseBloodListFilter: tempList, status: CaseListStatus.success));
    } else {
      emit(state.copyWith(caseBloodListFilter: state.caseBloodList, status: CaseListStatus.success));
    }
  }
  void searchTextChangedRespiratory({required String value}) {
    emit(state.copyWith(searchTextRespiratory: value, status: CaseListStatus.loading));
    if (state.searchTextRespiratory!=""){
      List<Case> tempList = [];
      for (int i=0; i<state.caseRespiratoryList.length; i++){
        if (state.caseRespiratoryList[i].caseTag.toLowerCase().contains(state.searchTextRespiratory.toLowerCase())) {
          tempList.add(state.caseRespiratoryList[i]);
        }
      }
      emit(state.copyWith(caseRespiratoryListFilter: tempList, status: CaseListStatus.success));
    } else {
      emit(state.copyWith(caseRespiratoryListFilter: state.caseRespiratoryList, status: CaseListStatus.success));
    }
  }
  void searchTextChangedSpinal({required String value}) {
    emit(state.copyWith(searchTextSpinal: value, status: CaseListStatus.loading));
    if (state.searchTextSpinal!=""){
      List<Case> tempList = [];
      for (int i=0; i<state.caseSpinalList.length; i++){
        if (state.caseSpinalList[i].caseTag.toLowerCase().contains(state.searchTextSpinal.toLowerCase())) {
          tempList.add(state.caseSpinalList[i]);
        }
      }
      emit(state.copyWith(caseSpinalListFilter: tempList, status: CaseListStatus.success));
    } else {
      emit(state.copyWith(caseSpinalListFilter: state.caseSpinalList, status: CaseListStatus.success));
    }
  }
  Future<void> deletePatient() async {
    emit(state.copyWith(status: CaseListStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: CaseListStatus.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        int statusCode = await _bitteApiClient.deletePatientAPI(patientId: state.patientId, tokenId: idToken);
        emit(state.copyWith(status: CaseListStatus.deleteSuccess));
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: CaseListStatus.error, errorMessage: errorMessage));
    }
  }
  void changeStatus() {
    emit(state.copyWith(status: CaseListStatus.deleteConfirm));
  }
  void resetStatus() {
    emit(state.copyWith(status: CaseListStatus.success));
  }
}
