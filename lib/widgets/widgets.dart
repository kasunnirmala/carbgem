import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/modules/firebase_flutter/bloc/firebase_flutter_bloc.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_drawer_fork/curved_drawer_fork.dart' as drawer;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:core';

enum SigningCharacter { doctor, physician, others }

getAlert({required BuildContext context, required String title,
  required String msg, required bool clickFunction, required bool okButton,
  Function()? okFunction, bool? showCloseIcon, bool? dismissOnTouchOutside
}){
  Function() okfunction_wrap = ()=> okFunction!();
  return AwesomeDialog(
    context: context,
    title: title,
    desc: msg,
    headerAnimationLoop: false,
    animType: AnimType.BOTTOMSLIDE,
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    showCloseIcon: (showCloseIcon != null) ? false : true,
    dismissOnBackKeyPress: false,
    btnOkIcon:  Icons.check_circle,
    dismissOnTouchOutside: dismissOnTouchOutside ?? true,

    // The below code is for alert with clickFunction
    borderSide: BorderSide(
        color: clickFunction == true ? Colors.green:Colors.blue,
        width: 2),
    dialogType: clickFunction == true ? DialogType.SUCCES : DialogType.INFO_REVERSED,
    btnOkOnPress: clickFunction == true ? okfunction_wrap : null,
    btnOkText: okButton == true ? 'Ok':'閉じる',
  )..show();
}

getInfo({required BuildContext context, required String title,
  required String msg, required bool infoDialog,
  required Function() okFunction, Function()? cancelFunction
}){
  Function() okfunctionWrap = ()=> okFunction;
  Function() cancelfunctionWrap = ()=> cancelFunction;
  return AwesomeDialog(
    context: context,
    title: title,
    desc: msg,
    headerAnimationLoop: false,
    animType: AnimType.BOTTOMSLIDE,
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    showCloseIcon: true,
    dismissOnBackKeyPress: false,
    btnOkIcon:  Icons.check_circle,
    btnCancelIcon: FontAwesomeIcons.timesCircle,
    // The below code is for alert with clickFunction
    borderSide: BorderSide(
        color: infoDialog == true ? Colors.blue:Colors.green,
        width: 2),
    dialogType: infoDialog == true ? DialogType.INFO : DialogType.SUCCES,
    btnOkOnPress: okfunctionWrap,
    btnCancelOnPress: cancelfunctionWrap,
  )..show();
}

getConfirmation({required BuildContext context,required String title, required String msg}){
  return AwesomeDialog(
    context: context,
    title: title,
    desc: msg,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    borderSide: BorderSide(color: Colors.orange, width: 2),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    dismissOnBackKeyPress: false,
    btnCancelText: "NO",
    btnOkText: "YES",
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}

warningAlertDialog({required BuildContext context, required String title, required String msg}){
  return AwesomeDialog(
    context: context,
    title: title,
    desc: msg,
    dialogType: DialogType.WARNING,
    headerAnimationLoop: false,
    dismissOnBackKeyPress: false,
    animType: AnimType.TOPSLIDE,
    borderSide: BorderSide(color: Colors.red, width: 2),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    closeIcon: Icon(Icons.close_fullscreen_outlined),
    btnCancelOnPress: () {},
    btnCancelText: ('close').tr(),
  )..show();
}


class LogOutButton extends StatefulWidget {
  final double buttonSize;

  const LogOutButton({Key? key, this.buttonSize=0.7}) : super(key: key);
  @override
  _LogOutButtonState createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      color: Theme.of(context).colorScheme.secondary,
      controller: _btnController,
      onPressed: () {
        context.read<FirebaseFlutterBloc>().add(FirebaseFlutterLogoutRequested());
      },
      child: Container(
        width: MediaQuery.of(context).size.width*widget.buttonSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 20,),
            Text('ログアウト'),
          ],
        ),
      ),
    );
  }
}


Widget getLogOutButton({required BuildContext context}) {
  return ElevatedButton(
    onPressed: () => context.read<FirebaseFlutterBloc>().add(FirebaseFlutterLogoutRequested()),
    child: Text('ログアウト'),
  );
}

