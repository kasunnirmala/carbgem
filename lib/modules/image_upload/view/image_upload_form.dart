import 'dart:io';
import 'package:carbgem/constants/app_constants.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/image_upload/cubit/image_upload_cubit.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_upload/image_upload.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:loading_animations/loading_animations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ripple_animation/ripple_animation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ImageUploadForm extends StatefulWidget {
  ImageUploadForm({Key? key}): super(key: key);

  @override
  State<ImageUploadForm> createState() => _ImageUploadFormState();
}

class _ImageUploadFormState extends State<ImageUploadForm> {
  final GlobalKey btnKey = GlobalKey();
  var _value;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageUploadCubit, ImageUploadState>(
      listener: (context, state) {
        if (state.status == ImageUploadStatus.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Label_ImageUpload_failUpload".tr())));
          context.read<ImageUploadCubit>().changeStatusInitial();
        }
        else if (state.status == ImageUploadStatus.successMulti) {
          if (state.patientId != "") {
                        getAlert(
                context: context,
                title: "Label_ImageUpload_Multi_Bacteria_title".tr(),
                msg: "Label_ImageUpload_Multi_Bacteria_msg".tr(),
                dismissOnTouchOutside: false,
                clickFunction: true,
                okButton: true,
                showCloseIcon: false,
                okFunction: (){
                  context.read<ImageUploadCubit>().emit(state.copyWith(status: ImageUploadStatus.initial));
                  context.read<ImageUploadCubit>().changeStatusInitial();
                  context.read<BasicHomeCubit>().pageChanged(
              value: 10,
              subPageParameter: state.patientName,
              subPageParameter2nd: state.patientId,
              subPageParameter3rd: state.caseName,
              subPageParameter4th: state.caseId,
              subPageParameter5th: state.specimenId,
              subPageParameter16th: true
            );

                }
            );

          }
          else {
            getAlert(
                context: context,
                title: "Label_ImageUpload_Multi_Bacteria_title".tr(),
                msg: "Label_ImageUpload_Multi_Bacteria_msg".tr(),
                clickFunction: true,
                dismissOnTouchOutside: false,
                okButton: true,
                showCloseIcon: false,
                okFunction: (){
                  context.read<ImageUploadCubit>().emit(state.copyWith(status: ImageUploadStatus.initial));
                  context.read<ImageUploadCubit>().changeStatusInitial();

                }
            );
          }

        }
        else if (state.status == ImageUploadStatus.successNone) {
          getAlert(
            context: context,
            title: "Label_ImageUpload_No_Bacteria_title".tr(),
            msg: "Label_ImageUpload_No_Bacteria_msg".tr(), // => "画像に菌がいません"
            clickFunction: true,
            dismissOnTouchOutside: false,
            okButton: true,
            showCloseIcon: false,
            okFunction: (){
              context.read<ImageUploadCubit>().emit(state.copyWith(status: ImageUploadStatus.initial));
              if (state.patientId != "") {
                context.read<BasicHomeCubit>().pageChanged(
                  value: 10,
                  subPageParameter: state.patientName,
                  subPageParameter2nd: state.patientId,
                  subPageParameter3rd: state.caseName,
                  subPageParameter4th: state.caseId,
                  subPageParameter5th: state.specimenId,
                  subPageParameter16th: true
                );
              }
            }
          );
          context.read<ImageUploadCubit>().changeStatusInitial();
        }
        else if ((state.status == ImageUploadStatus.successSingle) & (state.lockDiscard == false)) {
          getInfo(
            context: context,
            title: "Label_ImageUpload_Single_Bacteria_title".tr(),
            msg: "Label_ImageUpload_Single_Bacteria_msg".tr(), // =>"画像に菌がいます!"
            infoDialog: true,
            okFunction: (){},
          );
        }
      },
      child: BlocBuilder<ImageUploadCubit, ImageUploadState>(
        builder: (context, state) {
          return (state.status == ImageUploadStatus.loading) ? Center(child: CircularProgressIndicator()) :
          WillPopScope(
            onWillPop: () async => (state.patientId=="") ? onBackPressed(context: context, pageNumber: 0, navNumber: 0) :
            onBackPressed(
              context: context, pageNumber: 10, navNumber: 0, subParameter: state.patientName,
              subParameter2nd: state.patientId, subParameter3rd: state.caseName, subParameter4th: state.caseId,
              subParameter5th: state.specimenId,
            ),
            child: Container(
              // decoration: BoxDecoration(color: Colors.black),
              child: (state.imageFilePathToUpload=="" || state.imageFilePathToUpload=="None") ? Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RippleAnimation(
                          child: Column(
                            children: [
                              InkWell(
                                child: Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.camera, size: 50, color: Colors.blue.shade400),
                                        Text("Label_imageUpload_icon_title_camera".tr(), style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.blue))
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width*0.4, height: MediaQuery.of(context).size.height*0.2,
                                ),
                                onTap: () async {
                                  context.read<BasicHomeCubit>().eventUploadImageCamera();
                                  String imagePath = await selectFromCamera();
                                  context.read<ImageUploadCubit>().imageFilePathChanged(imagePath);
                                },
                              ),
                            ],
                          ),
                          color: Colors.blueAccent, repeat: true,),
                        RippleAnimation(
                          child: Column(
                            children: [
                              InkWell(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(child: Icon(FontAwesomeIcons.image, size: 50, color: Colors.red.shade400),),
                                      Text("Label_imageUpload_icon_title_photo".tr(),style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red),)
                                    ],
                                  ),
                                  width: MediaQuery.of(context).size.width*0.4, height: MediaQuery.of(context).size.height*0.2,
                                ),
                                onTap: () async {
                                  context.read<BasicHomeCubit>().eventUploadImageGallery();
                                  String imagePath = await selectFromGallery();
                                  context.read<ImageUploadCubit>().imageFilePathChanged(imagePath);
                                },
                              ),
                            ],
                          ),
                          color: Colors.redAccent, repeat: true,),
                      ],
                    ),
                  ],
                ),
              ) :
              (state.status == ImageUploadStatus.success) ? Column(
                children: [
                  _ImageBoxWithCubit(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        _ResultDisplayButton(imageId: state.imageId,),
                        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        // _DiscardButton(),
                      ],
                    ),
                  ),
                ],
              ) :
              (state.status == ImageUploadStatus.uploadInProgress) ? Column(
                children: [
                  _ImageBoxWithCubit(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent,),
                ],
              ) :
              ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImageBoxWithCubit(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                    child: Column(
                      children: [
                        (state.status==ImageUploadStatus.successSingle || state.status==ImageUploadStatus.successMulti) ? Container() :Align(
                          alignment: Alignment(-1, 0),
                            child: Text("${"検体".tr()}:", style: Theme.of(context).textTheme.bodyText1)
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0),
                          child: Row(
                            children: [
                              (state.status==ImageUploadStatus.successSingle || state.status==ImageUploadStatus.successMulti) ? Container() : Expanded(
                                flex: 3,
                                child: Container(
                                  child: (state.patientId=="")? DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _value==null? null: _value,
                                      isExpanded: true,
                                      hint: Text("検体を選択して下さい。"),
                                      onChanged: (value){
                                        print("specimen Id changed to $value");
                                        context.read<ImageUploadCubit>().changeSpecimenId(value: '$value');
                                        _value = value;
                                    },
                                    items: imageUploadSpecimenList.map((e) {
                                      return DropdownMenuItem(
                                        value: e['code'],
                                        child: Center(
                                            child: Text(e['value'], style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 20))),
                                      );
                                    }).toList(),
                                  )
                                  ) : Center(child: Text("${imageUploadSpecimenList[int.parse(state.specimenId)-1]["value"]}", style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 25)))
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        (state.status==ImageUploadStatus.successSingle || state.status==ImageUploadStatus.successMulti) ? estimateImageButton() : Estimate3CatButton(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        (state.lockDiscard==false) ? _DiscardButton() : Container(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String imagePath;
  _ImageBox(this.imagePath);
  
  @override
  Widget build(BuildContext context) {
    return (imagePath=="" || imagePath=="None") ? Container() :
    AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        child: Image.file(File(imagePath)),
      ),
    );
    // return Image.file(File(image_path));
  }
}
class _ImageBoxWithCubit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploadCubit, ImageUploadState>(
      buildWhen: (previous, current) => previous.imageFilePathToUpload != current.imageFilePathToUpload,
      builder: (context, state){
        return _ImageBox(state.imageFilePathToUpload);
      },
    );
  }
}

