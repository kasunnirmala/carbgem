import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'in_app_purchase_state.dart';
part 'in_app_purchase_event.dart';

class InAppPurchaseBloc extends Bloc<InAppPurchaseEvent, InAppPurchaseState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  InAppPurchaseBloc(this._authenticationRepository, this._bitteApiClient) : super(InAppInitial(productList: [], originalProductList: [], userPoints: 0)){
   _purchaseSubscription = _inAppPurchase.purchaseStream.listen(_onPurchaseStateChange);
   add(InAppPurchaseInitiate());
  }

  void _onPurchaseStateChange(List<PurchaseDetails> purchaseDetails) {
    add(InAppPurchaseStateChanged(purchaseDetails));
  }

  Stream<InAppPurchaseState> _mapPurchaseChangeToState(InAppPurchaseStateChanged event, InAppPurchaseState state) async* {
    InAppPurchaseState _finalState = InAppInitial(productList: state.productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
    /// 0: initial, 1: error, 2: restored, 3: pending, 4: purchase
    // int _finalState = 0;
    String? tokenId = await _authenticationRepository.idToken;
    if (tokenId==null) {
      _finalState = InAppError(productList: state.productList, errorMessage: 'Failed to get Token ID', originalProductList: state.originalProductList, userPoints: state.userPoints);
    } else {
      event.purchaseList.forEach((element){
        if (element.status == PurchaseStatus.error) {
          if (element.verificationData.serverVerificationData!='') {
            _bitteApiClient.createPurchaseHistoryAPI(tokenId: tokenId, purchaseToken: element.verificationData.serverVerificationData, productSKU: element.productID, purchaseStatus: 1);
            List<ProductDetailExtra> productList = ProductDetailExtra.updateSingleProduct(productList: state.productList, updateStatus: 1, productId: element.productID);
            _finalState = InAppError(productList: productList, errorMessage: 'Order cancelled', originalProductList: state.originalProductList, userPoints: state.userPoints);
          } else {
            _finalState = InAppError(productList: state.productList, errorMessage: 'Order cancelled', originalProductList: state.originalProductList, userPoints: state.userPoints);
          }
        } else if (element.status == PurchaseStatus.restored) {
          _finalState = InAppRestored(productList: state.productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
          // _finalState = 2;
        } else if (element.status == PurchaseStatus.pending) {
          _bitteApiClient.createPurchaseHistoryAPI(tokenId: tokenId, purchaseToken: element.verificationData.serverVerificationData, productSKU: element.productID, purchaseStatus: 2);
          List<ProductDetailExtra> productList = ProductDetailExtra.updateSingleProduct(productList: state.productList, updateStatus: 2, productId: element.productID);
          _finalState = InAppPurchasePending(productList: productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
          // _finalState = 3;
        } else if (element.status == PurchaseStatus.purchased) {
          _bitteApiClient.createPurchaseHistoryAPI(tokenId: tokenId, purchaseToken: element.verificationData.serverVerificationData, productSKU: element.productID, purchaseStatus: 0);
          List<ProductDetailExtra> productList = ProductDetailExtra.updateSingleProduct(productList: state.productList, updateStatus: 0, productId: element.productID);
          _finalState = InAppPurchased(productList: productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
          // _finalState = 4;
        } else if (element.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(element);
          _bitteApiClient.createPurchaseHistoryAPI(tokenId: tokenId, purchaseToken: element.verificationData.serverVerificationData, productSKU: element.productID, purchaseStatus: 0);
          List<ProductDetailExtra> productList = ProductDetailExtra.updateSingleProduct(productList: state.productList, updateStatus: 0, productId: element.productID);
          _finalState = InAppPurchased(productList: productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
          // _finalState = 4;
        }
      });
    }
    yield _finalState;
  }

  @override
  Stream<InAppPurchaseState> mapEventToState(InAppPurchaseEvent event) async* {
    if (event is InAppPurchaseConsumable){
      final ProductDetails selectProduct = state.productList[event.indexValue].productDetails;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: selectProduct);
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: state.kAutoConsume);
      /// send purchase token to backend api for process
      yield InAppPurchasePending(productList: state.productList, originalProductList: state.originalProductList, userPoints: state.userPoints);
    } else if (event is InAppPurchaseStateChanged){
      yield* _mapPurchaseChangeToState(event, state);
    } else if (event is InAppPurchaseInitiate) {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        yield InAppStoreUnavailable();
      } else {
        final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(state.kIds);
        if (response.notFoundIDs.isNotEmpty) {
          print("in app store available");
          print(response.notFoundIDs);
          yield InAppError(productList: state.productList, errorMessage: response.error?.message ?? '', originalProductList: state.originalProductList, userPoints: state.userPoints);
        } else {
          String? tokenId = await _authenticationRepository.idToken;
          if (tokenId==null) {
            yield InAppError(productList: state.productList, errorMessage: 'Failed to get Token ID', originalProductList: state.originalProductList, userPoints: state.userPoints);
          } else {
            List<ProductDetails> originalProductList = response.productDetails;
            FullPurchaseHistory fullPurchaseHistory = await _bitteApiClient.getPurchaseHistoryAPI(tokenId: tokenId);
            List<ProductDetailExtra> productList = ProductDetailExtra.fromProductList(productList: originalProductList, purchaseList: fullPurchaseHistory.purchaseList);
            yield InAppInitial(productList: productList, originalProductList: originalProductList, userPoints: fullPurchaseHistory.userPoints);
          }
        }
      }
    } else if (event is InAppPurchaseRefresh) {
      String? tokenId = await _authenticationRepository.idToken;
      if (tokenId==null) {
        yield InAppError(productList: state.productList, errorMessage: 'Failed to get Token ID', originalProductList: state.originalProductList, userPoints: state.userPoints);
      } else {
        FullPurchaseHistory fullPurchaseHistory = await _bitteApiClient.getPurchaseHistoryAPI(tokenId: tokenId);
        List<ProductDetailExtra> productList = ProductDetailExtra.fromProductList(productList: state.originalProductList, purchaseList: fullPurchaseHistory.purchaseList);
        yield InAppInitial(productList: productList, originalProductList: state.originalProductList, userPoints: fullPurchaseHistory.userPoints);
      }
    }
  }
  @override
  Future<void> close(){
    _purchaseSubscription?.cancel();
    return super.close();
  }
}