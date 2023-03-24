import 'package:carbgem/modules/all.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_list_per_case/image_list_per_case.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class ImageListPerCaseForm extends StatelessWidget {
  final GlobalKey btnKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageListPerCaseCubit, ImageListPerCaseState>(
      listener: (context, state) {
        if (state.status == ImageListPerCaseStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        }
        else if (state.showMenu == true && state.specimenId == "1") {
          showFloatingModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return ModalFit(
                  cameraClick: ({required String imagePath}) {
                    context.read<BasicHomeCubit>().pageChanged(
                      value: 1,
                      subPageParameter: imagePath,
                      subPageParameter2nd: state.patientId,
                      subPageParameter3rd: state.caseId,
                      subPageParameter4th: state.patientTag,
                      subPageParameter5th: state.caseTag,
                      subPageParameter6th: state.specimenId,
                    );
                    Navigator.of(context).pop();
                  },
                  galleryClick: ({required String imagePath}) {
                    context.read<BasicHomeCubit>().pageChanged(
                      value: 1,
                      subPageParameter: imagePath,
                      subPageParameter2nd: state.patientId,
                      subPageParameter3rd: state.caseId,
                      subPageParameter4th: state.patientTag,
                      subPageParameter5th: state.caseTag,
                      subPageParameter6th: state.specimenId,
                    );
                    Navigator.of(context).pop();
                  },
                );
              });
          context
              .read<ImageListPerCaseCubit>()
              .emit(state.copyWith(status: ImageListPerCaseStatus.success));
          // context.read<ImageListPerCaseCubit>().emit(state.copyWith(showMenu: false));
          // getAlert(
          //     context: context,
          //     title: "Label_ImageUpload_Multi_Bacteria_title".tr(),
          //     msg: "Label_ImageUpload_Multi_Bacteria_msg".tr(),
          //     clickFunction: true,
          //     okButton: true,
          //     showCloseIcon: false,
          //     okFunction: (){
          //       print("going to new page");
          //                 context.read<BasicHomeCubit>().pageChanged(
          //                 value: 10,
          //                 subPageParameter2nd: state.patientId,
          //                 subPageParameter3rd: state.caseId,
          //                 subPageParameter4th: state.patientTag,
          //                 subPageParameter5th: state.caseTag,
          //                 subPageParameter6th: state.specimenId,
          //                 subPageParameter16th: false
          //               );
          //     }
          // );
        }
        else if (state.status == ImageListPerCaseStatus.showMenu && state.specimenId == "1") {
          showFloatingModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return ModalFit(
                  cameraClick: ({required String imagePath}) {
                    context.read<BasicHomeCubit>().pageChanged(
                          value: 1,
                          subPageParameter: imagePath,
                          subPageParameter2nd: state.patientId,
                          subPageParameter3rd: state.caseId,
                          subPageParameter4th: state.patientTag,
                          subPageParameter5th: state.caseTag,
                          subPageParameter6th: state.specimenId,
                        );
                  },
                  galleryClick: ({required String imagePath}) {
                    context.read<BasicHomeCubit>().pageChanged(
                          value: 1,
                          subPageParameter: imagePath,
                          subPageParameter2nd: state.patientId,
                          subPageParameter3rd: state.caseId,
                          subPageParameter4th: state.patientTag,
                          subPageParameter5th: state.caseTag,
                          subPageParameter6th: state.specimenId,
                        );
                  },
                );
              });
          context
              .read<ImageListPerCaseCubit>()
              .emit(state.copyWith(status: ImageListPerCaseStatus.success));
        }
        else if (state.status == ImageListPerCaseStatus.showMenu && state.specimenId != "1") {
          getInfo(
              context: context,
              title: "Label_ImageListPerCase_infoDialog_title".tr(),
              msg: "Label_ImageListPerCase_infoDialog_msg".tr(),
              infoDialog: true,
              okFunction: () {
                context.read<ImageListPerCaseCubit>().emit(
                    state.copyWith(status: ImageListPerCaseStatus.success));
              });
        }
        else if (state.status == ImageListPerCaseStatus.deleteConfirm) {
          getInfo(
            context: context,
            title: "Label_ImageListPerCaseForm_deleteCase".tr(),
            msg:
                "${"Label_ImageListPerCaseForm_delete".tr()} ${state.caseTag} ${"Label_ImageListPerCaseForm_permanently".tr()}?",
            infoDialog: true,
            okFunction: () {
              context.read<ImageListPerCaseCubit>().deleteCase();
            },
            cancelFunction: () {
              context.read<ImageListPerCaseCubit>().resetStatus();
            },
          );
        }
        else if (state.status == ImageListPerCaseStatus.deleteSuccess) {
          getInfo(
            context: context,
            title: "Label_ImageListPerCaseForm_caseDeleted".tr(),
            msg:
                "${state.caseTag} ${"Label_ImageListPerCaseForm_permanentlyDeleted".tr()}",
            infoDialog: false,
            okFunction: () {
              context.read<BasicHomeCubit>().pageChanged(
                  value: 7,
                  subPageParameter: state.patientId,
                  subPageParameter2nd: state.patientTag);
            },
          );
        }
      },
      child: BlocBuilder<ImageListPerCaseCubit, ImageListPerCaseState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => onBackPressed(
                context: context,
                pageNumber: 7,
                navNumber: 0,
                subParameter: state.patientId,
                subParameter2nd: state.patientTag),
            child: Align(
              alignment: Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 20,
                  ),
                  _CaseInfoTile(),
                  SizedBox(
                    height: 20,
                  ),
                  _ImageListTile(
                    btnKey: btnKey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // _CaseDeRegisterButton(caseId: caseId, caseName: caseName, patientId: patientId, patientName: patientName,)
                ]),
              ),
            ),
          );
        }
      ),
    );
  }
}