class _DiscardButton extends StatefulWidget {
  @override
  __DiscardButtonState createState() => __DiscardButtonState();
}
class __DiscardButtonState extends State<_DiscardButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: _btnController,
      color: HexColor("#FF6962"),
      onPressed: (){
        context.read<ImageUploadCubit>().rechooseImage();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.timesCircle),
          SizedBox(width: 20,),
          Text("Label_ImageUpload_button_rechoose".tr(), style: Theme.of(context).textTheme.button,)
        ],
      ),
    );
  }
}

class _ResultDisplayButton extends StatefulWidget {
  final String imageId;

  const _ResultDisplayButton({Key? key, required this.imageId}) : super(key: key);
  @override
  __ResultDisplayButtonState createState() => __ResultDisplayButtonState();
}
class __ResultDisplayButtonState extends State<_ResultDisplayButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploadCubit, ImageUploadState>(
      builder: (context, state)=> RoundedLoadingButton(
        controller: _btnController,
        color: Theme.of(context).colorScheme.secondary,
        key: const Key("display_button_image_upload"),
        onPressed: () {
          if (state.patientId == "") {
            context.read<BasicHomeCubit>().pageChanged(
              value: 13, subPageParameter: widget.imageId, subPageParameter2nd: '未入力',
              subPageParameter3rd: 'unknown', subPageParameter4th: "unknown",
              subPageParameter5th: 'unknown', subPageParameter6th: 'unknown',
              subPageParameter7th: state.specimenId,
            );
          } else {
            context.read<BasicHomeCubit>().pageChanged(
              value: 13, subPageParameter: widget.imageId, subPageParameter2nd: '未入力',
              subPageParameter3rd: state.patientId, subPageParameter4th: state.patientName,
              subPageParameter5th: state.caseId, subPageParameter6th: state.caseName,
              subPageParameter7th: state.specimenId,
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload),
            SizedBox(width: 20,),
            Text("Label_ImageUpload_displayResult".tr()),
          ],
        ),
      ),
    );
  }
}

