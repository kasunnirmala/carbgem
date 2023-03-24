part of 'in_app_purchase_bloc.dart';
class ProductDetailExtra extends Equatable {
  final ProductDetails productDetails;
  final int currentStatus;
  final List<PurchaseHistory> purchaseList;

  ProductDetailExtra({required this.productDetails, required this.currentStatus, required this.purchaseList});

  @override
  List<Object?> get props => [productDetails, currentStatus, purchaseList];
  static List<ProductDetailExtra> fromProductList({required List<ProductDetails> productList, required List<PurchaseHistoryAPI> purchaseList}) {
    return List<ProductDetailExtra>.from(productList.map((e) {
      PurchaseHistoryAPI _purchaseItem = purchaseList.firstWhere((element) {
        return element.itemId==e.id;
      });
      return ProductDetailExtra(productDetails: e, currentStatus: _purchaseItem.currentStatus, purchaseList: _purchaseItem.purchaseList);
    }));
  }
  static List<ProductDetailExtra> updateSingleProduct({required List<ProductDetailExtra> productList, required int updateStatus, required String productId}) {
    return List<ProductDetailExtra>.from(productList.map((e) {
      if (e.productDetails.id==productId) {
        return ProductDetailExtra(productDetails: e.productDetails, currentStatus: updateStatus, purchaseList: e.purchaseList);
      } else {
        return e;
      }
    }));
  }
}
abstract class InAppPurchaseState extends Equatable {
  final String errorMessage;
  final List<ProductDetailExtra> productList;
  final List<ProductDetails> originalProductList;
  final Set<String> kIds;
  final bool kAutoConsume;
  final int userPoints;

  const InAppPurchaseState({
    this.errorMessage = "", this.productList = const [], this.originalProductList = const [],
    this.kIds = const {'sample_product_001', 'sample_product_002'}, this.kAutoConsume = true,
    this.userPoints = 0,
  });

  @override
  List<Object> get props => [errorMessage, productList, kIds, kAutoConsume, originalProductList, userPoints];
}

class InAppPurchasePending extends InAppPurchaseState {
  const InAppPurchasePending({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints
  }): super(
    productList: productList, originalProductList: originalProductList, userPoints: userPoints,
  );
}
class InAppError extends InAppPurchaseState{
  const InAppError({
    required List<ProductDetailExtra> productList, required String errorMessage, required List<ProductDetails> originalProductList , required int userPoints,
  }): super(productList: productList, errorMessage: errorMessage, originalProductList: originalProductList, userPoints: userPoints);
}
class InAppPurchased extends InAppPurchaseState{
  const InAppPurchased({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}
class InAppRestored extends InAppPurchaseState{
  const InAppRestored({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}
class InAppPendingCompletePurchase extends InAppPurchaseState{
  const InAppPendingCompletePurchase({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}
class InAppStoreUnavailable extends InAppPurchaseState{}

class InAppLoading extends InAppPurchaseState{
  const InAppLoading({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}
class InAppComplete extends InAppPurchaseState{
  const InAppComplete({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}

class InAppInitial extends InAppPurchaseState{
  const InAppInitial({
    required List<ProductDetailExtra> productList, required List<ProductDetails> originalProductList, required int userPoints,
  }): super(productList: productList, originalProductList: originalProductList, userPoints: userPoints);
}
