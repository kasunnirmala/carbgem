import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'case_summary_state.dart';
class CaseSummaryCubit extends Cubit<CaseSummaryState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final String caseId;
  final String caseTag;
  final String patientTag;
  final String patientId;
  final String specimenId;

  CaseSummaryCubit(this._authenticationRepository, this._bitteApiClient, this.caseId, this.caseTag, this.patientTag, this.patientId, this.specimenId) : super(CaseSummaryState(
    caseId: caseId, caseName: caseTag, patientId: patientId, patientName: patientTag, specimenId: specimenId,
  )){
    fungiSummaryGet();
  }

  Future<void> fungiSummaryGet() async {
    emit(state.copyWith(status: CaseSummaryStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: CaseSummaryStatus.error, errorMessage: 'Fetching ID Token Failure'));
      } else {
        FungiSummaryAPI fungiSummaryAPI = await _bitteApiClient.fungiSummaryAPI(caseId: state.caseId, idToken: idToken);
        emit(state.copyWith(status: CaseSummaryStatus.success, fungiSummaryAPI: fungiSummaryAPI));
      }
    } on Exception catch (e){
      emit(state.copyWith(status: CaseSummaryStatus.error, errorMessage: e.toString()));
    }
  }
}