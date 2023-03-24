import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/constants/app_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

part 'infection_map_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class InfectionMapCubit extends Cubit<InfectionMapState>{
  final BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  InfectionMapCubit(this._bitteApiClient, this._authenticationRepository) : super(InfectionMapState(year: janisYearList[0])) {
    initialize();
  }

  Future<void> initialize() async {
    await getFungiList();
    await getDrugList();
    await getInfectionData();
  }

  Future<void> getInfectionData() async {
    emit(state.copyWith(status: InfectionMapStatus.loading));
    // fetch data from bitte api -> emit success
    try{
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: InfectionMapStatus.failure));
      } else {
        List<FungiMapAPI> fungiList = await _bitteApiClient.getAntibiogramMapAPI(
          idToken: idToken, fungiId: state.fungiId, drugId: state.selectDrug.drugId, specimenId: state.specimenId,
          year: state.year, bedSize: state.bedSize, sex: state.sex, origin: state.origin, ageGroup: state.ageGroup,
          whoAware: state.selectDrug.whoAware,
        );
        List<Polygon> shapeList = [];
        List detailList = [];
        for (int i=0; i<fungiList.length; i++) {
          fungiList[i].areaShape.forEach((e) {
            shapeList.add(e);
            detailList.add({
              'susceptible': fungiList[i].susceptible, 'name': fungiList[i].areaName,
              'intermediate': fungiList[i].intermediate, 'resistant': fungiList[i].resistant,
              'nonsusceptible': fungiList[i].nonSusceptible, "area_id": '${fungiList[i].areaId}'
            });
          });
        }
        emit(state.copyWith(antiMapList: fungiList, status: InfectionMapStatus.success,shapeList: shapeList, detailList: detailList));
      }
    } on Exception catch (e){
      print(e.toString());
      emit(state.copyWith(status: InfectionMapStatus.failure));
    }
  }
  
  Future<void> getFungiList() async {
    emit(state.copyWith(status: InfectionMapStatus.loading));
    try {
      List<FungiType> fungiList = await _bitteApiClient.getJANISFungiListAPI(specimenId: state.specimenId);
      if (fungiList.length>0) {
        emit(state.copyWith(fungiList: fungiList, fungiId: '${fungiList[0].fungiId}', status: InfectionMapStatus.success));
      } else {
        emit(state.copyWith(fungiList: fungiList, status: InfectionMapStatus.success));
      }
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: InfectionMapStatus.failure));
    }
  }

  Future<void> getDrugList() async {
    emit(state.copyWith(status: InfectionMapStatus.loading));
    try {
      List<DrugType> drugList = await _bitteApiClient.getJANISDrugListAPI(specimenId: state.specimenId, fungiId: state.fungiId);
      if(drugList.length>0) {
        emit(state.copyWith(drugList: drugList, selectDrug: drugList[0], status: InfectionMapStatus.success));
      } else {
        emit(state.copyWith(drugList: drugList, status: InfectionMapStatus.success));
      }
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: InfectionMapStatus.failure));
    }
  }

  Future<void> changeSpecimenId({required String value}) async {
    emit(state.copyWith(specimenId: value));
    await getFungiList();
    await getDrugList();
    await getInfectionData();
  }

  void changeYear({required String value}) {
    emit(state.copyWith(year: value));
  }

  Future<void> changeFungiId({required String value}) async {
    emit(state.copyWith(fungiId: value));
    await getDrugList();
  }

  void changeDrugId({required value}) {
    emit(state.copyWith(selectDrug: value,));
  }

  void changeBedSize({required String value}) {
    emit(state.copyWith(bedSize: value));
  }

  void changeSex({required String value}) {
    emit(state.copyWith(sex: value));
  }

  void changeOrigin({required String value}) {
    emit(state.copyWith(origin: value));
  }

  void changeAgeGroup({required String value}) {
    emit(state.copyWith(ageGroup: value));
  }
}