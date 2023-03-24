import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/in_app_purchase/in_app_purchase.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';

class InAppPurchasePage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: InAppPurchasePage());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InAppPurchaseBloc(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
      child: Scaffold(
        appBar: appBarWithBackArrowModified(context: context, pageNumber: 0, pageName: ""),
        endDrawer: CustomDrawer(),
        bottomNavigationBar: CustomNavigationBar(),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: InAppPurchaseForm(),
          ),
        ),
      ),
    );
  }
}

class InAppPurchaseForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppPurchaseBloc, InAppPurchaseState>(
      listener: (context, state) {
        if (state is InAppError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Error message: ${state.errorMessage}")));
        }
      },
      child: BlocBuilder<InAppPurchaseBloc, InAppPurchaseState>(
        builder: (context, state) => (state is InAppLoading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,)) :
        WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
          child: Align(
            alignment: Alignment(0,-1/3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopInfoDisplay(topText: (state is InAppStoreUnavailable) ? "Store is Unavailable" : "Products List",
                    bottomText1: (state is InAppStoreUnavailable) ? "Try logging into your Play Store": 'Total Point: ${state.userPoints}',bottomText2: "",
                  ),
                  ...state.productList.asMap().entries.map((e) {
                    int idx = e.key;
                    return _ProductTile(indexValue: idx);
                  }),
                  SizedBox(height: 20,),
                  IconButton(
                    onPressed: () => context.read<InAppPurchaseBloc>().add(InAppPurchaseRefresh()),
                    icon: Icon(Icons.refresh,), color: Theme.of(context).colorScheme.secondary, iconSize: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final int indexValue;

  const _ProductTile({Key? key, required this.indexValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InAppPurchaseBloc, InAppPurchaseState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Card(
          elevation: 5,
          child: ExpansionTile(
            leading: (state.productList[indexValue].currentStatus==0) ? Icon(Icons.check_circle_outline, color: Colors.green,) :
            (state.productList[indexValue].currentStatus==1) ? Icon(FontAwesomeIcons.timesCircle, color: Colors.red,): Icon(Icons.timelapse, color: Colors.blue,),
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('${state.productList[indexValue].productDetails.title}', style: Theme.of(context).textTheme.button?.copyWith(color: Colors.black),),
            ),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Align(child: Text('Description: ${state.productList[indexValue].productDetails.description}', style: Theme.of(context).textTheme.caption,), alignment: Alignment.centerLeft,),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    child: Text("${state.productList[indexValue].productDetails.price}"),
                    onPressed: (state.productList[indexValue].currentStatus==2) ? null : () => context.read<InAppPurchaseBloc>().add(InAppPurchaseConsumable(indexValue)),
                  ),
                ],
              ),
            ),
            children: state.productList[indexValue].purchaseList.map((e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: ListTile(
                tileColor: e.purchaseStatus==0? Colors.green.shade50:e.purchaseStatus==1?Colors.red.shade50: Colors.blue.shade50,
                title: Text('Purchase Date: ${e.purchaseTime}', style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.black),),
                subtitle: Text('Purchase Status: ${e.purchaseStatus==0? "Success" : e.purchaseStatus==1 ? "Cancelled" : "Pending"}', style: Theme.of(context).textTheme.caption,),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }
}
