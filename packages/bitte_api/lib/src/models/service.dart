import 'package:equatable/equatable.dart';

class PurchaseHistory extends Equatable{
  final int purchaseStatus;
  final String purchaseToken;
  final String purchaseTime;

  const PurchaseHistory({required this.purchaseStatus, required this.purchaseToken, required this.purchaseTime});

  @override
  List<Object?> get props =>[purchaseTime, purchaseStatus, purchaseToken];
  static const empty = PurchaseHistory(purchaseStatus: 2, purchaseToken: '', purchaseTime: '2020-01-01');
  static PurchaseHistory fromJson(dynamic json) {
    return json!=null ? PurchaseHistory(
      purchaseStatus: json['purchase_status'],
      purchaseToken: json['purchase_token'],
      purchaseTime: json['created_at'],
    ) : PurchaseHistory.empty;
  }
}

class PurchaseHistoryAPI extends Equatable{
  final List<PurchaseHistory> purchaseList;
  final String itemId;
  final int currentStatus;

  const PurchaseHistoryAPI({required this.purchaseList, required this.itemId, required this.currentStatus});

  @override
  List<Object?> get props => [purchaseList, itemId, currentStatus];

  static const empty = PurchaseHistoryAPI(purchaseList: [PurchaseHistory.empty], itemId: '', currentStatus: 2);
  static PurchaseHistoryAPI fromJson(dynamic json) {
    List<PurchaseHistory> purchaseList = List<PurchaseHistory>.from(json['purchase_history'].map((model) => PurchaseHistory.fromJson(model)));
    return PurchaseHistoryAPI(purchaseList: purchaseList, itemId: json['item_id'], currentStatus: json['latest_status']);
  }
  static List<PurchaseHistoryAPI> fromJsonList(dynamic json) {
    return List<PurchaseHistoryAPI>.from(json['item_list'].map((model) => PurchaseHistoryAPI.fromJson(model)));
  }
}

class FullPurchaseHistory extends Equatable {
  final List<PurchaseHistoryAPI> purchaseList;
  final int userPoints;

  const FullPurchaseHistory({required this.purchaseList, required this.userPoints});

  @override
  List<Object?> get props => [userPoints, purchaseList];
  static const empty = FullPurchaseHistory(purchaseList: const [], userPoints: 0);
  static FullPurchaseHistory fromJson(dynamic json) {
    List<PurchaseHistoryAPI> purchaseList = PurchaseHistoryAPI.fromJsonList(json);
    return FullPurchaseHistory(purchaseList: purchaseList, userPoints: json['user_point']);
  }
}

class Antibiogram extends Equatable{
  final int year;
  final int breakdownTotal;
  final int overallTotal;
  final double breakdownShare;
  final double breakdownSusceptible;
  final double overallSusceptible;

  const Antibiogram({
    required this.year, required this.breakdownTotal, required this.overallTotal, 
    required this.breakdownShare, required this.breakdownSusceptible, required this.overallSusceptible,
  });

  @override
  List<Object?> get props => [year, breakdownTotal, overallTotal, breakdownShare, breakdownSusceptible, overallSusceptible];
  static const empty = Antibiogram(year: 2011, breakdownTotal: 0, overallTotal: 0, breakdownShare: 0.0, breakdownSusceptible: 0.0, overallSusceptible: 0.0);
  static Antibiogram fromJson(dynamic json){
    return json!=null ? Antibiogram(
      year: json['year'], breakdownTotal: json['drug_total'], overallTotal: json['area_total'],
      breakdownShare: json['drug_share'], breakdownSusceptible: json['drug_susceptible'],
      overallSusceptible: json['area_susceptible'],
    ) : Antibiogram.empty;
  }
  static List<Antibiogram> fromJsonList(dynamic json){
    return List<Antibiogram>.from(json['ts_list'].map((model) => Antibiogram.fromJson(model)));
  }
}