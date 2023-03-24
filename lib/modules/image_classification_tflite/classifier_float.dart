// import 'classifier.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
// class ClassifierFloat extends Classifier {
//   ClassifierFloat({int? numThreads}) : super(numThreads: numThreads);
//
//   @override
//   String get modelName => 'model_tflite/model_lite4_300pixels_fp16.tflite';
//
//   @override
//   NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);
//
//   @override
//   NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
// }