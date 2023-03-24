part of 'data_explorer_origin_cubit.dart';
enum DataExplorerOriginStatus {loading, initial, success, error}
class DataExplorerOriginState extends Equatable{
  final List<AreaAPI> areaList;
  final List<FungiType> fungiList;
  final List<DrugType> drugList;
  final FungiType selectFungi;
  final DrugType selectDrug;
  final String specimenId;
  final String year;
  final String bedSize;
  final String sex;
  final String origin;
  final String ageGroup;
  final AreaAPI selectArea;
  final List<Antibiogram> dataList;
  final DataExplorerOriginStatus status;
  final String errorMessage;
  final int currentTotal;

  const DataExplorerOriginState({
    this.dataList = const [], this.status = DataExplorerOriginStatus.initial,
    this.errorMessage = "", this.areaList = const [], this.fungiList = const [],
    this.drugList = const [], this.selectFungi = FungiType.empty, this.selectDrug = DrugType.empty,
    this.specimenId = "1", this.year = "", this.bedSize = "ALL", this.sex = "ALL",
    this.origin="HO", this.ageGroup="ALL", this.selectArea =AreaAPI.empty,
    this.currentTotal=0,
  });

  @override
  List<Object?> get props => [
    dataList, status, errorMessage, areaList, fungiList, drugList, selectFungi, selectDrug, specimenId, year,
    bedSize, sex, origin, ageGroup, selectArea, currentTotal,
  ];

  DataExplorerOriginState copyWith({
    List<Antibiogram>? dataList, DataExplorerOriginStatus? status, String? errorMessage,
    List<AreaAPI>? areaList, List<FungiType>? fungiList, List<DrugType>? drugList,
    FungiType? selectFungi, DrugType? selectDrug, String? specimenId, String? year, String? bedSize,
    String? sex, String? origin, String? ageGroup, AreaAPI? selectArea, int? currentTotal,
  }){
    return DataExplorerOriginState(
      dataList: dataList?? this.dataList, status: status?? this.status, errorMessage: errorMessage?? this.errorMessage,
      areaList: areaList?? this.areaList, fungiList: fungiList?? this.fungiList, drugList: drugList?? this.drugList,
      selectFungi: selectFungi?? this.selectFungi, selectDrug:  selectDrug?? this.selectDrug, specimenId: specimenId?? this.specimenId,
      year: year?? this.year, bedSize: bedSize?? this.bedSize, sex: sex?? this.sex, origin: origin?? this.origin,
      ageGroup: ageGroup?? this.ageGroup, selectArea: selectArea?? this.selectArea, currentTotal: currentTotal?? this.currentTotal,
    );
  }
}
