import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Fungi3Cat extends Equatable{
  final String uploadPath;
  final String fungiType;

  const Fungi3Cat({required this.uploadPath, required this.fungiType});

  @override
  List<Object?> get props => [uploadPath, fungiType];
  static const empty = Fungi3Cat(uploadPath: "", fungiType: "");
  static Fungi3Cat fromJson(dynamic json){
    return json!=null ? Fungi3Cat(uploadPath: json["upload_path"], fungiType: json["is_fungi"]) : Fungi3Cat.empty;
  }
}

class FungiIndividual extends Equatable {
  final String fungiName;
  final String fungiType;
  final int fungiId;

  const FungiIndividual({required this.fungiName,required this.fungiType,required this.fungiId});

  @override
  List<Object?> get props => [fungiName, fungiId, fungiType];
  static const empty = FungiIndividual(fungiName: "", fungiType: "", fungiId: 0);
  static FungiIndividual fromJson(dynamic json){
    return json!=null ?
    FungiIndividual(fungiName: json["fungi_detail"]["fungi_name"], fungiType: json["fungi_detail"]["fungi_type"], fungiId: json["fungi_detail"]["id"]) :
    FungiIndividual.empty;
  }
}

class FungiList extends Equatable{
  final String imagePath;
  final String imageId;

  const FungiList({required this.imagePath, required this.imageId});

  @override
  List<Object?> get props => [imageId, imagePath];
  static const empty = FungiList(imagePath: "", imageId: "");
  static FungiList fromJson(dynamic json){
    return json!=null ? FungiList(imagePath: "${json["specimen_id"]}", imageId: "${json["case_id_tag"]}") : FungiList.empty;
  }
}

class FungiDetectResult extends Equatable{
  final String fungiName;
  final int fungiCode;
  final double confidenceRate;

  const FungiDetectResult({required this.fungiName, required this.confidenceRate, required this.fungiCode});

  @override
  List<Object?> get props => [fungiName, fungiCode, confidenceRate];
  
  static const empty = FungiDetectResult(fungiName: "", confidenceRate: 0.0, fungiCode: 0);
  static FungiDetectResult fromJson(dynamic json) {
    return json!=null ? FungiDetectResult(fungiName: json["fungi_id"]["name"], confidenceRate: json["confidence_rate"], fungiCode: json['fungi_id']['code']) : FungiDetectResult.empty;
  }
}

class FungiResult extends Equatable{
  final List<FungiDetectResult> fungiList;
  final String imagePath;
  final String imagePrep;
  final String imageGrad;
  final String historyId;
  final String caseId;

  const FungiResult({required this.fungiList, required this.imagePath, required this.historyId, required this.imagePrep, required this.imageGrad, required this.caseId});

  @override
  List<Object?> get props => [caseId, fungiList, imagePath, imageGrad, imagePrep];

  static const empty = FungiResult(fungiList: [], imagePath: "", historyId: "", imageGrad: "", imagePrep: "", caseId: "");
  static FungiResult fromJson(dynamic json) {
    List<FungiDetectResult> outList = List<FungiDetectResult>.from(json['detection_result']["fungi_detection_result"]['analysis_result'].map((model) => FungiDetectResult.fromJson(model)));
    return json!=null ? FungiResult(
      imagePath: json["detection_result"]["image_paths"],fungiList: outList, historyId: "${json['detection_result']["id"]}",
      imageGrad: json['detection_result']['image_path_interpret'], imagePrep: json['detection_result']['image_path_preprocess'],
      caseId: '${json['case_id']}',
    ) : FungiResult.empty;
  }
}

class FungiType extends Equatable {
  final String fungiName;
  final int fungiId;

  const FungiType({required this.fungiName, required this.fungiId});

  @override
  List<Object?> get props => [fungiName, fungiId];
  
  static const empty = FungiType(fungiName: "", fungiId: 0);
  static FungiType fromJson(dynamic json) {
    return json!=null ? FungiType(fungiName: json["fungi_name"], fungiId: json['id']) : FungiType.empty;
  }
  static List<FungiType> fromJsonList(dynamic json) {
    List<FungiType> outList = List<FungiType>.from(json['fungi_list'].map((model) => FungiType.fromJson(model)));
    return json!=null ? outList : [FungiType.empty];
  }
}

