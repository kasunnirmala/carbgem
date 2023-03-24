import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'patient_attaching_image_list_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class PatientAttachingImageListCubit extends Cubit<PatientAttachingImageListState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;

  PatientAttachingImageListCubit(this._authenticationRepository, this._bitteApiClient) : super(PatientAttachingImageListState()) {
    patientListAndImageListGet();
  }

  Future<void> patientListAndImageListGet() async {
    emit(state.copyWith(status: PatientListStatusInPatientAttaching.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: PatientListStatusInPatientAttaching.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        List<Patient> patientList = await _bitteApiClient.patientListAPI(idToken: idToken);
        List<ImagePath> imageList = await _bitteApiClient.unclassifiedImageToPatientListAPI(idToken: idToken);
        emit(state.copyWith(patientList: patientList, imageList: imageList, status: PatientListStatusInPatientAttaching.success));
      }
    } on Exception {
      emit(state.copyWith(status: PatientListStatusInPatientAttaching.error));
    }
  }

  Future<void> caseListGet() async {
    emit(state.copyWith(status: PatientListStatusInPatientAttaching.loading));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken==null) {
        emit(state.copyWith(status: PatientListStatusInPatientAttaching.error, errorMessage: 'Fetching Id Token Failure'));
      } else {
        List<Case> caseList = await _bitteApiClient.caseListAPI(idToken: idToken, patientId: state.selectedPatientId);
        emit(state.copyWith(caseList: caseList,status: PatientListStatusInPatientAttaching.success));
      }
    } on Exception {
      emit(state.copyWith(status: PatientListStatusInPatientAttaching.error));
    }
  }

  Future<void> attachingPatientNameForImageIds() async {
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: PatientListStatusInPatientAttaching.error));
      } else {
        int statusCode = await _bitteApiClient.attachingPatientCaseImageAPI(idToken: idToken, imageIdsList: state.selectedImage, patientId: state.selectedPatientId, caseId: state.selectedCaseId);
        if (statusCode==200) {
          List<ImagePath> imageListNew = await _bitteApiClient.unclassifiedImageToPatientListAPI(idToken: idToken);
          emit(state.copyWith(imageList: imageListNew, status: PatientListStatusInPatientAttaching.addNew));
        } else {
          emit(state.copyWith(status: PatientListStatusInPatientAttaching.error));
        }
      }
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(status: PatientListStatusInPatientAttaching.error));
    }
  }

  void changeSelection({required List selectedImageId}) {
    emit(state.copyWith(selectedImage: selectedImageId, status: PatientListStatusInPatientAttaching.success));
  }
  void changePatientSelection({required String selectedPatient}) {
    emit(state.copyWith(selectedPatientId: selectedPatient, status: PatientListStatusInPatientAttaching.success));
    caseListGet();
  }
  void changeCaseSelection({required String selectedCase}) {
    emit(state.copyWith(selectedCaseId: selectedCase, status: PatientListStatusInPatientAttaching.success));
  }
}