import 'package:carbgem/widgets/widgets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return WillPopScope(
      onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
      child: Align(
        alignment: Alignment(0,-1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("Label_VersionDisplay_totalVersion".tr(),
              //   style: Theme.of(context).textTheme.headline6,
              // ),
              SizedBox(height: 16,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // color: Colors.red,
                  child: Text("Label_VersionDisplay_appInformation".tr(),
                    style: TextStyle(color: Color(0xFF40ACEF), fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              FutureBuilder(
                future: _getPackageInfo(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Text(
                      '${snapshot.data}',
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    );
                  } else {
                    return Text('...');
                  }},
              ),
              SizedBox(height: 16,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // color: Colors.red,
                  child: Text("Label_VersionDisplay_osType".tr(),
                    style: TextStyle(color: Color(0xFF40ACEF), fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              OsDeclareMessage(),
              SizedBox(height: 16,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // color: Colors.red,
                  child: Text("Label_VersionDisplay_deviceInformation".tr(),
                    style: TextStyle(color: Color(0xFF40ACEF), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Align(
                alignment: Alignment.center,
                child:VersionDisplayList(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Container(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ),
              SizedBox(height: 16,),
              Text('Label_VersionDisplay_companyName'.tr())
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getAndroidDeviceInfo({required DeviceInfoPlugin device}) async {
    AndroidDeviceInfo androidDeviceInfo = await device.androidInfo;
    return androidDeviceInfo.version.release;
  }
  Future<String?> _getIosDeviceInfo({required DeviceInfoPlugin device}) async {
    IosDeviceInfo iosInfo = await device.iosInfo;
    return iosInfo.utsname.release;
  }
  Future<String?> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.appName} ${packageInfo.version}';
  }
}

class OsDeclareMessage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? 
            Text("Label_VersionDisplay_ios".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
            )
            : Text("Label_VersionDisplay_android".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
            );
  }

}

class VersionDisplayList extends StatefulWidget {
  const VersionDisplayList({Key? key}) : super(key: key);

  @override
  State<VersionDisplayList> createState() => _VersionDisplayWithState();
}

class _VersionDisplayWithState extends State<VersionDisplayList> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    late Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      // 'version.securityPatch': build.version.securityPatch,
      // 'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      // 'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      // 'version.baseOS': build.version.baseOS,
      // 'board': build.board,
      // 'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      // 'display': build.display,
      // 'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      // 'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      // 'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'Label_VersionDisplay_deviceName'.tr(): data.name,
      'Label_VersionDisplay_systemName'.tr(): data.systemName,
      'Label_VersionDisplay_systemVersion'.tr(): data.systemVersion,
      'Label_VersionDisplay_model'.tr(): data.model,
      'Label_VersionDisplay_localizedModel'.tr(): data.localizedModel,
      'Label_VersionDisplay_vendor'.tr(): data.identifierForVendor,
      'Label_VersionDisplay_physicalDevice'.tr(): data.isPhysicalDevice,
      'Label_VersionDisplay_sysname'.tr(): data.utsname.sysname,
      'Label_VersionDisplay_nodename'.tr(): data.utsname.nodename,
      'Label_VersionDisplay_release'.tr(): data.utsname.release,
      'Label_VersionDisplay_version'.tr(): data.utsname.version,
      'Label_VersionDisplay_machine'.tr(): data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.25,
      child: ListView(
          children: _deviceData.keys.map((String property) {
            return Center(
              child:Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                      property+': ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Text(
                            '${_deviceData[property]}',
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
    );
  }
}