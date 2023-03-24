import 'package:equatable/equatable.dart';
class DrugType extends Equatable {
  final String drugName;
  final String drugId;
  final String whoAware;

  const DrugType({required this.drugName, required this.drugId, required this.whoAware,});

  @override
  List<Object?> get props => [drugId, drugName, whoAware];
  static const empty = DrugType(drugId: "", drugName: "", whoAware: "");
  static DrugType fromJson(dynamic json) {
    return json!=null ? DrugType(drugName: json['drug_name'], drugId: '${json['drug_id']}', whoAware: json['who_aware']) : DrugType.empty;
  }
  static List<DrugType> fromJsonList(dynamic json) {
    return json!=null ? List<DrugType>.from(json['drug_list'].map((model) => DrugType.fromJson(model))) : [DrugType.empty];
  }
}
class DrugAntibiogram extends Equatable {
  final String drugName;
  final String drugCode;
  final double spectrumScore;
  final String whoAware;
  final double resistanceRate;
  final double susceptibilityRate;
  final String drugNameJp;
  final String drugCodeJp;

  const DrugAntibiogram({
    required this.drugName, required this.drugCode, required this.spectrumScore, required this.whoAware,
    required this.resistanceRate, required this.susceptibilityRate, required this.drugCodeJp, required this.drugNameJp,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    drugCode, drugName, spectrumScore, whoAware, resistanceRate, susceptibilityRate, drugCodeJp, drugNameJp,
  ];
  static const empty = DrugAntibiogram(
    drugName: "", drugCode: "", spectrumScore: 0.0, whoAware: "", resistanceRate: 0.0, susceptibilityRate: 0.0,
    drugCodeJp: "", drugNameJp: "",
  );
  static DrugAntibiogram fromJson(dynamic json){
    return DrugAntibiogram(
      drugName: json['drug_description'], drugCode: json['drug_name'], spectrumScore: json['spectrum_score'],
      whoAware: json['who_aware'], resistanceRate: json['resistance_rate'], susceptibilityRate: json['susceptibility_rate'],
      drugCodeJp: json['drug_code_jp'], drugNameJp: json["drug_name_jp"],
    );
  }
}

class DrugTimeSeries extends Equatable {
  final int year;
  final double resistanceRate;
  final double susceptibilityRate;

  const DrugTimeSeries({required this.year, required this.resistanceRate, required this.susceptibilityRate});

  @override
  // TODO: implement props
  List<Object?> get props => [year, resistanceRate, susceptibilityRate];
  static const empty = DrugTimeSeries(year: 0, resistanceRate: 0.0, susceptibilityRate: 0.0);
  static DrugTimeSeries fromJson(dynamic json){
    return DrugTimeSeries(year: json['year'], resistanceRate: json['resistance_rate'], susceptibilityRate: json['susceptibility_rate']);
  }
}

class DrugTimeSeriesAnti extends Equatable{
  final List<DrugTimeSeries> timeList;
  final List<DrugTimeSeries> hospitalTimeList;
  final String drugName;
  final String drugCode;
  final String drugNameJP;
  final String drugCodeJP;
  final String productJP;
  final String categoryJP;
  final List<String> brandDetailJP;
  final List<String> genericDetailJP;
  final String drugNotification;
  final double spectrumScore;
  final String whoAware;

  const DrugTimeSeriesAnti({
    required this.timeList, required this.drugName, required this.drugCode, required this.drugNotification,
    required this.spectrumScore, required this.whoAware, required this.drugNameJP, required this.drugCodeJP,
    required this.productJP, required this.categoryJP, required this.brandDetailJP, required this.genericDetailJP,
    required this.hospitalTimeList,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [drugName, drugCode, drugNotification, spectrumScore, whoAware, timeList];
  static const empty = DrugTimeSeriesAnti(
    timeList: [], drugName: '', drugCode: '', drugNotification: '', spectrumScore: 0.0, whoAware: '',
    drugNameJP: "", drugCodeJP: "", productJP: "", categoryJP: "", brandDetailJP: [], genericDetailJP: [],
    hospitalTimeList: [],
  );
  static DrugTimeSeriesAnti fromJson(dynamic json){
    List<DrugTimeSeries> timeList = List<DrugTimeSeries>.from(json["antibiogram"].map((model) => DrugTimeSeries.fromJson(model)));
    return DrugTimeSeriesAnti(
      timeList: timeList, drugName: json['drug_name'], drugCode: json['drug_code'],
      drugNotification: json['drug_notification'] ?? "", spectrumScore: json['spectrum_score'] ?? 0.0, whoAware: json['who_aware'] ?? "",
      drugNameJP: json["drug_name_jp"]??"", drugCodeJP: json["drug_code_jp"] ?? "",
      productJP: json["product_name"] ?? "", categoryJP: json["product_category"] ?? "",
      brandDetailJP: json["brand_details_jp"]!=null ? List<String>.from(json["brand_details_jp"]): ["No data"],
      genericDetailJP: json["generic_details_jp"]!=null ? List<String>.from(json["generic_details_jp"]):["No data"],
      hospitalTimeList: json["hospital_antibiogram"].length>0 ? List<DrugTimeSeries>.from(json["hospital_antibiogram"].map((model) => DrugTimeSeries.fromJson(model))) : []
    );
  }
}