class FungiSummary extends Equatable{
  final String fungiName;
  final int fungiId;
  final int count;

  const FungiSummary({required this.fungiName, required this.fungiId, required this.count});

  @override
  List<Object?> get props => [fungiName, fungiId, count];
  
  static const empty = FungiSummary(fungiName: "", fungiId: 0, count: 0);
  static FungiSummary fromJson(dynamic json) {
    return json!=null ? FungiSummary(fungiName: json['fungi_name'], fungiId: json['fungi_id'], count: json['count']) : FungiSummary.empty;
  }
}

class FungiSummaryAPI extends Equatable{
  final int totalImage;
  final List<FungiSummary> summaryList;
  final FungiSummary unsorted;
  final String fungiJudgement;
  final String drugJudgement;

  const FungiSummaryAPI({required this.totalImage, required this.summaryList, required this.unsorted, required this.fungiJudgement, required this.drugJudgement});

  @override
  List<Object?> get props => [totalImage, summaryList, unsorted, fungiJudgement, drugJudgement,];

  static const empty = FungiSummaryAPI(totalImage: 0, summaryList: [], unsorted: FungiSummary.empty, fungiJudgement: "", drugJudgement: "");
  static FungiSummaryAPI fromJson(dynamic json){
    List<FungiSummary> outList = List<FungiSummary>.from(json['images_details'].map((model) => FungiSummary.fromJson(model)));
    FungiSummary unsorted = FungiSummary.fromJson(json['unsorted']);
    if (outList.length>0){
      final tempMap = <String, int>{};
      for (final image in outList) {
        tempMap[image.fungiName] = tempMap.containsKey(image.fungiName) ? tempMap[image.fungiName]! + 1 : 1;
      }
      final output = tempMap.keys.toList(growable: false);
      output.sort((k1, k2) => tempMap[k2]!.compareTo(tempMap[k1]!));
      return json!=null ? FungiSummaryAPI(
        totalImage: json['total_images'], summaryList: outList, unsorted: unsorted,
        fungiJudgement: json['fungi_judgement'], drugJudgement: json['drug_judgement'],
      ) : FungiSummaryAPI.empty;
    }else {
      return json!=null ? FungiSummaryAPI(
        totalImage: json['total_images'], summaryList: outList, unsorted: unsorted,
        fungiJudgement: json['fungi_judgement'], drugJudgement: json['drug_judgement'],
      ) : FungiSummaryAPI.empty;
    }
  }
}

class FungiMapAPI extends Equatable {
  final int areaId;
  final String areaName;
  final List<Polygon> areaShape;
  final int resistant;
  final int intermediate;
  final int nonSusceptible;
  final int susceptible;
  final int unknown;

  const FungiMapAPI({
    required this.areaId, required this.areaName, required this.areaShape,
    required this.resistant, required this.intermediate, required this.nonSusceptible,
    required this.susceptible, required this.unknown,
  });

  @override
  List<Object?> get props => [areaId, areaName, areaShape, resistant, intermediate, nonSusceptible, susceptible, unknown];

