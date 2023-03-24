import 'package:equatable/equatable.dart';

class AreaAPI extends Equatable{
  final String areaId;
  final String areaName;

  const AreaAPI({required this.areaId, required this.areaName});

  @override
  List<Object?> get props => [areaName, areaId];
  
  static const empty = AreaAPI(areaId: "", areaName: "");
  static AreaAPI fromJson(dynamic json) {
    return json!=null ? AreaAPI(areaId: '${json["id"]}', areaName: json["area_name"]) : AreaAPI.empty;
  }
  static List<AreaAPI> fromJsonList(dynamic json){
    return json!=null? List<AreaAPI>.from(json["area_list"].map((model) => AreaAPI.fromJson(model))) : [AreaAPI.empty];
  }
}