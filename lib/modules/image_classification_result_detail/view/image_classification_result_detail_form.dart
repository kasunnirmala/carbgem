import 'package:before_after/before_after.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_classification_result_detail/image_classification_result_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ImageClassificationResultDetailForm extends StatefulWidget {
  @override
  State<ImageClassificationResultDetailForm> createState() =>
      ImageClassificationResultDetailFormState();
}

class ImageClassificationResultDetailFormState
    extends State<ImageClassificationResultDetailForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      listener: (context, state) {
        if (state.status == ImageClassificationResultDetailStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        } else if (state.status ==
            ImageClassificationResultDetailStatus.selectFungiSuccess) {
          getAlert(
            context: context,
            title: 'dialog_title'.tr(),
            msg: '${"selectFungi".tr()}:  \n  ${state.finalJudgement}',
            clickFunction: true,
            okButton: true,
            okFunction: () {},
          );
        } else if (state.status ==
            ImageClassificationResultDetailStatus.detachSuccess) {
          getAlert(
            context: context,
            title: 'dialog_title'.tr(),
            msg: 'Label_imageClassificationResultDetail_release'.tr(),
            clickFunction: true,
            okButton: true,
            okFunction: () {},
          );
        }
      },
      child: BlocBuilder<ImageClassificationResultDetailCubit,
          ImageClassificationResultDetailState>(builder: (context, state) {
        return (state.status == ImageClassificationResultDetailStatus.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : WillPopScope(
                onWillPop: () async => (state.patientId == "unspecified")
                    ? onBackPressed(
                        context: context, pageNumber: 5, navNumber: 0)
                    : (state.patientId == 'unknown')
                        ? onBackPressed(
                            context: context,
                            pageNumber: 1,
                            navNumber: 1,
                            subParameter: '',
                            subParameter2nd: "",
                            subParameter3rd: "",
                            subParameter4th: "",
                            subParameter5th: "",
                          )
                        : onBackPressed(
                            context: context,
                            pageNumber: 10,
                            navNumber: 0,
                            subParameter: state.patientName,
                            subParameter2nd: state.patientId,
                            subParameter3rd: state.caseName,
                            subParameter4th: state.caseId,
                            subParameter5th: state.specimenId),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.read<ImageClassificationResultDetailCubit>().emit(
                        state.copyWith(
                            status:
                                ImageClassificationResultDetailStatus.success));
                  },
                  child: Align(
                    alignment: Alignment(0, -1 / 3),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _FungiResultTile(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}

class _DetectionImageListViewForCloud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      builder: (context, state) => Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          height: MediaQuery.of(context).size.height * 0.3,
          child: (state.fungiResult.imageGrad == "")
              ? GestureDetector(
                  child: Image.network(
                    state.fungiResult.imagePath,
                  ),
                  onTap: () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: "",
                      context: context,
                      pageBuilder: (context, animation1, animation2) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Image.network(
                              state.fungiResult.imagePath,
                            ),
                          ],
                          // child: Image.network(state.fungiResult.imagePath,),
                          // child: Column(
                          //   children: [
                          //     TextButton(
                          //         onPressed: (){
                          //           Navigator.of(context).pop();
                          //         },
                          //         child: Text("close"),
                          //     ),
                          //     Image.network(state.fungiResult.imagePath,),
                          //   ],
                          // ),
                        );
                      },
                    );
                  },
                )
              : BeforeAfter(
                  beforeImage: Image.network(state.fungiResult.imagePrep),
                  afterImage: Image.network(state.fungiResult.imageGrad))),
    );
  }
}

class _FungiResultTile extends StatefulWidget {
  @override
  __FungiResultTileState createState() => __FungiResultTileState();
}

