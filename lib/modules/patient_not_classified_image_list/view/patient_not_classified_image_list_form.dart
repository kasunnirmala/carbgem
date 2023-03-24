import 'package:carbgem/modules/patient_not_classified_image_list/patient_not_classified_image_list.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PatientNotClassifiedImageForm extends StatelessWidget {
  const PatientNotClassifiedImageForm({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
      listener: (context, state) {
        if (state.status == PatientNotClassifiedImageStatus.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        }
      },
      child: BlocBuilder<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
          child: Align(
            alignment: Alignment(0,-1/3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  // Text(
                  // "患者未分類画像一覧",
                  // style: Theme.of(context).textTheme.headline5
                  // ),
                  // SizedBox(height: ,),
                  _ImageGridView(),
                  _PatientUnclassifiedButton(),
                  SizedBox(height: 10,),
                  // _ImageDeleteButton(),
                  // SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final int indexValue;
  _ImageView({required this.indexValue});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
      builder: (context, state) => InkWell(
        child: Column(
          children: [
            SizedBox(
              child: Image.network(state.imageList[indexValue].imageThumbnail != "" ? state.imageList[indexValue].imageThumbnail : state.imageList[indexValue].imagePath),
              height: MediaQuery.of(context).size.width*0.3,),
            Container(
              child: Center(child: Text(state.imageList[indexValue].modelPrediction, style: Theme.of(context).textTheme.caption,)),
              width: MediaQuery.of(context).size.width*0.4,
            ),
          ],
        ),
        onTap: () {
          context.read<BasicHomeCubit>().pageChanged(
            value: 13, subPageParameter: state.imageList[indexValue].imageId,
            subPageParameter2nd: state.imageList[indexValue].finalJudgement,
            subPageParameter3rd: "unspecified", subPageParameter4th: "unspecified",
            subPageParameter5th: "unspecified", subPageParameter6th: "unspecified",
          );
        },
      ),
    );
  }
}

class _ImageGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
      builder: (context, state) => SizedBox(
        height: MediaQuery.of(context).size.height*0.55,
        child: GridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            for (var i = 0; i < state.imageList.length; i++) ...[
              _ImageView(indexValue: i,)
            ]
          ]
        )
      )
    );
  }
}
class _PatientUnclassifiedButton extends StatefulWidget {
  @override
  __PatientUnclassifiedButtonState createState() => __PatientUnclassifiedButtonState();
}

class __PatientUnclassifiedButtonState extends State<_PatientUnclassifiedButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
      builder:(context, state) => RoundedLoadingButton(
        controller: _btnController,
        color: Theme.of(context).colorScheme.secondary,
        key: const Key("patient_unclassified_button"),
        onPressed: (state.imageList.length==0) ? null : () => context.read<BasicHomeCubit>().pageChanged(value: 6),
        child: Text('Label_notClassifiedImageList_registerPatient'.tr()),
      ),
    );
  }
}

class _ImageDeleteButton extends StatefulWidget {
  const _ImageDeleteButton({Key? key}) : super(key: key);

  @override
  _ImageDeleteButtonState createState() => _ImageDeleteButtonState();
}

class _ImageDeleteButtonState extends State<_ImageDeleteButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientNotClassifiedImageCubit, PatientNotClassifiedImageState>(
      builder:(context, state) => RoundedLoadingButton(
        controller: _btnController,
        color: Colors.redAccent,
        key: const Key("image_delete_button"),
        onPressed: (state.imageList.length==0) ? null : () => context.read<BasicHomeCubit>().pageChanged(value: 8),
        child: Text('Label_notClassifiedImageList_deleteImage'.tr()),
      ),
    );
  }
}
