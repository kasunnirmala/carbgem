import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/patient_attaching_image_list/patient_attaching_image_list.dart';

class PatientAttachingImageListPage extends StatelessWidget {
  const PatientAttachingImageListPage({Key? key}): super(key: key);
  static Page page() => MaterialPage<void>(child: PatientAttachingImageListPage());
  static Route route(){
    return MaterialPageRoute(builder: (_) => const PatientAttachingImageListPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 5, pageName: ""),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => PatientAttachingImageListCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: const PatientAttachingImageListForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
