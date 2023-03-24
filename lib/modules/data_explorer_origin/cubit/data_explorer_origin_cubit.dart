import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/constants/app_constants.dart';
import 'package:equatable/equatable.dart';

part 'data_explorer_origin_state.dart';
class DataExplorerOriginCubit extends Cubit<DataExplorerOriginState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;

  DataExplorerOriginCubit(this._authenticationRepository, this._bitteApiClient): super(DataExplorerOriginState()){
    initiation();
  }
  Future<void> initiation() async{
    emit(state.copyWith(status: DataExplorerOriginStatus.loading));
    List<AreaAPI> areaList = await _bitteApiClient.getAreaListAPI(countryId: japanCode);
    areaList.insert(0, AreaAPI(areaId: '0', areaName: 'JAPAN'));
    List<FungiType> fungiList = await _bitteApiClient.getJANISFungiListAPI(specimenId: state.specimenId);
    if (fungiList.length==0) {
      fungiList.insert(0, FungiType(fungiName: 'ALL', fungiId: 0));
    }
    List<DrugType> drugList =  await _bitteApiClient.getJANISDrugListAPI(specimenId: state.specimenId, fungiId: '${fungiList[0].fungiId}');
    if (drugList.length == 0){
      drugList = [DrugType(drugName: "ALL", drugId: '0', whoAware: 'Uncategorized')];
    }
    List<Antibiogram> dataList = await _bitteApiClient.getBreakdownOriginAPI(
      fungiId: '${fungiList[0].fungiId}', drugId: drugList[0].drugId, specimenId: state.specimenId,
      areaId: areaList[0].areaId, bedSize: state.bedSize, sex: state.sex, origin: state.origin, ageGroup: state.ageGroup,
    );
    emit(state.copyWith(
      areaList: areaList, selectArea: areaList[0], fungiList: fungiList, selectFungi: fungiList[0],
      drugList: drugList, selectDrug: drugList[0], year: janisYearList[0],
      currentTotal: dataList.firstWhere((element) => '${element.year}'==janisYearList[0]).overallTotal,
      status: DataExplorerOriginStatus.success, dataList: dataList,
    ),);
  }
  Future<void> getTSList() async {
    emit(state.copyWith(status: DataExplorerOriginStatus.loading));
    List<Antibiogram> dataList = await _bitteApiClient.getBreakdownOriginAPI(
      fungiId: '${state.selectFungi.fungiId}', drugId: state.selectDrug.drugId, specimenId: state.specimenId,
      areaId: state.selectArea.areaId, bedSize: state.bedSize, sex: state.sex, origin: state.origin, ageGroup: state.ageGroup,
    );
    emit(state.copyWith(dataList: dataList, status: DataExplorerOriginStatus.success));
  }
  Future<void> changeSpecimenType({required String specimenId}) async {
    emit(state.copyWith(status: DataExplorerOriginStatus.loading));
    List<FungiType> fungiList = await _bitteApiClient.getJANISFungiListAPI(specimenId: specimenId);
    if (fungiList.length==0) {
      fungiList.insert(0, FungiType(fungiName: 'ALL', fungiId: 0));
    }
    List<DrugType> drugList =  await _bitteApiClient.getJANISDrugListAPI(specimenId: state.specimenId, fungiId: '${fungiList[0].fungiId}');
    if (drugList.length == 0){
      drugList = [DrugType(drugName: "ALL", drugId: '0', whoAware: 'Uncategorized')];
    }
    emit(state.copyWith(
      fungiList: fungiList, selectFungi: fungiList[0], specimenId: specimenId,
      drugList: drugList, selectDrug: drugList[0],
      status: DataExplorerOriginStatus.success,
    ),);
  }
  Future<void> changeFungiType({required FungiType selectFungi}) async {
    emit(state.copyWith(status: DataExplorerOriginStatus.loading));
    List<DrugType> drugList = await _bitteApiClient.getJANISDrugListAPI(specimenId: state.specimenId, fungiId: '${selectFungi.fungiId}');
    if (drugList.length == 0){
      drugList = [DrugType(drugName: "ALL", drugId: '0', whoAware: 'Uncategorized')];
    }
    emit(state.copyWith(
      drugList: drugList, selectDrug: drugList[0], selectFungi: selectFungi,
      status: DataExplorerOriginStatus.success,
    ),);
  }
  void changeDrugType({required DrugType selectDrug}) {
    emit(state.copyWith(selectDrug: selectDrug));
  }
  Future<void> changeArea({required AreaAPI selectArea}) async {
    emit(state.copyWith(status: DataExplorerOriginStatus.loading));
    List<Antibiogram> dataList = await _bitteApiClient.getBreakdownOriginAPI(
      fungiId: '${state.selectFungi.fungiId}', drugId: state.selectDrug.drugId, specimenId: state.specimenId,
      areaId: selectArea.areaId, bedSize: state.bedSize, sex: state.sex, origin: state.origin, ageGroup: state.ageGroup,
    );
    emit(state.copyWith(dataList: dataList, selectArea: selectArea, status: DataExplorerOriginStatus.success));
  }
  void changeBedSize({required String bedSize}){
    emit(state.copyWith(bedSize: bedSize));
  }
  void changeSex({required String sex}){
    emit(state.copyWith(sex: sex));
  }
  void changeOrigin({required String origin}){
    emit(state.copyWith(origin: origin));
  }
  void changeAgeGroup({required String ageGroup}){
    emit(state.copyWith(ageGroup: ageGroup));
  }
  void changeSelectYear({required String year}){
    emit(state.copyWith(year: year, currentTotal: state.dataList.firstWhere((element) => '${element.year}'==year).overallTotal));
  }
}
