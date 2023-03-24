import 'package:carbgem/modules/all.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:carbgem/modules/version_display/version_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VersionDisplayPage extends StatelessWidget {
  const VersionDisplayPage({Key? key}): super(key: key);
  static Page page() => MaterialPage<void>(child: VersionDisplayPage());
  static Route route(){
    return MaterialPageRoute(builder: (_) => const VersionDisplayPage());
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicHomeCubit, BasicHomeState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Label_Title_versionDisplay'.tr(),style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.withOpacity(0.9),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        endDrawer: (state.status==BasicHomeStatus.unactivated) ? CustomUnactivatedDrawer() :CustomDrawer(),
        body: Padding(
          padding: EdgeInsets.all(40),
          child: const VersionDisplay(),
        ),
        // bottomNavigationBar: CustomNavigationBar(),
      );
    });
  }
}
