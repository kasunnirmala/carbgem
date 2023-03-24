import 'package:equatable/equatable.dart';

class HospitalAPI extends Equatable{
  final String hospitalId;
  final String hospitalName;

  const HospitalAPI({required this.hospitalId, required this.hospitalName});

  @override
  List<Object?> get props => [hospitalName, hospitalId];
  static const empty = HospitalAPI(hospitalId: "", hospitalName: "");
  static HospitalAPI fromJson(dynamic json) {
    return json!=null ? HospitalAPI(hospitalId: '${json["id"]}', hospitalName: json["hospital_name"]) : HospitalAPI.empty;
  }
  static List<HospitalAPI> fromJsonList(dynamic json) {
    return json!=null ? List<HospitalAPI>.from(json["hospital_list"].map((model) => HospitalAPI.fromJson(model))) : [HospitalAPI.empty];
  }
}