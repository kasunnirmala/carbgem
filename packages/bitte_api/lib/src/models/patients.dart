import 'package:equatable/equatable.dart';

class Patient extends Equatable{
  final String patientId;
  final String patientTag;
  final int caseNumber;

  const Patient({required this.patientId, required this.patientTag, required this.caseNumber});

  @override
  // TODO: implement props
  List<Object?> get props => [patientId, patientTag, caseNumber];
  static const empty = Patient(patientId: "", patientTag: "", caseNumber: 0);
  static Patient fromJson(dynamic json){
    return json!=null ? Patient(patientId: '${json["id"]}', patientTag: '${json["patient_id_tag"]}', caseNumber: json['case_number']) : Patient.empty;
  }
}