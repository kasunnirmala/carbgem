part of 'image_classification_result_cubit.dart';

enum ImageClassificationResultStatus {loading, error, success}

class ImageClassificationResultState extends Equatable{
  final String imageId;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final FungiResult fungiResult;
  final String finalJudgement;
  final String backNavigator;
  final ImageClassificationResultStatus status;

  const ImageClassificationResultState({
    this.imageId = "",
    this.fungiResult = FungiResult.empty,
    this.finalJudgement ="未確定",
    this.backNavigator = "",
    this.status = ImageClassificationResultStatus.loading,
    this.patientId="", this.patientName="",
    this.caseId="", this.caseName="",
  });

  @override
  List<Object?> get props => [imageId, fungiResult, status, finalJudgement, patientName, patientId, caseName, caseId];

  ImageClassificationResultState copyWithFinalJudgementOnly({String? finalJudgement, ImageClassificationResultStatus? status}){
    return ImageClassificationResultState(
        finalJudgement: finalJudgement ?? this.finalJudgement,
        status: status ?? this.status
        );
  }

  ImageClassificationResultState copyWith({
    String? imageId, FungiResult? fungiResult, ImageClassificationResultStatus? status,
    String? finalJudgement, String? backNavigator, String? patientId, String? patientName,
    String? caseId, String? caseName,
  }){
    return ImageClassificationResultState(
      imageId: imageId ?? this.imageId,
      fungiResult: fungiResult ?? this.fungiResult,
      finalJudgement: finalJudgement?? this.finalJudgement,
      backNavigator: backNavigator ?? this.backNavigator,
      status: status ?? this.status, patientName: patientName ?? this.patientName,
      patientId: patientId?? this.patientId, caseName: caseName ?? this.caseName,
      caseId: caseId ?? this.caseId,
    );
  }
}