  static const empty = FungiMapAPI(
    areaId: 0, areaName: '', areaShape: [], resistant: 0, intermediate: 0,
    nonSusceptible: 0, susceptible: 0, unknown: 0,
  );
  static FungiMapAPI fromJson({
    required dynamic json, required double percentile01,
    required double percentile02, required double percentile03, required double percentile04,
    required double percentile05, required double percentile06, required double percentile07,
    required double percentile08, required double percentile09, required String whoAware,
  }){
    List<Polygon> areaShape;
    double tileValue = (json['susceptible']/(json['susceptible'] + json['resistant'] + json['intermediate'] + json['intermediate']));
    Color tileColor = getTileColor(whoAware: whoAware, tileValue: tileValue, percentile01: percentile01,
      percentile02: percentile02, percentile03: percentile03, percentile04: percentile04, percentile05: percentile05,
      percentile06: percentile06, percentile07: percentile07, percentile08: percentile08, percentile09: percentile09,
    );
    if (json['shape_polygon'].length == 1) {
      areaShape = List<Polygon>.from(json["shape_polygon"].map((model) {
        List<LatLng> latLngList = List<LatLng>.from(model.map((value) => LatLng(value[1], value[0])));
        return Polygon(points: latLngList, borderColor: Colors.white, borderStrokeWidth: 1, color: tileColor);
      }));
    } else {
      areaShape = List<Polygon>.from(json['shape_polygon'].map((model) {
        List<LatLng> latLngList = List<LatLng>.from(model[0].map((value) => LatLng(value[1], value[0])));
        return Polygon(points: latLngList, borderColor: Colors.white, borderStrokeWidth: 1, color: tileColor);
      }));
    }
    return json!=null ? FungiMapAPI(
      areaId: json['area_id'], areaName: json['area_name'], areaShape: areaShape,
      resistant: json['resistant'], intermediate: json['intermediate'],
      nonSusceptible: json['non_susceptible'], susceptible: json['susceptible'],
      unknown: json['unknown'],
    ) : FungiMapAPI.empty;
  }
  static List<FungiMapAPI> fromJsonList({required dynamic json, required String whoAware}) {
    List<double> susList = List<double>.from(json['antibiogram'].map(
          (model) => (model['susceptible']/(model['susceptible'] + model['resistant'] + model['intermediate'] + model['intermediate'])),
    ));
    List<double> sortedList = List<double>.from(susList);
    sortedList.sort((a,b) => a.compareTo(b));
    final double percentile01 = sortedList[(0.1*sortedList.length).ceil()-1];
    final double percentile02 = sortedList[(0.2*sortedList.length).ceil()-1];
    final double percentile03 = sortedList[(0.3*sortedList.length).ceil()-1];
    final double percentile04 = sortedList[(0.4*sortedList.length).ceil()-1];
    final double percentile05 = sortedList[(0.5*sortedList.length).ceil()-1];
    final double percentile06 = sortedList[(0.6*sortedList.length).ceil()-1];
    final double percentile07 = sortedList[(0.7*sortedList.length).ceil()-1];
    final double percentile08 = sortedList[(0.8*sortedList.length).ceil()-1];
    final double percentile09 = sortedList[(0.9*sortedList.length).ceil()-1];
    return json!=null? List<FungiMapAPI>.from(json['antibiogram'].map((model) => FungiMapAPI.fromJson(
      json: model, whoAware: whoAware, percentile01: percentile01, percentile02: percentile02, percentile03: percentile03,
      percentile04: percentile04, percentile05: percentile05, percentile06: percentile06, percentile07: percentile07,
      percentile08: percentile08, percentile09: percentile09,
    ))) : [FungiMapAPI.empty];
  }
}
Color getTileColor({
  required String whoAware, required double tileValue, required double percentile01,
  required double percentile02, required double percentile03, required double percentile04,
  required double percentile05, required double percentile06, required double percentile07,
  required double percentile08, required double percentile09
}) {
  double opacity = 0.6;
  if (whoAware=="Access") {
    if (tileValue<=percentile01) {
      return HexColorV('#eefaee').withOpacity(opacity);
    } else if (tileValue<=percentile02) {
      return HexColorV('#c7f1c7').withOpacity(opacity);
    } else if (tileValue<=percentile03) {
      return HexColorV('#a0e7a0').withOpacity(opacity);
    } else if (tileValue<=percentile04) {
      return HexColorV('#79dd79').withOpacity(opacity);
    } else if (tileValue<=percentile05) {
      return HexColorV('#52d352').withOpacity(opacity);
    } else if (tileValue<=percentile06) {
      return HexColorV('#30c330').withOpacity(opacity);
    } else if (tileValue<=percentile07) {
      return HexColorV('#279c27').withOpacity(opacity);
    } else if (tileValue<=percentile08) {
      return HexColorV('#1d751d').withOpacity(opacity);
    } else if (tileValue<=percentile09) {
      return HexColorV('#134e13').withOpacity(opacity);
    } else {
      return HexColorV('#092709').withOpacity(opacity);
    }
  } else if (whoAware=="Watch") {
    if (tileValue<=percentile01) {
      return HexColorV('#fcf9ed').withOpacity(opacity);
    } else if (tileValue<=percentile02) {
      return HexColorV('#f4eac3').withOpacity(opacity);
    } else if (tileValue<=percentile03) {
      return HexColorV('#eddc99').withOpacity(opacity);
    } else if (tileValue<=percentile04) {
      return HexColorV('#e6ce70').withOpacity(opacity);
    } else if (tileValue<=percentile05) {
      return HexColorV('#dfbf46').withOpacity(opacity);
    } else if (tileValue<=percentile06) {
      return HexColorV('#d1ad23').withOpacity(opacity);
    } else if (tileValue<=percentile07) {
      return HexColorV('#a78a1c').withOpacity(opacity);
    } else if (tileValue<=percentile08) {
      return HexColorV('#7d6815').withOpacity(opacity);
    } else if (tileValue<=percentile09) {
      return HexColorV('#53450e').withOpacity(opacity);
    } else {
      return HexColorV('#292207').withOpacity(opacity);
    }
  } else if (whoAware=="Reserve") {
    if (tileValue<=percentile01) {
      return HexColorV('#ffebea').withOpacity(opacity);
    } else if (tileValue<=percentile02) {
      return HexColorV('#febdb9').withOpacity(opacity);
    } else if (tileValue<=percentile03) {
      return HexColorV('#ff8e88').withOpacity(opacity);
    } else if (tileValue<=percentile04) {
      return HexColorV('#ff6057').withOpacity(opacity);
    } else if (tileValue<=percentile05) {
      return HexColorV('#ff3126').withOpacity(opacity);
    } else if (tileValue<=percentile06) {
      return HexColorV('#f40c00').withOpacity(opacity);
    } else if (tileValue<=percentile07) {
      return HexColorV('#c30900').withOpacity(opacity);
    } else if (tileValue<=percentile08) {
      return HexColorV('#920700').withOpacity(opacity);
    } else if (tileValue<=percentile09) {
      return HexColorV('#610400').withOpacity(opacity);
    } else {
      return HexColorV('#300200').withOpacity(opacity);
    }
  } else if (whoAware=="Not_Reccommended") {
    if (tileValue<=percentile01) {
      return HexColorV('#dcc4ab').withOpacity(opacity);
    } else if (tileValue<=percentile02) {
      return HexColorV('#d2b292').withOpacity(opacity);
    } else if (tileValue<=percentile03) {
      return HexColorV('#c8a079').withOpacity(opacity);
    } else if (tileValue<=percentile04) {
      return HexColorV('#bd8e5f').withOpacity(opacity);
    } else if (tileValue<=percentile05) {
      return HexColorV('#b17c48').withOpacity(opacity);
    } else if (tileValue<=percentile06) {
      return HexColorV('#976b3e').withOpacity(opacity);
    } else if (tileValue<=percentile07) {
      return HexColorV('#7e5933').withOpacity(opacity);
    } else if (tileValue<=percentile08) {
      return HexColorV('#654729').withOpacity(opacity);
    } else if (tileValue<=percentile09) {
      return HexColorV('#4b351f').withOpacity(opacity);
    } else {
      return HexColorV('#322314').withOpacity(opacity);
    }
  } else {
    if (tileValue<=percentile01) {
      return HexColorV('#c5c7c1').withOpacity(opacity);
    } else if (tileValue<=percentile02) {
      return HexColorV('#b4b6ae').withOpacity(opacity);
    } else if (tileValue<=percentile03) {
      return HexColorV('#a2a59b').withOpacity(opacity);
    } else if (tileValue<=percentile04) {
      return HexColorV('#919488').withOpacity(opacity);
    } else if (tileValue<=percentile05) {
      return HexColorV('#7f8376').withOpacity(opacity);
    } else if (tileValue<=percentile06) {
      return HexColorV('#6d7065').withOpacity(opacity);
    } else if (tileValue<=percentile07) {
      return HexColorV('#5b5e54').withOpacity(opacity);
    } else if (tileValue<=percentile08) {
      return HexColorV('#494b43').withOpacity(opacity);
    } else if (tileValue<=percentile09) {
      return HexColorV('#363832').withOpacity(opacity);
    } else {
      return HexColorV('#242521').withOpacity(opacity);
    }
  }
}
class HexColorV extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColorV(final String hexColor) : super(_getColorFromHex(hexColor));
}
