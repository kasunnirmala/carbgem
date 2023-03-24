import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String countryId;
  final String countryName;
  final String hospitalId;
  final String hospitalName;
  final String areaName;
  final String areaId;
  final String jobTitle;
  final String phoneNumber;
  final String isActivated;
  final int patientCount;
  final int unsortedCount;
  final int userPoints;

  const User({
    required this.countryId, required this.hospitalId,
    required this.jobTitle, required this.phoneNumber,
    required this.isActivated, required this.countryName,
    required this.hospitalName, required this.areaName,
    required this.patientCount, required this.unsortedCount,
    required this.areaId, required this.userPoints,
  });

  @override
  List<Object?> get props => [
    countryId, countryName, hospitalId, hospitalName, areaId,
    areaName, jobTitle, phoneNumber, isActivated, patientCount, unsortedCount,
    userPoints,
  ];

  static const empty = User(countryId: "", countryName: "", hospitalId: '', hospitalName: "", jobTitle: '',
      phoneNumber: "", isActivated: "", areaName: "", patientCount: 0, unsortedCount: 0, areaId: "", userPoints: 0);

  static User fromJson(dynamic json){
    return json!=null ? User(
      countryId: '${json["country_id"]}', countryName: '${json['country_name']}',
      hospitalId: '${json["hospital_id"]}', hospitalName: '${json['hospital_name']}',
      jobTitle: '${json['user_type']}', phoneNumber: json["phone_number"],
      isActivated: '${json["is_activated"]}', areaName: json['area_name'],
      unsortedCount: json['unsorted_count'], patientCount: json['patient_count'],
      areaId: '${json['area_id']}', userPoints: json['user_point']
    ) : User.empty;
  }
  @override
  String toString() {
    return '$jobTitle';
  }
  // getter to determine whether the current user is empty
  bool get isEmpty => this == User.empty;
  // getter to determine whether the current user is not empty
  bool get isNotEmpty => this != User.empty;
  // getter to determine whether the current user is activated
  bool get isUserActivated => this.isActivated == 'true';
}
