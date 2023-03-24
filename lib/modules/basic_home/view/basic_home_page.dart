import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/modules/basic_home/routes/basic_home_routes.dart';
import 'package:carbgem/utils/ui/app_theme.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:new_version/new_version.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// add empty change to commit for ios update.
class BasicHomeRoute extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  static Page page() => MaterialPage<void>(child: BasicHomeRoute());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BasicHomeCubit(context.read<BitteApiClient>(), context.read<AuthenticationRepository>(), analytics, observer),
      child: BasicHomeView(analytics: analytics, observer: observer,),
    );
  }
}

class BasicHomeView extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const BasicHomeView({Key? key, required this.analytics, required this.observer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FlowBuilder<BasicHomeState>(
        observers: <NavigatorObserver>[observer],
        state: context.select((BasicHomeCubit cubit) {
          return cubit.state;
        }),
        onGeneratePages: onGenerateBasicHomeViewPages,
      ),
    );
  }
}

class BasicHome extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: BasicHome());
  static Route route(){
    return MaterialPageRoute(builder: (_) => const BasicHome());
  }
  const BasicHome({Key? key}): super(key: key);

  @override
  _BasicHomeState createState() => _BasicHomeState();
}

class _BasicHomeState extends State<BasicHome> {
  @override
  void initState() {
    super.initState();
    final newVersion = NewVersion(
        iOSId: "com.carbgem.bitte.dev", androidId: "com.carbgem.bitte", iOSAppStoreCountry: "JP",
    );
    newVersion.showAlertIfNecessary(context: context);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<BasicHomeCubit, BasicHomeState>(
      listener: (context, state){
        if (state.status == BasicHomeStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<BasicHomeCubit, BasicHomeState>(
        buildWhen: (previous, current) {
          return previous.status!=current.status;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Label_Title_home'.tr(), style: TextStyle(color: Colors.white,fontSize: 17),),
              backgroundColor: Colors.blue.withOpacity(0.9),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
          ),
            endDrawer: (state.status==BasicHomeStatus.activated) ? CustomDrawer():CustomUnactivatedDrawer(),
            body: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment(0,-1/3),
                  child: SingleChildScrollView(
                    child: (state.status == BasicHomeStatus.loading) ?
                    Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,)):
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10,),
                        // TopInfoDisplay(
                        //   topText: '${state.currentUser.hospitalName} - ${state.currentUser.countryName} - ${state.currentUser.areaName}',
                        //   bottomText2: "",
                        //   bottomText1: (state.currentUser.jobTitle=="0") ? 'doctor'.tr() : (state.currentUser.jobTitle=="1") ? "physician".tr() : 'others'.tr(),
                        // ),
                        SizedBox(height: 20,),
                        (state.status==BasicHomeStatus.unactivated) ? Container() :
                        customTile(
                          context: context, imagePath: 'assets/images/patient_list.png',
                          titleText: 'Label_basic_home_topButton_title'.tr(),
                          bodyTextList: ['${'Label_basic_home_topButton_body'.tr()}: ${state.currentUser.patientCount}'], navIndex: 3,
                        ),
                        // _PatientListMoveButton(),
                        SizedBox(height: 30,),
                        (state.status==BasicHomeStatus.unactivated) ? _ActivationButton() :
                        customTile(
                          context: context, imagePath: 'assets/images/virus.png', titleText: 'Label_basic_home_middleButton_title'.tr(),
                          bodyTextList: ['${"imageNum".tr()}: ${state.currentUser.unsortedCount}'], navIndex: 5,
                        ),
                        SizedBox(height: 30,),
                        (state.status==BasicHomeStatus.unactivated) ? Container() :
                        customTile(
                          context: context, imagePath: 'assets/images/product_list_icon.png', titleText: "${"basic_home_userActivity_button_title".tr()}",
                          bodyTextList: ["${"basic_home_userActivity_button_description".tr()}"], navIndex: 9,
                        ),
                        // SizedBox(height: 30,),
                        // (state.status==BasicHomeStatus.unactivated) ? Container() :
                        // customTile(
                        //   context: context, imagePath: 'assets/images/product_list_icon.png', titleText: "${"basic_home_userActivity_button_title".tr()}",
                        //   bodyTextList: ["${"basic_home_userActivity_button_description".tr()}"], navIndex: 28,
                        // ),
                        // SizedBox(height: 30,),
                        // customTile(
                        //   context: context, imagePath: 'assets/images/product_list_icon.png', titleText: 'サービス利用履歴',
                        //   bodyTextList: ['Total Points: TBI'], navIndex: 20,
                        // ),
                        // (state.status==BasicHomeStatus.unactivated) ? Container() : _ProductPurchaseMoveButton(),
                        SizedBox(height: 10,),
                        // _AnalyticsButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // bottomNavigationBar: BottomNavigationWidgetGeneral(),
            bottomNavigationBar: (state.status == BasicHomeStatus.activated) ? CustomNavigationBar(): null,
          );
        },
      ),
    );
  }
}

class _ActivationButton extends StatefulWidget {
  @override
  __ActivationButtonState createState() => __ActivationButtonState();
}

class __ActivationButtonState extends State<_ActivationButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicHomeCubit, BasicHomeState>(builder: (context,state) => Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: RoundedLoadingButton(
        color: Theme.of(context).colorScheme.secondary,
        controller: _btnController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.checkCircle),
            SizedBox(width: 20,),
            Text("Label_basic_home_button_activate".tr()),
          ],
        ),
        onPressed: (){
         context.read<BasicHomeCubit>().pageChanged(value: 19);
         _btnController.reset();
        },
      ),
    ));
  }
}

class _AnalyticsButton extends StatefulWidget {
  @override
  __AnalyticsButtonState createState() => __AnalyticsButtonState();
}

class __AnalyticsButtonState extends State<_AnalyticsButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicHomeCubit, BasicHomeState>(builder: (context,state) => Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: RoundedLoadingButton(
        color: Theme.of(context).colorScheme.secondary,
        controller: _btnController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.checkCircle),
            SizedBox(width: 20,),
            Text("Label_basic_home_button_analytics".tr()),
          ],
        ),
        onPressed: (){
          context.read<BasicHomeCubit>().sendAnalyticsEvent();
          _btnController.reset();
        },
      ),
    ));
  }
}