class __FungiResultTileState extends State<_FungiResultTile> {
  // final TextEditingController _typeAheadController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String checkJudgement = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView(children: [
          (state.patientId != "unknown" && state.specimenId != "")
              ? Center(
                  child: Text(
                      "患者ID:${state.patientName} 検体ID:${state.specimenId}"))
              : Container(),
          _DetectionImageListViewForCloud(),
          (state.patientName == "unspecified" ||
                  state.patientName == 'unknown' ||
                  state.status ==
                      ImageClassificationResultDetailStatus.detachSuccess)
              ? Container()
              : SizedBox(
                  height: 10,
                ),
          (state.lowConfidenceScore)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          (state.lowConfidenceScore) ? _AlertLowConfidence() : Container(),
          (state.closeTop2)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          (state.closeTop2) ? _AlertMultipleBacteria() : Container(),
          (state.gramNegativeTop2)
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          (state.gramNegativeTop2) ? _AlertGramNegative() : Container(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [HexColor('#bbeaff'), Colors.white],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.userMd,
                  size: 35,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Container(
                    child: (state.status ==
                            ImageClassificationResultDetailStatus.selectFungi)
                        ? Text(
                            checkJudgement != ""
                                ? checkJudgement
                                : '${state.finalJudgement}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        : Container(
                            child: (state.finalJudgement != "未入力")
                                ? Text(
                                    '${state.finalJudgement}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                : Text(
                                    '${"Label_Title_species_result_2".tr()} : ${state.finalJudgement}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                          ),
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(right: 70.0, left: 20),
                  child: (state.status ==
                              ImageClassificationResultDetailStatus
                                  .selectFungi &&
                          checkJudgement != "")
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextButton(
                                key: const Key(
                                    'cancel_button_classification_result'),
                                onPressed: () {
                                  context
                                      .read<
                                          ImageClassificationResultDetailCubit>()
                                      .emit(state.copyWith(
                                          status:
                                              ImageClassificationResultDetailStatus
                                                  .success));
                                  setState(() {
                                    checkJudgement = "";
                                  });
                                },
                                child: Text(
                                  'cancel'.tr(),
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                key: const Key(
                                    'ok_button_classification_result'),
                                onPressed: () {
                                  context
                                      .read<
                                          ImageClassificationResultDetailCubit>()
                                      .determineFinalFungiJudgement(
                                          value: checkJudgement);
                                },
                                child: Text('ok'.tr()),
                              ),
                            ),
                          ],
                        )
                      : TextButton(
                          key: const Key(
                              'select_fungi_button_classification_result'),
                          onPressed: () {
                            context
                                .read<ImageClassificationResultDetailCubit>()
                                .emit(state.copyWith(
                                    status:
                                        ImageClassificationResultDetailStatus
                                            .selectFungi));
                            showBarModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  List<FungiType> filterFungiList =
                                      state.fungiList;
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setModalState) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: ListView(children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(FontAwesomeIcons.search),
                                            hintText:
                                                "imageClassificationResultDetail_searchFungi_input"
                                                    .tr(),
                                          ),
                                          onChanged: (value) {
                                            List<FungiType> tempList = [];
                                            for (int i = 0;
                                                i < state.fungiList.length;
                                                i++) {
                                              if (state.fungiList[i].fungiName
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase())) {
                                                tempList
                                                    .add(state.fungiList[i]);
                                              }
                                            }
                                            tempList.sort((a, b) => a.fungiName
                                                .compareTo(b.fungiName));
                                            setModalState(() {
                                              filterFungiList = tempList;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ...filterFungiList.map((e) {
                                          return Card(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            color: Colors.lightBlue.shade50,
                                            elevation: 5,
                                            child: ListTile(
                                              leading:
                                                  Icon(FontAwesomeIcons.virus),
                                              title: Text(
                                                "${e.fungiName}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  checkJudgement = e.fungiName;
                                                });
                                                print(checkJudgement);
                                                Navigator.pop(context);
                                                // context.read<ImageClassificationResultDetailCubit>().changeJudgement(selectJudgement: e.fungiName);
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ]),
                                    );
                                  });
                                });
                            // context.read<ImageClassificationResultDetailCubit>().emit(state.copyWith(status: ImageClassificationResultDetailStatus.selectFungi));
                          },
                          child: (state.finalJudgement != "未入力")
                              ? Text('modify'.tr())
                              : Text('choose'.tr()),
                        ),
                ),
              ),
            ),
          ),
          ...state.fungiResult.fungiList
              .map((fungiTile) => Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [HexColor('#ecad8f'), Colors.white],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.disease,
                              size: 35,
                            ),
                            title: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Container(
                                child: Text(
                                  '${fungiTile.fungiName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                width: MediaQuery.of(context).size.width * 0.7,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: LinearProgressIndicator(
                                      value: fungiTile.confidenceRate,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                  Text(
                                      "${(fungiTile.confidenceRate * 100).toStringAsFixed(2)} %")
                                ],
                              ),
                            ),
                            onTap: () {
                              context.read<BasicHomeCubit>().pageChanged(
                                    value: 16,
                                    subPageParameter: fungiTile.fungiName,
                                    // subPageParameter2nd: state.fungiResult.fungiJudgement,
                                    subPageParameter3rd: state.patientId,
                                    subPageParameter4th: state.patientName,
                                    subPageParameter5th: state.caseId,
                                    subPageParameter6th: state.caseName,
                                    subPageParameter7th:
                                        '${fungiTile.fungiCode}',
                                    subPageParameter8th: "1",
                                    subPageParameter9th: state.imageId,
                                    subPageParameter10th: state.specimenId,
                                  );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ))
              .toList(),
          SizedBox(height: 10),
          (state.patientName == "unspecified" ||
                  state.patientName == "unknown" ||
                  state.status ==
                      ImageClassificationResultDetailStatus.detachSuccess)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RoundedLoadingButton(
                    controller: _btnController,
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      context
                          .read<ImageClassificationResultDetailCubit>()
                          .imageDetach();
                    },
                    child: Text("release".tr()),
                  ),
                ),
          SizedBox(height: 40)
        ]),
      ),
    );
  }
}

class _AlertLowConfidence extends StatelessWidget {
  const _AlertLowConfidence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.exclamationCircle,
              color: Colors.white,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "判定不能",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertMultipleBacteria extends StatelessWidget {
  const _AlertMultipleBacteria({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.exclamationCircle,
              color: Colors.white,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "複数の菌がある可能性があります。",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertGramNegative extends StatelessWidget {
  const _AlertGramNegative({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultDetailCubit,
        ImageClassificationResultDetailState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.exclamationCircle,
              color: Colors.white,
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "グラム陰性桿菌に注意してください",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
