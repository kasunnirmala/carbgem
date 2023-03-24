import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:equatable/equatable.dart';

part 'patient_list_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when patientlist/password are updated
/// has dependency on authentication repos
class PatientListCubit extends Cubit<PatientListState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  
  PatientListCubit(this._authenticationRepository, this._bitteApiClient) : super(PatientListState()) {
    patientListGet();
  }

  void patientTagChanged(String value) {
    emit(state.copyWith(newPatientTag: value));
  }

  void patientlistChanged(List<Patient> value){
    emit(state.copyWith(patientlist: value, status: PatientListStatus.success));
  }

  void changeStatusSuccess(){
    emit(state.copyWith(status: PatientListStatus.success));
  }

  void searchTextChanged({required String value}) {
    emit(state.copyWith(searchText: value, status: PatientListStatus.loading));
    if (state.searchText!=""){
      List<Patient> tempList = [];
      for (int i=0; i<state.patientlist.length; i++){
        if (state.patientlist[i].patientTag.toLowerCase().contains(state.searchText.toLowerCase())) {
          tempList.add(state.patientlist[i]);
        }
      }
      emit(state.copyWith(filterPatientList: tempList, status: PatientListStatus.success));
    } else {
      emit(state.copyWith(filterPatientList: state.patientlist, status: PatientListStatus.success));
    }
  }

  Future<void> patientListGet() async {
    emit(state.copyWith(status: PatientListStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: PatientListStatus.error));
      } else {
        List<Patient> patientList = await _bitteApiClient.patientListAPI(idToken: idToken);
        emit(state.copyWith(patientlist: patientList, filterPatientList: patientList, status: PatientListStatus.success));
      }
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: PatientListStatus.error));
    }
  }

  Future<void> patientAdd() async {
    emit(state.copyWith(status: PatientListStatus.addNewLoading));
    bool alreadyExist = false;
    for (int i=0; i<state.patientlist.length; i++){
      if (state.patientlist[i].patientTag == state.newPatientTag) {
        alreadyExist = true;
        break;
      }
    }
    if (alreadyExist) {
      emit(state.copyWith(status: PatientListStatus.addNewError));
    } else {
      try {
        String? idToken = await _authenticationRepository.idToken;
        if (idToken == null) {
          emit(state.copyWith(status: PatientListStatus.error));
        } else {
          int statusCode = await _bitteApiClient.patientAddAPI(patientIdTag: state.newPatientTag, idToken: idToken);
          if (statusCode==200) {
            List<Patient> patientList = await _bitteApiClient.patientListAPI(idToken: idToken);
            emit(state.copyWith(status: PatientListStatus.addNewSucess, patientlist: patientList, filterPatientList: patientList));
          } else {
            emit(state.copyWith(status: PatientListStatus.error));
          }
        }
      } on Exception catch (e) {
        print(e.toString());
        emit(state.copyWith(status: PatientListStatus.error));
      }
    }
  }

}