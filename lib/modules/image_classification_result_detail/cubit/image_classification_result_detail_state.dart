part of 'image_classification_result_detail_cubit.dart';

enum ImageClassificationResultDetailStatus {loading, error, success, selectFungi, selectFungiSuccess, detachSuccess}
class ImageClassificationResultDetailState extends Equatable{
  final String imageId;
  final String finalJudgement;
  final String selectJudgement;
  final String patientId;
  final String patientName;
  final String caseId;
  final String caseName;
  final String errorMessage;
  final String specimenId;
  final bool lowConfidenceScore;
  final bool closeTop2;
  final bool gramNegativeTop2;
  final FungiResult fungiResult;
  final List<FungiType> fungiList;
  final ImageClassificationResultDetailStatus status;
  const ImageClassificationResultDetailState({
    this.imageId = "",
    this.fungiResult = FungiResult.empty,
    this.status = ImageClassificationResultDetailStatus.loading,
    this.finalJudgement="", this.patientName="", this.patientId="",
    this.caseName="", this.caseId="", this.errorMessage="",
    this.selectJudgement = "", this.fungiList = const [FungiType.empty],
    this.specimenId = "", this.lowConfidenceScore=false, this.closeTop2=false,
    this.gramNegativeTop2=false,
  });

  @override
  List<Object?> get props => [
    imageId, fungiResult, status, finalJudgement, patientId,
    patientName, caseId, caseName, errorMessage, selectJudgement, fungiList, specimenId,
    lowConfidenceScore, closeTop2, gramNegativeTop2,
  ];

  ImageClassificationResultDetailState copyWith({
    String? imageId, FungiResult? fungiResult, ImageClassificationResultDetailStatus? status,
    String? finalJudgement, String? patientId, String? patientName, String? caseId, String? caseName,
    String? errorMessage, String? selectJudgement, List<FungiType>? fungiList, String? specimenId,
    bool? lowConfidenceScore, bool? closeTop2, bool? gramNegativeTop2,
  }){
    return ImageClassificationResultDetailState(
      imageId: imageId ?? this.imageId,
      fungiResult: fungiResult ?? this.fungiResult,
      status: status ?? this.status, finalJudgement: finalJudgement?? this.finalJudgement,
      patientName: patientName?? this.patientName, patientId: patientId?? this.patientId,
      caseName: caseName?? this.caseName, caseId: caseId?? this.caseId,
      errorMessage: errorMessage ?? this.errorMessage, selectJudgement: selectJudgement ?? this.selectJudgement,
      fungiList: fungiList?? this.fungiList, specimenId: specimenId?? this.specimenId,
      lowConfidenceScore: lowConfidenceScore?? this.lowConfidenceScore,
      closeTop2: closeTop2?? this.closeTop2,
      gramNegativeTop2: gramNegativeTop2?? this.gramNegativeTop2,
    );
  }
}