registerAlertDialog({required titleWidget, required BuildContext context, required String msg,}){
  return AwesomeDialog(
    context: context,
    title: titleWidget,
    desc: msg,
    dismissOnBackKeyPress: false,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    borderSide: BorderSide(color: Colors.orange, width: 2),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    btnCancelText: "NO",
    btnOkText: "YES",
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}

class TopInfoDisplay extends StatelessWidget {
  final String topText;
  final String bottomText1;
  final String bottomText2;
  const TopInfoDisplay({Key? key, required this.topText, required this.bottomText1, required this.bottomText2}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height*0.1,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(topText,
                  style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey.shade700),
                  overflow: TextOverflow.fade, maxLines: 2, softWrap: true,
                ),
                bottomText1 != "" ?
                Text(bottomText1,
                  style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.grey.shade600),
                ) : Container(),
                bottomText2 != "" ?
                Text(bottomText2,
                  style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.grey.shade500),
                  overflow: TextOverflow.fade, maxLines: 2, softWrap: true,
                ) : Container()
              ]
            ),
          ),),
      ],
    );
  }
}

AppBar appBarWithBackArrow({required BuildContext context,}){
  return AppBar(
    backgroundColor: Theme.of(context).canvasColor,
    iconTheme: IconThemeData(color: Colors.blueAccent),
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).pop(),
    ),
    centerTitle: true,
  );
}


AppBar appBarWithBackArrowModified({
  required BuildContext context, required int pageNumber, required String pageName, String? subParameter, String? subParameter2nd, String? subParameter3rd,
  String? subParameter4th, String? subParameter5th, String? subParameter6th, String? subParameter7th, String? subParameter8th,
  String? subParameter9th, String? subParameter10th, Function? submitFunction, Function? submitSearchFunction,
}){
  return AppBar(
    backgroundColor: Colors.blue.withOpacity(0.9),
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    leading: IconButton(
      icon: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
      onPressed: (submitFunction!=null)? submitFunction() : () {
        context.read<BasicHomeCubit>().pageChanged(
          value: pageNumber, subPageParameter: subParameter, subPageParameter2nd: subParameter2nd, subPageParameter3rd: subParameter3rd,
          subPageParameter4th: subParameter4th, subPageParameter5th: subParameter5th, subPageParameter6th: subParameter6th,
          subPageParameter7th: subParameter7th, subPageParameter8th: subParameter8th, subPageParameter9th: subParameter9th,
          subPageParameter10th: subParameter10th,
        );
      },
    ),
    centerTitle: true,
    title: Text("$pageName".tr(), style: TextStyle(color: Colors.white)),
  );
}


AppBar appBarWithoutLead({required BuildContext context, bool? selectLang=false}){
  return AppBar(
    backgroundColor: Theme.of(context).canvasColor,
    iconTheme: IconThemeData(color: Colors.blueAccent),
    elevation: 0,
    leading: IconButton(
      icon: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.fill,
      ),
      onPressed: null,
    ),
    centerTitle: true,
  );
}

int currentNavigationIndex = 0;

