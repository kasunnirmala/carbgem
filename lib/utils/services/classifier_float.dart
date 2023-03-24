// import 'package:carbgem/utils/utils.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
// class ClassifierFloat extends Classifier {
//   ClassifierFloat({int? numThreads}) : super(numThreads: numThreads);
//
//   @override
//   String get modelName => 'model_tflite/model_lite4_v3_fp16.tflite';
//
//   @override
//   NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.0, 128.0);
//
//   @override
//   NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
// }