class _CaseInfoTile extends StatefulWidget {
  @override
  __CaseInfoTileState createState() => __CaseInfoTileState();
}

class __CaseInfoTileState extends State<_CaseInfoTile> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  // RoundedLoadingButtonController _deleteController =
  //     RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageListPerCaseCubit, ImageListPerCaseState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient:
                  LinearGradient(colors: [HexColor('#bbeaff'), Colors.white]),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              tilePadding: EdgeInsets.all(20),
              leading: Icon(
                FontAwesomeIcons.stream,
                size: 35,
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Align(
                      child: Text(
                        '${"Label_title_patientName".tr()}: ${state.patientTag}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Align(
                      child: Text(
                        '${"Label_case_summary_case".tr()}: ${state.caseTag}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
              children: [
                ListTile(
                  leading:
                      ImageIcon(AssetImage('assets/images/stethoscope.png')),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text(
                          "${"Label_case_list_per_patient_diagnosis".tr()}:",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        child: Container(
                          child: Text(
                            '${state.imageResult.fungiJudgement}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: ImageIcon(AssetImage('assets/images/pill.png')),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        child: Text(
                          "${"chosenMedicine".tr()}:",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        child: Container(
                          child: Text(
                            '${state.imageResult.drugJudgement}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedLoadingButton(
                  controller: _btnController,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    context.read<BasicHomeCubit>().pageChanged(
                          value: 18,
                          subPageParameter: state.patientTag,
                          subPageParameter2nd: state.patientId,
                          subPageParameter3rd: state.caseTag,
                          subPageParameter4th: state.caseId,
                          subPageParameter5th: state.specimenId,
                        );
                  },
                  child: Text('Label_case_list_per_patient_button'.tr()),
                ),
                // SizedBox(height: 10,),
                // RoundedLoadingButton(
                //   controller: _deleteController,
                //   color: Colors.redAccent,
                //   onPressed: (){
                //     context.read<ImageListPerCaseCubit>().changeStatus();
                //     _deleteController.reset();
                //   },
                //   child: Text("Label_ImageListPerCaseForm_deleteCase".tr()),
                // ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageListTile extends StatefulWidget {
  final GlobalKey btnKey;

  const _ImageListTile({Key? key, required this.btnKey}) : super(key: key);

  @override
  __ImageListTileState createState() => __ImageListTileState();
}

class __ImageListTileState extends State<_ImageListTile> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageListPerCaseCubit, ImageListPerCaseState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient:
                  LinearGradient(colors: [HexColor('#ecad8f'), Colors.white]),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              tilePadding: EdgeInsets.all(20),
              leading: Icon(
                FontAwesomeIcons.image,
                size: 35,
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Label_ImageListPerCaseForm_imageList'.tr(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5),
                child: Text(
                  '${"imageNum".tr()}: ${state.imageResult.imageList.length}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: RoundedLoadingButton(
                    controller: _btnController,
                    color: Theme.of(context).colorScheme.secondary,
                    key: widget.btnKey,
                    onPressed: () {
                      if (state.status != ImageListPerCaseStatus.showMenu) {
                        context.read<ImageListPerCaseCubit>().emit(state
                            .copyWith(status: ImageListPerCaseStatus.showMenu));
                      } else {
                        context.read<ImageListPerCaseCubit>().emit(state
                            .copyWith(status: ImageListPerCaseStatus.success));
                      }
                      _btnController.reset();
                    },
                    child:
                        Text('Label_ImageListPerCaseForm_registerImage'.tr()),
                  ),
                ),
                ...state.imageResult.imageList
                    .map((imageValue) => Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            customTile(
                              borderColor: (imageValue.finalJudgement == "未入力"),
                              context: context,
                              imagePath: imageValue.imageThumbnail != ""
                                  ? imageValue.imageThumbnail
                                  : imageValue.imagePath,
                              titleText:
                                  'Label_ImageListPerCaseForm_doctorDiagnose'.tr(),
                              bodyTextList: ['${imageValue.finalJudgement}'],
                              navIndex: 13,
                              imageAsset: false,
                              backgroundColor: HexColor('#FFF0E0'),
                              subParameter1: imageValue.imageId,
                              subParameter2: imageValue.finalJudgement,
                              subParameter3: state.patientId,
                              subParameter4: state.patientTag,
                              subParameter5: state.caseId,
                              subParameter6: state.caseTag,
                              subParameter7: state.specimenId,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
