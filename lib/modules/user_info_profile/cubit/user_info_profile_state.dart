part of 'user_info_profile_cubit.dart';

enum UserInfoProfileStatus {
  loading, error, success, submissionInProgress, submissionSuccess, valid
}

class UserInfoProfileState extends Equatable{
  final bitte.User currentUser;
  final int antibiogramType;
  final UserInfoProfileStatus status;
  final SigningCharacter selectUserType;
  final String selectCountryId;
  final String selectAreaId;
  final String selectHospitalId;
  final String selectHospitalName;
  final List<CountryAPI> countryList;
  final List<AreaAPI> areaList;
  final List<HospitalAPI> hospitalList;
  const UserInfoProfileState({
    this.currentUser = bitte.User.empty,
    this.antibiogramType = 1,
    this.status = UserInfoProfileStatus.loading,
    this.selectHospitalId="",
    this.selectUserType=SigningCharacter.doctor,
    this.selectCountryId="",
    this.selectAreaId="",
    this.countryList = const [CountryAPI(countryName: "日本", countryId: "109"), CountryAPI(countryName: 'Vietnam', countryId: "240")],
    this.areaList = const [],
    this.hospitalList = const [],
    this.selectHospitalName = "",
  });

  @override
  List<Object?> get props => [
    currentUser, antibiogramType, status, selectUserType, selectCountryId,
    selectAreaId, selectHospitalId, countryList, areaList, hospitalList,
    selectHospitalName,
  ];

  UserInfoProfileState copyWith({
    bitte.User? currentUser, int? antibiogramType, UserInfoProfileStatus? status,
    SigningCharacter? selectUserType, String? selectHospitalId, String? selectAreaId, String? selectCountryId,
    List<CountryAPI>? countryList, List<AreaAPI>? areaList,
    List<HospitalAPI>? hospitalList, String? selectHospitalName,
  }){
    return UserInfoProfileState(
      currentUser: currentUser?? this.currentUser, antibiogramType: antibiogramType?? this.antibiogramType,
      status: status?? this.status, selectUserType: selectUserType?? this.selectUserType,
      selectCountryId: selectCountryId?? this.selectCountryId, selectAreaId: selectAreaId?? this.selectAreaId,
      selectHospitalId: selectHospitalId?? this.selectHospitalId,
      countryList: countryList?? this.countryList, areaList: areaList?? this.areaList,
      hospitalList: hospitalList?? this.hospitalList,
      selectHospitalName: selectHospitalName?? this.selectHospitalName,
    );
  }

}