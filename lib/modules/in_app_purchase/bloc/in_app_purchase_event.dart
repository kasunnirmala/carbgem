part of 'in_app_purchase_bloc.dart';

abstract class InAppPurchaseEvent extends Equatable{
  const InAppPurchaseEvent();

  @override
  List<Object> get props => [];
}

class InAppPurchaseStateChanged extends InAppPurchaseEvent{
  final List<PurchaseDetails> purchaseList;
  const InAppPurchaseStateChanged(this.purchaseList);
  @override
  List<Object> get props => [purchaseList];
}

class InAppPurchaseConsumable extends InAppPurchaseEvent{
  final int indexValue;
  InAppPurchaseConsumable(this.indexValue);
  @override
  List<Object> get props => [indexValue];
}

class InAppPurchaseInitiate extends InAppPurchaseEvent{}
class InAppPurchaseRefresh extends InAppPurchaseEvent{}
