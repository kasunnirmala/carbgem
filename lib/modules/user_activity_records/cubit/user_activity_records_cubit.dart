import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:bitte_api/bitte_api.dart';

part 'user_activity_records_state.dart';
class UserActivityRecordsCubit extends Cubit<UserActivityRecordsState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  UserActivityRecordsCubit(this._authenticationRepository, this._bitteApiClient): super(UserActivityRecordsState()){
    fetchData();
  }
  Future<void> fetchData() async {
    emit(state.copyWith(status: UserActivityRecordsStatus.loading));
    try{
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: UserActivityRecordsStatus.error, errorMessage: "Fetching ID Token Failure"));
      } else {
        UserRecords records = await _bitteApiClient.fetchUserActivityRecordAPI(tokenId: idToken);
        emit(state.copyWith(activityRecord: records, status: UserActivityRecordsStatus.success));
      }
    } on Exception catch (e){
      String errorMessage = getErrorMessage(exception: e);
      emit(state.copyWith(status: UserActivityRecordsStatus.error, errorMessage: errorMessage));
    }
  }
}