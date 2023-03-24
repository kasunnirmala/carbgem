import 'package:flutter/material.dart';
import 'app.dart';
import 'flavors.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carbgem/modules/firebase_flutter/firebase_flutter.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'generated/codegen_loader.g.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

void main() async {
  F.appFlavor = Flavor.DEVELOPMENT;
  FlavorConfig(name: 'DEV', variables: <String, dynamic>{
    'baseUrl': 'https://bitte-api-dev.carbgem.dev/api/',
  });

  /// call enablePendingPurchase so the Android platform
  Bloc.observer = FirebaseFlutterBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  final bitteApiClient = BitteApiClient();
  runApp(EasyLocalization(
    child: FirebaseFlutter(
      authenticationRepository: authenticationRepository,
      bitteApiClient: bitteApiClient,
    ),
    supportedLocales: [Locale("en", ""), Locale('ja', ''), Locale('vi', '')],
    path: 'assets/translations',
    fallbackLocale: Locale('en', ''),
    useOnlyLangCode: true,
    assetLoader: CodegenLoader(),
    startLocale: Locale("en", ""),
    saveLocale: true,
  ));
  // runApp(FirebaseFlutter(authenticationRepository: authenticationRepository,bitteApiClient: bitteApiClient,));
}
