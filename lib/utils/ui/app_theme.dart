import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // canvasColor: HexColor('#dbf3fa'),
      canvasColor: HexColor('#f5fcff'),
      backgroundColor: Colors.transparent,
      primaryColor: Colors.lightBlue,
      primaryColorDark: Colors.lightBlue.shade700,
      primaryColorLight: Colors.lightBlue.shade200,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          primary: HexColor('#69f0ae')
        ),
      ),
      textTheme: TextTheme(
        button: TextStyle(fontSize: 18.0, color: Colors.white70, fontWeight: FontWeight.bold),
        caption: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
        headline4: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        headline5: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: HexColor('#2bbd7e'),
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
        )
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueAccent,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: HexColor('#69f0ae')),
    );
  }
}