Widget customTile({
  required BuildContext context, required String imagePath, required String titleText,
  required List<String> bodyTextList, required int navIndex, String? subParameter1,
  String? subParameter2, String? subParameter3, String? subParameter4, String? subParameter5,
  String? subParameter6, String? subParameter7, String? subParameter8, String? subParameter9,
  bool? subParameter16, Color? backgroundColor, bool imageAsset=true, bool borderColor = false,
}) {
  return Stack(
    children: [
      Positioned(child: InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 60, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            border: borderColor ? Border.all(color: Colors.tealAccent,width: 5) : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                backgroundColor ?? HexColor('#bbeaff'),
                Colors.white,
              ]
            ),
            // color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0,3)
            )]
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 60.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Text(titleText, style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold),),
                      width: MediaQuery.of(context).size.width*0.4,
                    ),
                    Column(
                      children: bodyTextList.map((e) => Container(
                        child: Text(e, style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),),
                        width: MediaQuery.of(context).size.width*0.4,
                      )).toList(),
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_right, size: 30,)
              ]
            ),
          ),
        ),
        onTap: () => context.read<BasicHomeCubit>().pageChanged(
          value: navIndex, subPageParameter: subParameter1, subPageParameter2nd: subParameter2,
          subPageParameter3rd: subParameter3, subPageParameter4th: subParameter4, subPageParameter5th: subParameter5,
          subPageParameter6th: subParameter6, subPageParameter7th: subParameter7, subPageParameter8th: subParameter8,
          subPageParameter9th: subParameter9, subPageParameter16th: subParameter16
        ),
      )),
      Positioned(
        top: 5,
        child: Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (backgroundColor!=null) ? backgroundColor.withOpacity(0.5) : HexColor('#bbeaff').withOpacity(0.5),
            image: imageAsset ?
            DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover) :
            DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.cover),
          ),
        ),
      ),
    ],
  );
}

Future<String> selectFromCamera() async {
  final _picker = ImagePicker();
  var image = await _picker.pickImage(source: ImageSource.camera);
  if (image == null){
    return "None";
  } else {
    return image.path;
  }
}
Future<String> selectFromGallery() async {
  final _picker = ImagePicker();
  var image = await _picker.pickImage(source: ImageSource.gallery);
  if (image == null){
    return "None";
  } else {
    return image.path;
  }
}

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      height: MediaQuery.of(context).size.height*0.05,
      items: [
        TabItem(icon: Icons.home_rounded),
        TabItem(icon: FontAwesomeIcons.bacterium),
        TabItem(icon: Icons.map_outlined),
        TabItem(icon: FontAwesomeIcons.chartBar)
      ],
      initialActiveIndex: currentNavigationIndex<4 ? currentNavigationIndex : 0,
      onTap: (int i) {
        currentNavigationIndex = i;
        if (i<3 && i!=1){
          context.read<BasicHomeCubit>().pageChanged(value: i);
        } else if (i==1){
          context.read<BasicHomeCubit>().pageChanged(
            value: 1, subPageParameter: '', subPageParameter2nd: '', subPageParameter3rd: '',
            subPageParameter4th: '', subPageParameter5th: '',
          );
        } else {
          context.read<BasicHomeCubit>().pageChanged(value: 21);
        }
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return drawer.CurvedDrawer(
      width: MediaQuery.of(context).size.width*0.2<100 ? MediaQuery.of(context).size.width*0.2 : 100,
      color: Colors.black12,
      labelColor: Theme.of(context).primaryColorDark,
      index: currentNavigationIndex,
      items: [
        drawer.DrawerItem(icon: Icon(Icons.home_rounded,), label: 'Home'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.bacterium,), label: 'Detect'),
        drawer.DrawerItem(icon: Icon(Icons.map_outlined,), label: 'Infection Map'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.chartBar,), label: 'Data Explorer'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.userMd,), label: 'User Information'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.cog), label: 'App Version'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.signOutAlt,), label: 'Log Out'),
      ],
      onTap: (int i){
        currentNavigationIndex = i;
        if (i<3 && i!=1){
          context.read<BasicHomeCubit>().pageChanged(value: i);
        } else if (i==4){
          context.read<BasicHomeCubit>().pageChanged(value: 4);
        } else if (i==5){
          context.read<BasicHomeCubit>().pageChanged(value: 12);
        } else if (i==6){
          currentNavigationIndex = 0;
          context.read<FirebaseFlutterBloc>().add(FirebaseFlutterLogoutRequested());
        } else if (i==3){
          context.read<BasicHomeCubit>().pageChanged(value: 21);
        } else if (i==1){
          context.read<BasicHomeCubit>().pageChanged(
            value: 1, subPageParameter: '', subPageParameter2nd: '', subPageParameter3rd: '',
            subPageParameter4th: '', subPageParameter5th: '',
          );
        }
      },
    );
  }
}

class CustomUnactivatedDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return drawer.CurvedDrawer(
      width: MediaQuery.of(context).size.width*0.2<100 ? MediaQuery.of(context).size.width*0.2 : 100,
      color: Colors.black12,
      labelColor: Theme.of(context).primaryColorDark,
      index: currentNavigationIndex,
      items: [
        drawer.DrawerItem(icon: Icon(Icons.home_rounded,), label: 'Home'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.userMd,), label: 'User Information'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.cog), label: 'App Version'),
        drawer.DrawerItem(icon: Icon(FontAwesomeIcons.signOutAlt,), label: 'Log Out'),
      ],
      onTap: (int i){
        currentNavigationIndex = i;
        if (i==0){
          context.read<BasicHomeCubit>().pageChanged(value: 0);
        } else if (i==1){
          context.read<BasicHomeCubit>().pageChanged(value: 4);
        } else if (i==2){
          context.read<BasicHomeCubit>().pageChanged(value: 12);
        } else if (i==3){
          currentNavigationIndex = 0;
          context.read<FirebaseFlutterBloc>().add(FirebaseFlutterLogoutRequested());
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 14,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

Future<bool> onBackPressed({
  required BuildContext context, required int pageNumber, required int navNumber, String? subParameter, String? subParameter2nd, String? subParameter3rd,
  String? subParameter4th, String? subParameter5th, String? subParameter6th, String? subParameter7th, String? subParameter8th,
  String? subParameter9th, String? subParameter10th, String? subParameter11th, String? subParameter12th,
}){
  currentNavigationIndex = navNumber;
  context.read<BasicHomeCubit>().pageChanged(
    value: pageNumber, subPageParameter: subParameter, subPageParameter2nd: subParameter2nd, subPageParameter3rd: subParameter3rd,
    subPageParameter4th: subParameter4th, subPageParameter5th: subParameter5th, subPageParameter6th: subParameter6th,
    subPageParameter7th: subParameter7th, subPageParameter8th: subParameter8th, subPageParameter9th: subParameter9th,
    subPageParameter10th: subParameter10th, subPageParameter11th: subParameter11th,subPageParameter12th: subParameter12th,
  );
  return Future<bool>.value(false);
}

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => FloatingModal(
        child: child,
      ),
      expand: false);

  return result;
}

class ModalFit extends StatelessWidget {
  final Function cameraClick;
  final Function galleryClick;
  const ModalFit({Key? key, required this.cameraClick, required this.galleryClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.1),
      height: MediaQuery.of(context).size.height*0.35,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.05),
          child: Row(
            children: [
              Expanded(child: Column(
                children: [
                  IconButton(
                    iconSize: MediaQuery.of(context).size.height*0.15,
                    color: Colors.blueAccent,
                    splashColor: Colors.blueAccent.withOpacity(0.7),
                    onPressed: () async {
                      context.read<BasicHomeCubit>().eventUploadImageCamera();
                      String imagePath = await selectFromCamera();
                      if (imagePath!="None") {
                        cameraClick(imagePath: imagePath);
                      }
                      Navigator.of(context).pop();
                      },
                    icon: Icon(FontAwesomeIcons.camera,),
                  ),
                  Text("Label_imageUpload_icon_title_camera".tr(), style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.blue))
                ],
              ), flex: 1,),
              Expanded(child: Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      context.read<BasicHomeCubit>().eventUploadImageGallery();
                      String imagePath = await selectFromGallery();
                      if (imagePath!="None") {
                        galleryClick(imagePath: imagePath);
                      }
                      Navigator.of(context).pop();
                      },
                    iconSize: MediaQuery.of(context).size.height*0.15,
                    color: Colors.redAccent,
                    splashColor: Colors.blueAccent.withOpacity(0.7),
                    icon: Icon(FontAwesomeIcons.image,),
                  ),
                  Text("Label_imageUpload_icon_title_photo".tr(), style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.red))
                ],
              ), flex: 1,),
            ],
          ),
        ),
      ),
    );
  }
}