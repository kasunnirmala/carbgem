part of 'infection_map_cubit.dart';

enum InfectionMapStatus {
  initial, loading, success, failure, mapLoading,
}

class InfectionMapState extends Equatable{
  final InfectionMapStatus status;
  final List<FungiMapAPI> antiMapList;
  final List<Polygon> shapeList;
  final List detailList;
  final List<DrugType> drugList;
  final List<FungiType> fungiList;
  final String fungiId;
  final DrugType selectDrug;
  final String specimenId;
  final String year;
  final String bedSize;
  final String sex;
  final String origin;
  final String ageGroup;
  final int sourcePage;
  const InfectionMapState({
    this.status = InfectionMapStatus.initial, this.antiMapList = const [],
    this.fungiId = "",  this.specimenId = "1",
    this.bedSize = "ALL", this.sex = "ALL", this.origin = "ALL",
    this.ageGroup = "ALL", this.year = "2019", this.drugList = const[],
    this.fungiList = const[], this.shapeList = const [], this.detailList = const [],
    this.selectDrug = DrugType.empty,
    this.sourcePage = 0,
  });

  @override
  List<Object?> get props => [
    status, antiMapList, fungiId, selectDrug, specimenId, bedSize, sex,
    origin, ageGroup, year, drugList, fungiList, shapeList, detailList, sourcePage
  ];

  InfectionMapState copyWith({
    InfectionMapStatus? status, List<FungiMapAPI>? antiMapList, String? fungiId,
    DrugType? selectDrug, String? specimenId, String? year, String? bedSize,
    String? sex, String? origin, String? ageGroup, List<DrugType>? drugList,
    List<FungiType>? fungiList, List<Polygon>? shapeList, List? detailList,
    int? sourcePage,
  }){
    return InfectionMapState(
      status: status ?? this.status, antiMapList: antiMapList?? this.antiMapList,
      drugList: drugList?? this.drugList, fungiList: fungiList?? this.fungiList,
      fungiId: fungiId?? this.fungiId, selectDrug: selectDrug?? this.selectDrug,
      specimenId: specimenId?? this.specimenId, year: year?? this.year,
      bedSize: bedSize?? this.bedSize, sex: sex?? this.sex, origin: origin?? this.origin,
      ageGroup: ageGroup?? this.ageGroup, shapeList: shapeList?? this.shapeList,
      detailList: detailList ?? this.detailList,
      sourcePage: sourcePage?? this.sourcePage,
    );
  }

}