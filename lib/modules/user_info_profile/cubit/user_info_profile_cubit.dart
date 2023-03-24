import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:carbgem/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'user_info_profile_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when patientlist/password are updated
/// has dependency on authentication repos

class UserInfoProfileCubit extends Cubit<UserInfoProfileState>{
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  UserInfoProfileCubit(this._authenticationRepository, this._bitteApiClient) : super(UserInfoProfileState()){
    getUserInfo();
    getAreaList();
    getHospitalList();
  }

  void userTypeChanged({required SigningCharacter value}){
    if (value==state.selectUserType) return;
    if (state.selectHospitalName == "") {
      emit(state.copyWith(selectUserType: value, status: UserInfoProfileStatus.success));
    } else {
      emit(state.copyWith(selectUserType: value, status: UserInfoProfileStatus.valid));
    }
  }

  Future<void> countryIdChanged({required String value, required TextEditingController hospitalController}) async {
    if (value==state.selectCountryId) return;
    emit(state.copyWith(status: UserInfoProfileStatus.loading));
    try {
      List<AreaAPI> areaList = await _bitteApiClient.getAreaListAPI(countryId: value);
      emit(state.copyWith(
        areaList: (areaList.length>0) ? areaList : [AreaAPI.empty],
        status: UserInfoProfileStatus.success, selectCountryId: value,
        selectAreaId: (areaList.length>0) ? areaList[0].areaId : "",
        selectHospitalName: "",
      ));
      hospitalController.text = "";
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }

  Future<void> areaIdChanged({required String value, required TextEditingController hospitalController}) async {
    if (value==state.selectAreaId) return;
    emit(state.copyWith(status: UserInfoProfileStatus.loading));
    try {
      List<HospitalAPI> hospitalList = await _bitteApiClient.getHospitalListAPI(areaId: value);
      emit(state.copyWith(
        hospitalList: (hospitalList.length>0) ? hospitalList : [HospitalAPI.empty],
        status: UserInfoProfileStatus.success, selectAreaId: value, selectHospitalId: (hospitalList.length>0) ? hospitalList[0].hospitalId : "",
        selectHospitalName: "",
      ));
      hospitalController.text = "";
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }

  void hospitalIdChanged({required String value, required String valueName}){
    emit(state.copyWith(selectHospitalId: value, status: UserInfoProfileStatus.valid, selectHospitalName: valueName));
  }

  void antiBiogramChanged(int value){
    if (value==state.antibiogramType) return;
    emit(state.copyWith(antibiogramType: value,status: UserInfoProfileStatus.valid));
  }

  void getUserInfo() {
    bitte.User user = _bitteApiClient.currentUser;
    emit(state.copyWith(
      currentUser: user, status: UserInfoProfileStatus.success,
      selectUserType: (user.jobTitle=="0") ? SigningCharacter.doctor : (user.jobTitle=="1") ? SigningCharacter.physician : SigningCharacter.others,
      selectCountryId: '${user.countryId}', selectAreaId: '${user.areaId}',
      selectHospitalId: '${user.hospitalId}', selectHospitalName: '${user.hospitalName}',
    ));
  }

  Future<void> getAreaList() async {
    try {
      List<AreaAPI> areaList = await _bitteApiClient.getAreaListAPI(countryId: state.selectCountryId);
      emit(state.copyWith(areaList: (areaList.length>0) ? areaList : [AreaAPI.empty], status: UserInfoProfileStatus.success));
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }

  Future<void> getHospitalList() async {
    try {
      List<HospitalAPI> hospitalList = await _bitteApiClient.getHospitalListAPI(areaId: state.selectAreaId);
      emit(state.copyWith(hospitalList: (hospitalList.length>0) ? hospitalList : [HospitalAPI.empty], status: UserInfoProfileStatus.success));
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }

  Future<void> fetchNewUserInfo() async {
    try{
      String? idToken = await _authenticationRepository.idToken;
      if(idToken==null) {
        emit(state.copyWith(status: UserInfoProfileStatus.error));
      } else {
        bitte.User user = await _bitteApiClient.fetchUser(idToken: idToken);
        emit(state.copyWith(currentUser: user, status: UserInfoProfileStatus.success));
      }
    } on Exception catch (e){
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }
  
  Future<void> modifyUserProfileInfo() async {
    print("user: ${state.selectUserType.index}, country: ${state.selectCountryId}, hospital: ${state.selectHospitalId}");
    try {
      String? idToken = await _authenticationRepository.idToken;
      if(idToken==null) {
        emit(state.copyWith(status: UserInfoProfileStatus.error));
      } else {
        int statusCode = await _bitteApiClient.modifyUserProfile(
          userType: state.selectUserType.index, countryId: int.parse(state.selectCountryId),
          areaId: int.parse(state.selectAreaId), hospitalId: int.parse(state.selectHospitalId), idToken: idToken,
        );
        if (statusCode!=200){
          emit(state.copyWith(status: UserInfoProfileStatus.error));
        } else {
          emit(state.copyWith(status: UserInfoProfileStatus.submissionSuccess));
        }
      }
    } on Exception catch (e) {
      print(e.toString());
      emit(state.copyWith(status: UserInfoProfileStatus.error));
    }
  }
}