import 'package:flutter_flavor/flutter_flavor.dart';

//final String apiPathBase = FlavorConfig.instance.variables['baseUrl'];
final String apiPathBase = 'https://bitte-api.carbgem.app/api/';
final String apiPathLogin = "${apiPathBase}login/";
final String apiPathLoginInit = '${apiPathLogin}init_login';
final String apiPathLoginActivation = '${apiPathLogin}activation';
final String apiPathLoginSecond = '${apiPathLogin}after_second_time_login';
final String mapBoxPath =
    'https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/{z}/{x}/{y}?access_token=';
