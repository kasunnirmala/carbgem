import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart' as bitte;
import 'package:carbgem/utils/ui/app_theme.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:carbgem/modules/firebase_flutter/firebase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// provide an instance of the authentication repos via repos provider
/// creates and provide an instance of bloc
/// consumes the bloc and handles the current routes based on the authentication state

class FirebaseFlutter extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final bitte.BitteApiClient _bitteApiClient;
  const FirebaseFlutter({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required bitte.BitteApiClient bitteApiClient
  }) :_authenticationRepository = authenticationRepository, _bitteApiClient = bitteApiClient , super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(create: (context) => _authenticationRepository,),
        RepositoryProvider<bitte.BitteApiClient>(create: (context) => _bitteApiClient,)
      ],
      child: BlocProvider(
        create: (_) => FirebaseFlutterBloc(authenticationRepository: _authenticationRepository, bitteApiClient: _bitteApiClient),
        child: FirebaseFlutterView(),
      ) ,);
  }
}

class FirebaseFlutterView extends StatelessWidget {
  const FirebaseFlutterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...context.localizationDelegates
      ],
      supportedLocales: [
        Locale('en', ''),Locale('ja', ''), Locale('vi', ''),
        ...context.supportedLocales
      ],
      locale: context.locale,
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FlowBuilder<FirebaseFlutterStatus>(
        state: context.select((FirebaseFlutterBloc bloc) {
          return bloc.state.status;
        }),
        onGeneratePages: onGenerateFirebaseFlutterViewPages,
      ),
    );
  }
}

