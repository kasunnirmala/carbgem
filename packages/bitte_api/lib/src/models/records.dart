import 'package:equatable/equatable.dart';

class Records extends Equatable{
  final List<int> countList;
  final List<String> timeList;
  final int totalUse;
  final int totalLast12;

  const Records({required this.countList, required this.timeList, required this.totalUse, required this.totalLast12});

  @override
  List<Object?> get props => [countList, timeList, totalLast12, totalUse];
  static const empty = Records(countList: [], timeList: [], totalUse: 0, totalLast12: 0);
  static Records fromJson(dynamic json){
    return json!=null ?
    Records(countList: json["point_list"].cast<int>(), timeList: json["time_list"].cast<String>(), totalUse: json["total"], totalLast12: json["last_12"]) :
    Records.empty;
  }
}

class UserRecords extends Equatable{
  final Records inferenceRecord;
  final Records drugRecord;

  const UserRecords({required this.inferenceRecord, required this.drugRecord});

  @override
  List<Object?> get props => [inferenceRecord, drugRecord];
  static const empty = UserRecords(inferenceRecord: Records.empty, drugRecord: Records.empty);
  static UserRecords fromJson(dynamic json){
    return json!=null ?
    UserRecords(inferenceRecord: Records.fromJson(json["inference_record"]), drugRecord: Records.fromJson(json["drug_record"])) :
    UserRecords.empty;
  }
}