import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

part 'basic_home_state.dart';

class BasicHomeCubit extends Cubit<BasicHomeState> {
  final bitte.BitteApiClient _bitteApiClient;
  final AuthenticationRepository _authenticationRepository;
  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver _observer;
  BasicHomeCubit(this._bitteApiClient, this._authenticationRepository, this._analytics, this._observer) : super(BasicHomeState()){
    getUser();
  }

  Future<void> getUser() async {
    emit(state.copyWith(status: BasicHomeStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: BasicHomeStatus.failure));
      } else {
        bitte.User bitteUser = await _bitteApiClient.fetchUser(idToken: idToken);
        if (bitteUser.isUserActivated) {
          emit(state.copyWith(status: BasicHomeStatus.activated, currentUser: bitteUser, errorMessage: ""));
        } else {
          emit(state.copyWith(status: BasicHomeStatus.unactivated, currentUser: bitteUser, errorMessage: ""));
        }
      }
    } on Exception catch (e) {
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: BasicHomeStatus.failure, errorMessage: errorMessage));
      _authenticationRepository.logOut();
    }
  }

  void pageChanged({required int value, String? subPageParameter, String? subPageParameter2nd,
    String? subPageParameter3rd, String? subPageParameter4th, String? subPageParameter5th,
    String? subPageParameter6th, String? subPageParameter7th, String? subPageParameter8th,
    String? subPageParameter9th, String? subPageParameter10th, String? subPageParameter11th,
    String? subPageParameter12th, String? subPageParameter13th, String? subPageParameter14th,
    String? subPageParameter15th, bool? subPageParameter16th,
  }) {
    emit(state.copyWithNavigation(pageNavigation: value, subPageParameter: subPageParameter,
      subPageParameter2nd: subPageParameter2nd, subPageParameter3rd: subPageParameter3rd,
      subPageParameter4th: subPageParameter4th, subPageParameter5th: subPageParameter5th,
      subPageParameter6th: subPageParameter6th, subPageParameter7th: subPageParameter7th,
      subPageParameter8th: subPageParameter8th, subPageParameter9th: subPageParameter9th,
      subPageParameter10th: subPageParameter10th, subPageParameter11th: subPageParameter11th,
      subPageParameter12th: subPageParameter12th, subPageParameter13th: subPageParameter13th,
      subPageParameter14th: subPageParameter14th, subPageParameter15th: subPageParameter15th,
      subPageParameter16th: subPageParameter16th
    ));
    if (value==0){
      getUser();
    }
  }

  Future<void> sendAnalyticsEvent() async {
    await _analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string', 'bool': true, 'double': 42.9, 'int':5
      },
    );
  }

  Future<void> eventUploadImageCamera() async {
    await _analytics.logEvent(
      name: 'upload_image_camera',
      parameters: <String, dynamic>{
        'image_source': 'camera', 'from_camera': true, 'double': 42.9, 'int':5
      },
    );
  }
  Future<void> eventUploadImageGallery() async {
    await _analytics.logEvent(
      name: 'upload_image_gallery',
      parameters: <String, dynamic>{
        'image_source': 'gallery', 'from_camera': false, 'double': 42.9, 'int':5
      },
    );
  }
  Future<void> setHomeScreen({required String screenName}) async{
    await _analytics.setCurrentScreen(screenName: screenName);
  }
}