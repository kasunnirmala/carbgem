import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/patient_not_classified_image_list/patient_not_classified_image_list.dart';

class PatientNotClassifiedImagePage extends StatelessWidget {
  const PatientNotClassifiedImagePage({Key? key}): super(key: key);
  static Page page() => MaterialPage<void>(child: PatientNotClassifiedImagePage());
  static Route route(){
    return MaterialPageRoute(builder: (_) => const PatientNotClassifiedImagePage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 0, pageName: "Label_Title_notClassifiedImage"),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => PatientNotClassifiedImageCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: const PatientNotClassifiedImageForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