class Estimate3CatButton extends StatefulWidget {
  const Estimate3CatButton({Key? key}) : super(key: key);

  @override
  _Estimate3CatButtonState createState() => _Estimate3CatButtonState();
}

class _Estimate3CatButtonState extends State<Estimate3CatButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploadCubit, ImageUploadState>(
      builder: (context, state) => RoundedLoadingButton(
          controller: _btnController,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: (){
            print(state.specimenId);
            /// Alert: only analyze for urine sample
            if (state.specimenId=="1") {
              context.read<ImageUploadCubit>().image3Cat();

            } else if (state.specimenId=="0") {
              getInfo(
                context: context,
                title: "Label_ImageUpload_unselectedDialog_title".tr(),
                msg: "Label_ImageUpload_unselectedDialog_msg".tr(),
                infoDialog: true,
                okFunction: (){},
              );
            }else {
              getInfo(
                context: context, title: "Label_ImageListPerCase_infoDialog_title".tr(),
                msg: "Label_ImageListPerCase_infoDialog_msg".tr(), infoDialog: true, okFunction: (){},);
            }
            // context.read<ImageUploadCubit>().imageJudgement();
            _btnController.reset();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.diagnoses),
              SizedBox(width: 20,),
              Text("Label_ImageUpload_button_3CatEstimation".tr()),
            ],
          )),
    );
  }
}



class estimateImageButton extends StatelessWidget {

// class estimateImageButton extends StatefulWidget {
//   const estimateImageButton({Key? key}) : super(key: key);
//
//   @override
//   _estimateImageButtonState createState() => _estimateImageButtonState();
// }
// class _estimateImageButtonState extends State<estimateImageButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploadCubit, ImageUploadState>(
      builder: (context, state) => RoundedLoadingButton(
        controller: _btnController,
        color: Theme.of(context).colorScheme.secondary,
          onPressed: () async {
          String imageId = await context.read<ImageUploadCubit>().imageJudgement();;
          _btnController.reset();
          print(imageId);

          if (imageId != "error") {
            if (state.patientId == "")  {
              context.read<BasicHomeCubit>().pageChanged(
                value: 13, subPageParameter: imageId, subPageParameter2nd: '未確定',
                subPageParameter3rd: 'unknown', subPageParameter4th: "unknown",
                subPageParameter5th: 'unknown', subPageParameter6th: 'unknown',
                subPageParameter7th: state.specimenId,
              );
            } else {
              context.read<BasicHomeCubit>().pageChanged(
                value: 13, subPageParameter: imageId, subPageParameter2nd: '未確定',
                subPageParameter3rd: state.patientId, subPageParameter4th: state.patientName,
                subPageParameter5th: state.caseId, subPageParameter6th: state.caseName,
                subPageParameter7th: state.specimenId,
              );
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.diagnoses),
            SizedBox(width: 20,),
            Text("Label_ImageUpload_button_startEstimation".tr()),
          ],
        )),
    );
  }
}
