import 'package:equatable/equatable.dart';

class ImagePath extends Equatable {
  final String imageId;
  final String imagePath;
  final String imageThumbnail;
  final String modelPrediction;
  final String finalJudgement;

  const ImagePath({
    required this.imageId, required this.imagePath, required this.modelPrediction,
    required this.finalJudgement, required this.imageThumbnail,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [imageId, imagePath, modelPrediction, finalJudgement, imageThumbnail];
  static const empty = ImagePath(imageId: "", imagePath: "", modelPrediction: "", finalJudgement: "", imageThumbnail: "");
  static ImagePath fromJson(dynamic json){
    return ImagePath(
      imageId: "${json["id"]}", imagePath: json["image_path"], finalJudgement: '${json["detection_result"]["fungi_judge_feedback_history"]}',
      modelPrediction: '${json["detection_result"]["fungi_detection_result"]['analysis_result'][0]["fungi_id"]["name"]}',
      imageThumbnail: "${json["image_path_thumbnail"] ?? ''}",
    );
  }
}

class ImageResult extends Equatable{
  final List<ImagePath> imageList;
  final String fungiJudgement;
  final String drugJudgement;

  const ImageResult({required this.imageList, required this.fungiJudgement, required this.drugJudgement});

  @override
  // TODO: implement props
  List<Object?> get props => [imageList, fungiJudgement, drugJudgement];

  static const empty = ImageResult(imageList: [], fungiJudgement: '', drugJudgement: '');
  static ImageResult fromJson(dynamic json) {
    List<ImagePath> imageList = List<ImagePath>.from(json["message"]["image_paths"].map((model) => ImagePath.fromJson(model)));
    if (imageList.length>0){
      final tempMap = <String, int>{};
      for (final image in imageList) {
        tempMap[image.finalJudgement] = tempMap.containsKey(image.finalJudgement) ? tempMap[image.finalJudgement]! + 1 : 1;
      }
      final output = tempMap.keys.toList(growable: false);
      output.sort((k1, k2) => tempMap[k2]!.compareTo(tempMap[k1]!));
      return json!=null ? ImageResult(imageList: imageList, fungiJudgement: json['message']['fungi'], drugJudgement: json['message']['drug']) : ImageResult.empty;
    }
    else {
      return json!=null ? ImageResult(imageList: imageList, fungiJudgement: "未確定", drugJudgement: json['message']['drug']) : ImageResult.empty;
    }
  }
}