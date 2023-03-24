import 'package:carbgem/modules/image_unclassified_delete/cubit/image_unclassified_delete_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';

class ImageUnclassifiedDeleteForm extends StatelessWidget {
  const ImageUnclassifiedDeleteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageUnclassifiedDeleteCubit, ImageUnclassifiedDeleteState>(
      listener: (context, state) {
        if (state.status == ImageUnclassifiedDeleteStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        } else if (state.status == ImageUnclassifiedDeleteStatus.deleteConfirm) {
          getInfo(
            context: context, title: "Label_ImageUnclassifiedDelete_deleteImage".tr(), msg: "Label_ImageUnclassifiedDelete_confirmDelete".tr(),
            infoDialog: true, okFunction: (){context.read<ImageUnclassifiedDeleteCubit>().deleteImage();},
            cancelFunction: (){context.read<ImageUnclassifiedDeleteCubit>().resetState();},
          );
        } else if (state.status == ImageUnclassifiedDeleteStatus.success) {
          getInfo(
            context: context, title: 'Label_ImageUnclassifiedDelete_imageDeleted'.tr(), msg: "Label_ImageUnclassifiedDelete_deleteSuccese".tr(), infoDialog: false,
            okFunction: (){context.read<ImageUnclassifiedDeleteCubit>().resetState();},
          );
        }
      },
      child: BlocBuilder<ImageUnclassifiedDeleteCubit, ImageUnclassifiedDeleteState>(
        builder: (context, state) => (state.status==ImageUnclassifiedDeleteStatus.loading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent,)) :
        WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 5, navNumber: 0),
          child: Align(
            alignment: Alignment(0,-1/3),
            child: ListView(
              children: [
                SizedBox(height: 20,),
                ...state.imageList.map((e) => Column(
                  children: [
                    SizedBox(height: 10,),
                    _DeleteTile(
                      imagePath: e.imageThumbnail!="" ? e.imageThumbnail : e.imagePath,
                      titleText: e.modelPrediction, imageId: e.imageId,),
                    SizedBox(height: 10,),
                  ],
                )),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _DeleteTile extends StatelessWidget {
  final String titleText;
  final String imagePath;
  final String imageId;
  const _DeleteTile({Key? key, required this.titleText, required this.imagePath, required this.imageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUnclassifiedDeleteCubit, ImageUnclassifiedDeleteState>(
      builder: (context, state) => Stack(
        children: [
          Positioned(child: InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 60, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [
                        Colors.redAccent,
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
                padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 60.0, right: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(titleText, style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),),
                            width: MediaQuery.of(context).size.width*0.4,
                          ),
                        ],
                      ),
                      Icon(FontAwesomeIcons.timesCircle, size: 40, color: Colors.redAccent,)
                    ]
                ),
              ),
            ),
            onTap: (){
              print("check $imageId");
              context.read<ImageUnclassifiedDeleteCubit>().setDeleteImage(imageId: imageId);
            },
          )),
          Positioned(
            top: 5,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.5),
                image: DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
