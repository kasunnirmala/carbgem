import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:equatable/equatable.dart';

part 'image_upload_state.dart';

/// manage LoginState, expose APIs to logIn, get notified when email/password are updated
/// has dependency on authentication repos

class ImageUploadCubit extends Cubit<ImageUploadState> {
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final String imagePathUpload;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final String specimenId;
  // final Classifier modelClassifier = ClassifierQuant();
  // final Logger logger = Logger();
  ImageUploadCubit(
    this._authenticationRepository,
    this._bitteApiClient,
    this.imagePathUpload,
    this.patientId,
    this.caseId,
    this.patientName,
    this.caseName,
    this.specimenId,
  ) : super(ImageUploadState(
          imageFilePathToUpload: imagePathUpload,
          patientId: patientId,
          caseId: caseId,
          patientName: patientName,
          caseName: caseName,
          specimenId: (specimenId == "" || specimenId == "unspecified")
              ? "0"
              : specimenId,
        )) {
    print("specimen: ${state.specimenId}");
    // modelClassifier.loadModel();
  }

  void imageFilePathChanged(String value) {
    emit(state.copyWith(
      imageFilePathToUpload: value,
    ));
  }

  Future<void> image3Cat() async {
    emit(state.copyWith(
        status: ImageUploadStatus.uploadInProgress,
        fungi3cat: Fungi3Cat.empty));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageUploadStatus.error));
      } else {
        File imageUpload = File(state.imageFilePathToUpload);
        Fungi3Cat fungi3cat = await _bitteApiClient.fungi3CatAPI(
            uploadImage: imageUpload,
            idToken: idToken,
            caseId: caseId,
            patientId: patientId);
        if (fungi3cat.fungiType == "Single") {
          emit(state.copyWith(
              fungi3cat: fungi3cat, status: ImageUploadStatus.successSingle));
        } else if (fungi3cat.fungiType == "Multiple") {
          emit(state.copyWith(
            fungi3cat: fungi3cat,
            status: ImageUploadStatus.successMulti,
            imageFilePathToUpload: "",
          ));
        } else {
          emit(state.copyWith(
            fungi3cat: fungi3cat,
            status: ImageUploadStatus.successNone,
            imageFilePathToUpload: "",
          ));
        }
      }
    } on Exception {
      emit(state.copyWith(status: ImageUploadStatus.error));
    }
  }

  Future<void> changeStatusInitial() async {
    emit(state.copyWith(status: ImageUploadStatus.initial));
  }

  Future<String> imageJudgement() async {
    // emit(state.copyWith(status: ImageUploadStatus.uploadInProgress));
    emit(state.copyWith(lockDiscard: true));
    try {
      String? idToken = await _authenticationRepository.idToken;
      if (idToken == null) {
        emit(state.copyWith(status: ImageUploadStatus.error));
        return "error";
      } else {
        // get prediction result
        // File imageUpload = File(state.imageFilePathToUpload);
        // img.Image imageInput = img.decodeImage(imageUpload.readAsBytesSync())!;
        // List inferenceResult = modelClassifier.predictTop5(imageInput);
        // String imageId = await _bitteApiClient.fungiTfliteAPI(
        //   uploadImage: imageUpload, idToken: idToken, patientId: state.patientId, caseId: state.caseId,
        //   name1: inferenceResult[0]["fungi_id"]["name"], code1: "${inferenceResult[0]["fungi_id"]["code"]}", rate1: "${inferenceResult[0]["confidence_rate"]}",
        //   name2: inferenceResult[1]["fungi_id"]["name"], code2: "${inferenceResult[1]["fungi_id"]["code"]}", rate2: "${inferenceResult[1]["confidence_rate"]}",
        //   name3: inferenceResult[2]["fungi_id"]["name"], code3: "${inferenceResult[2]["fungi_id"]["code"]}", rate3: "${inferenceResult[2]["confidence_rate"]}",
        //   name4: inferenceResult[3]["fungi_id"]["name"], code4: "${inferenceResult[3]["fungi_id"]["code"]}", rate4: "${inferenceResult[3]["confidence_rate"]}",
        //   name5: inferenceResult[4]["fungi_id"]["name"], code5: "${inferenceResult[4]["fungi_id"]["code"]}", rate5: "${inferenceResult[4]["confidence_rate"]}",
        // );

        String imageId = await _bitteApiClient.fungi15CatAPI(
            imageURL: state.fungi3cat.uploadPath,
            idToken: idToken,
            patientId: state.patientId,
            caseId: state.caseId);
        emit(state.copyWith(
            status: ImageUploadStatus.success, imageId: imageId));
        return imageId;
      }
    } on Exception {
      emit(state.copyWith(status: ImageUploadStatus.error));
      return "error";
    }
  }

  Future<void> changeSpecimenId({required String value}) async {
    emit(state.copyWith(specimenId: value));
  }

  Future<void> rechooseImage() async {
    emit(state.copyWith(
      status: ImageUploadStatus.initial,
      imageFilePathToUpload: "",
    ));
  }
}
