import 'package:equatable/equatable.dart';

class Case extends Equatable{
  final String specimenId;
  final String caseId;
  final String caseTag;
  final int imageTotal;

  const Case({required this.specimenId, required this.caseId, required this.caseTag, required this.imageTotal});

  @override
  // TODO: implement props
  List<Object?> get props => [specimenId, caseId, caseTag, imageTotal];

  static const empty = Case(specimenId: "", caseId: "", caseTag: "", imageTotal: 0);
  static Case fromJson(dynamic json){
    return json!=null ? Case(specimenId: "${json["specimen_id"]}", caseTag: "${json["case_id_tag"]}", caseId: "${json["id"]}", imageTotal: json['number_image']) : Case.empty;
  }
}