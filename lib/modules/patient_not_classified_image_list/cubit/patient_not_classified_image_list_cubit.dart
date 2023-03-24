import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'patient_not_classified_image_list_state.dart';
/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class PatientNotClassifiedImageCubit extends Cubit<PatientNotClassifiedImageState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  PatientNotClassifiedImageCubit(this._authenticationRepository, this._bitteApiClient) : super(PatientNotClassifiedImageState()){
    imageListGet();
  }

  Future<void> imageListGet() async {
    emit(state.copyWith(status: PatientNotClassifiedImageStatus.loading));
    try {
      _authenticationRepository.idToken.then((value) {
        if(value==null) {
          emit(state.copyWith(status: PatientNotClassifiedImageStatus.error));
        } else {
          _bitteApiClient.unclassifiedImageToPatientListAPI(idToken: value).then((imageList){
            emit(state.copyWith(imageList: imageList, status: PatientNotClassifiedImageStatus.success));
          }).catchError((e){
            print("error: $e");
            emit(state.copyWith(status: PatientNotClassifiedImageStatus.error));
          });
        }
      });
    } on Exception {
      emit(state.copyWith(status: PatientNotClassifiedImageStatus.error));
    }
  }

  void changeBack(String value){
    emit(state.copyWith(backValue: value));
    imageListGet();
    emit(state.copyWith(backValue: ""));
  }
}