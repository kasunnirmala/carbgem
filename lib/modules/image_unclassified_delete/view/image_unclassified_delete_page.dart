import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/image_unclassified_delete/image_unclassified_delete.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ImageUnclassifiedDeletePage extends StatelessWidget {
  const ImageUnclassifiedDeletePage({Key? key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: ImageUnclassifiedDeletePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackArrowModified(context: context, pageNumber: 5, pageName: "",),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => ImageUnclassifiedDeleteCubit(context.read<AuthenticationRepository>(), context.read<BitteApiClient>()),
          child: ImageUnclassifiedDeleteForm(),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
