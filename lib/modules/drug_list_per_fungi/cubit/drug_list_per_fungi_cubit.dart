import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:equatable/equatable.dart';

part 'drug_list_per_fungi_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class DrugListPerFungiCubit extends Cubit<DrugListPerFungiState>{
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  final String fungiId;
  final String fungiName;
  final String finalJudgement;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final int tabIndex;
  final bool descendingSpectrum;
  final bool descendingWhoAware;
  final bool descendingSusceptibility;
  final int sourcePage;
  final String imageId;
  final String specimenId;
  DrugListPerFungiCubit(
      this._authenticationRepository, this._bitteApiClient, this.fungiId, this.fungiName,
      this.finalJudgement, this.caseId, this.caseName, this.patientId, this.patientName,
      this.tabIndex, this.descendingSpectrum, this.descendingWhoAware, this.descendingSusceptibility,
      this.sourcePage, this.imageId, this.specimenId,
      ) : super(DrugListPerFungiState(
    fungiId: fungiId, fungiName: fungiName, finalJudgement: finalJudgement,
    caseId: caseId, caseName: caseName, patientName: patientName,
    patientId: patientId, tabIndex: tabIndex,
    descendingSpectrum: descendingSpectrum, descendingWhoAware: descendingWhoAware,
    descendingSusceptibility: descendingSusceptibility, sourcePage: sourcePage, imageId: imageId, specimenId: specimenId,
  )){
    drugListGet();
  }

  Future<void> drugListGet() async {
    emit(state.copyWith(status: DrugListPerFungiStatus.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: DrugListPerFungiStatus.error, errorMessage: "Fetching ID Token Failure"));
      } else {
        bitte.User currentUser = await _bitteApiClient.fetchUser(idToken: idToken);
        print("hospital Id: ${currentUser.hospitalId}, ${currentUser.hospitalName}");
        List<bitte.DrugAntibiogram> drugList = [];
        List<bitte.DrugAntibiogram> newList = [];
        if (tabIndex==1) {
          /// Call JANIS database
          drugList = await _bitteApiClient.antibiogramDrugInfoFilterAPI(fungiId: state.fungiId, idToken: idToken, areaId: currentUser.areaId);
          newList = List<bitte.DrugAntibiogram>.from(drugList);
        } else {
          /// Call local hospital database - temporarily hardcode in hospital id:
          drugList = await _bitteApiClient.hospitalAntibiogramAPI(fungiId: state.fungiId, hospitalId: currentUser.hospitalId, specimenId: state.specimenId, year: "2020");
          newList = List<bitte.DrugAntibiogram>.from(drugList);
        }
        newList = drugList.where((element) => element.susceptibilityRate>state.threshold).toList();
        if (state.descendingSpectrum) {
          newList.sort((a,b) => b.spectrumScore.compareTo(a.spectrumScore));
        } else {
          newList.sort((a,b) => a.spectrumScore.compareTo(b.spectrumScore));
        }
        emit(state.copyWith(drugList: drugList, displayDrugList: newList, status: DrugListPerFungiStatus.success, currentUser: currentUser));
      }
    } on Exception catch (e){
      emit(state.copyWith(status: DrugListPerFungiStatus.error, errorMessage: e.toString()));
    }
  }

  void changeSortDirectionWhoAware({required bool sortDirection}) {
    emit(state.copyWith(status: DrugListPerFungiStatus.loading));
    if (sortDirection) {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) {
        int aValue = 0;
        int bValue = 0;
        if (a.whoAware=="Reserve") {
          aValue = 1;
        } else if (a.whoAware == "Watch") {
          aValue = 2;
        } else if (a.whoAware == "Access") {
          aValue = 3;
        }
        if (b.whoAware=="Reserve") {
          bValue = 1;
        } else if (b.whoAware == "Watch") {
          bValue = 2;
        } else if (b.whoAware == "Access") {
          bValue = 3;
        }
        return bValue.compareTo(aValue);
      });
      emit(state.copyWith(displayDrugList: newList, descendingWhoAware: sortDirection, status: DrugListPerFungiStatus.success));
    } else {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) {
        int aValue = 0;
        int bValue = 0;
        if (a.whoAware=="Reserve") {
          aValue = 1;
        } else if (a.whoAware == "Watch") {
          aValue = 2;
        } else if (a.whoAware == "Access") {
          aValue = 3;
        }
        if (b.whoAware=="Reserve") {
          bValue = 1;
        } else if (b.whoAware == "Watch") {
          bValue = 2;
        } else if (b.whoAware == "Access") {
          bValue = 3;
        }
        return aValue.compareTo(bValue);
      });
      emit(state.copyWith(displayDrugList: newList, descendingWhoAware: sortDirection, status: DrugListPerFungiStatus.success));
    }
  }

  void changeSortDirectionSusceptibility({required bool sortDirection}) {
    emit(state.copyWith(status: DrugListPerFungiStatus.loading));
    if (sortDirection) {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) => b.susceptibilityRate.compareTo(a.susceptibilityRate));
      emit(state.copyWith(displayDrugList: newList, descendingSusceptibility: sortDirection, status: DrugListPerFungiStatus.success));
    } else {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) => a.susceptibilityRate.compareTo(b.susceptibilityRate));
      emit(state.copyWith(displayDrugList: newList, descendingSusceptibility: sortDirection, status: DrugListPerFungiStatus.success));
    }
  }

  void changeSortDirectionSpectrum({required bool sortDirection}) {
    emit(state.copyWith(status: DrugListPerFungiStatus.loading));
    if (sortDirection) {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) => b.spectrumScore.compareTo(a.spectrumScore));
      emit(state.copyWith(displayDrugList: newList, descendingSpectrum: sortDirection, status: DrugListPerFungiStatus.success));
    } else {
      List<bitte.DrugAntibiogram> newList = new List.from(state.displayDrugList);
      newList.sort((a,b) => a.spectrumScore.compareTo(b.spectrumScore));
      emit(state.copyWith(displayDrugList: newList, descendingSpectrum: sortDirection, status: DrugListPerFungiStatus.success));
    }
  }

  void changeThreshold({required double value}){
    List<bitte.DrugAntibiogram> newList = state.drugList.where((i) => i.susceptibilityRate>value).toList();
    emit(state.copyWith(threshold: value, displayDrugList: newList));
    changeSortDirectionSusceptibility(sortDirection: state.descendingSusceptibility);
  }

  Future<void> selectFungi() async {
    emit(state.copyWith(status: DrugListPerFungiStatus.drugJudgementLoading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null){
        emit(state.copyWith(status: DrugListPerFungiStatus.error, errorMessage: "Fetching ID Token Failure"));
      } else {
        int statusCode = await _bitteApiClient.caseFeedbackFungiAPI(idToken: idToken, caseId: state.caseId, fungiId: state.fungiId);
        if (statusCode != 200){
          emit(state.copyWith(status: DrugListPerFungiStatus.error, errorMessage: "Failure to attach fungi to case"));
        } else {
          emit(state.copyWith(status: DrugListPerFungiStatus.drugJudgement));
        }
      }
    } on Exception catch (e) {
      emit(state.copyWith(status: DrugListPerFungiStatus.error, errorMessage: e.toString()));
    }
  }
}