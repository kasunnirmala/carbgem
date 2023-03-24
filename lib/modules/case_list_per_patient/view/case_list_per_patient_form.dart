import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/case_list_per_patient/case_list_per_patient.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class CaseListPerPatientForm extends StatelessWidget {
  final String patientName;

  CaseListPerPatientForm(this.patientName);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CaseListPerPatientCubit, CaseListPerPatientState>(
      listener: (context, state) {
        if (state.status == CaseListStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state.status == CaseListStatus.addNewUrineError ||
            state.status == CaseListStatus.addNewSpinalError ||
            state.status == CaseListStatus.addNewRespiratoryError ||
            state.status == CaseListStatus.addNewBloodError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Label_case_list_per_patient_alerm_tag".tr())));
        } else if (state.status == CaseListStatus.addNewUrineSuccess ||
            state.status == CaseListStatus.addNewSpinalSuccess ||
            state.status == CaseListStatus.addNewRespiratorySuccess ||
            state.status == CaseListStatus.addNewBloodSuccess) {
          getAlert(
            context: context,
            title: 'dialog_title'.tr(),
            msg: 'Label_case_list_per_patient_dialog_msg'.tr(),
            clickFunction: true,
            okButton: true,
            okFunction: () {},
          );
        } else if (state.status == CaseListStatus.deleteConfirm) {
          getInfo(
            context: context,
            title: "Label_case_list_per_patient_confirm_title".tr(),
            msg:
                "${"Label_case_list_per_patient_confirm_body_head".tr()} ${state.patientTag} ${"Label_case_list_per_patient_confirm_body_back".tr()}",
            infoDialog: true,
            okFunction: () {
              context.read<CaseListPerPatientCubit>().deletePatient();
            },
            cancelFunction: () {
              context.read<CaseListPerPatientCubit>().resetStatus();
            },
          );
        } else if (state.status == CaseListStatus.deleteSuccess) {
          getInfo(
            context: context,
            title: "Patient Deleted!",
            msg: "${state.patientTag} is permanently deleted",
            infoDialog: false,
            okFunction: () {
              context.read<BasicHomeCubit>().pageChanged(value: 3);
            },
          );
        }
      },
      child: BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async =>
              onBackPressed(context: context, pageNumber: 3, navNumber: 0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              context
                  .read<CaseListPerPatientCubit>()
                  .emit(state.copyWith(status: CaseListStatus.success));
            },
            child: Align(
              alignment: Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TopInfoDisplay(
                      topText:
                          '${"Label_title_patientName".tr()}: ${state.patientTag}',
                      bottomText1: '',
                      bottomText2: '',
                    ),
                    // SizedBox(height: 10,),
                    // _DeleteButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _SampleCaseList(
                      tileTitle: 'Label_case_list_per_patient_urine'.tr(),
                      tileSubtitle:
                          '${"CaseNum".tr()}: ${state.caseUrineList.length}',
                      backgroundColor: HexColor('#FFEE93'),
                      caseList: state.caseUrineListFilter,
                      specimenId: "1",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _SampleCaseList(
                      tileTitle: 'Label_case_list_per_patient_blood_aero'.tr(),
                      backgroundColor: HexColor('#FF6962'),
                      tileSubtitle:
                          '${"CaseNum".tr()}: ${state.caseBloodList.length}',
                      caseList: state.caseBloodListFilter,
                      specimenId: "2",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _SampleCaseList(
                      tileTitle: 'Label_case_list_per_patient_blood_an'.tr(),
                      backgroundColor: HexColor('#adf7b6'),
                      tileSubtitle:
                          '${"CaseNum".tr()}: ${state.caseRespiratoryList.length}',
                      caseList: state.caseRespiratoryListFilter,
                      specimenId: "3",
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    _SampleCaseList(
                      tileTitle: 'Label_case_list_per_patient_vaginal'.tr(), backgroundColor: HexColor('#d291bc'), tileSubtitle: '${"CaseNum".tr()}: ${state.caseSpinalList.length}',
                      caseList: state.caseSpinalListFilter, specimenId: "4",
                    ),
                    SizedBox(height: 20,),

                    /// sputum Tag
                    // _SampleCaseList(
                    //   tileTitle: 'Label_case_list_per_patient_cerebrospinalFluid'.tr(), backgroundColor: HexColor('#d291bc'), tileSubtitle: '${"CaseNum".tr()}: ${state.caseSpinalList.length}',
                    //   caseList: state.caseSpinalListFilter, specimenId: "4",
                    // ),
                    // SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
      builder: (context, state) => RoundedLoadingButton(
        controller: _btnController,
        color: Colors.redAccent,
        onPressed: () {
          context.read<CaseListPerPatientCubit>().changeStatus();
          _btnController.reset();
        },
        child: Text("Label_case_list_per_patient_confirm_title".tr()),
      ),
    );
  }
}

class _NewCaseTagField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
      builder: (context, state) => Container(
        key: const Key("patient_not_classified_button"),
        width: double.infinity,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [HexColor('#FFF0E0'), Colors.white]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: TextField(
          key: const Key("case_tag_field"),
          autofocus: true,
          textAlign: TextAlign.center,
          onChanged: (value) {
            context.read<CaseListPerPatientCubit>().caseTagChanged(value);
          },
          decoration: InputDecoration(
              labelText: "Label_case_list_per_patient_input_tag".tr(),
              helperText: ""),
        ),
      ),
    );
  }
}

class _CaseRegisterButton extends StatefulWidget {
  final String specimenId;

  const _CaseRegisterButton({Key? key, required this.specimenId})
      : super(key: key);

  @override
  __CaseRegisterButtonState createState() => __CaseRegisterButtonState();
}

class __CaseRegisterButtonState extends State<_CaseRegisterButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: RoundedLoadingButton(
            controller: _btnController,
            color: Theme.of(context).colorScheme.secondary,
            key: const Key("case_register_button"),
            onPressed: () {
              if (widget.specimenId == "1") {
                context
                    .read<CaseListPerPatientCubit>()
                    .emit(state.copyWith(status: CaseListStatus.addNewUrine));
              } else if (widget.specimenId == "2") {
                context
                    .read<CaseListPerPatientCubit>()
                    .emit(state.copyWith(status: CaseListStatus.addNewBlood));
              } else if (widget.specimenId == "3") {
                context.read<CaseListPerPatientCubit>().emit(
                    state.copyWith(status: CaseListStatus.addNewRespiratory));
              } else {
                context
                    .read<CaseListPerPatientCubit>()
                    .emit(state.copyWith(status: CaseListStatus.addNewSpinal));
              }
            },
            child: (widget.specimenId == "1")
                ? Text(
                    '${"Label_case_list_per_patient_urine".tr()} ${"Label_case_list_per_patient_register_case".tr()}')
                : (widget.specimenId == "2")
                    ? Text(
                        '${"Label_case_list_per_patient_blood_aero".tr()} ${"Label_case_list_per_patient_register_case".tr()}')
                    : (widget.specimenId == "3")
                        ? Text(
                            '${"Label_case_list_per_patient_blood_an".tr()} ${"Label_case_list_per_patient_register_case".tr()}')
                        : Text(
                            '${"Label_case_list_per_patient_vaginal".tr()} ${"Label_case_list_per_patient_register_case".tr()}'),
          ),
        );
      },
    );
  }
}

class _OKRegisterButton extends StatefulWidget {
  final String specimenId;

  const _OKRegisterButton({Key? key, required this.specimenId})
      : super(key: key);

  @override
  __OKRegisterButtonState createState() => __OKRegisterButtonState();
}

class __OKRegisterButtonState extends State<_OKRegisterButton> {
  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
      builder: (context, state) {
        return RoundedLoadingButton(
          controller: _btnController,
          color: Theme.of(context).colorScheme.secondary,
          key: const Key("ok_register_button"),
          onPressed: (state.caseTag == "")
              ? null
              : () {
                  context
                      .read<CaseListPerPatientCubit>()
                      .caseAdd(specimenId: widget.specimenId);
                  // _btnController.reset();
                },
          child: Text('OK'),
        );
      },
    );
  }
}

class _SampleCaseList extends StatelessWidget {
  final String tileTitle;
  final String tileSubtitle;
  final Color backgroundColor;
  final List<Case> caseList;
  final String specimenId;

  const _SampleCaseList(
      {Key? key,
      required this.tileTitle,
      required this.backgroundColor,
      required this.tileSubtitle,
      required this.caseList,
      required this.specimenId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseListPerPatientCubit, CaseListPerPatientState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [backgroundColor, Colors.white]),
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
              tilePadding: EdgeInsets.all(20),
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              leading: Icon(
                FontAwesomeIcons.vial,
                size: 35.0,
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  tileTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  tileSubtitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ((state.status == CaseListStatus.addNewBlood &&
                      specimenId == "2") ||
                      (state.status == CaseListStatus.addNewUrine &&
                          specimenId == "1") ||
                      (state.status == CaseListStatus.addNewRespiratory &&
                          specimenId == "3") ||
                      (state.status == CaseListStatus.addNewSpinal &&
                          specimenId == "4"))
                      ? Container()
                      : TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.search),
                      hintText: "Label_case_list_per_patient_input_tag".tr(),
                    ),
                    onChanged: (value) {
                      if (specimenId == "1") {
                        context
                            .read<CaseListPerPatientCubit>()
                            .searchTextChangedUrine(value: value);
                      } else if (specimenId == "2") {
                        context
                            .read<CaseListPerPatientCubit>()
                            .searchTextChangedBlood(value: value);
                      } else if (specimenId == "3") {
                        context
                            .read<CaseListPerPatientCubit>()
                            .searchTextChangedRespiratory(value: value);
                      } else {
                        context
                            .read<CaseListPerPatientCubit>()
                            .searchTextChangedSpinal(value: value);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ((state.status == CaseListStatus.addNewBlood &&
                    specimenId == "2") ||
                    (state.status == CaseListStatus.addNewUrine &&
                        specimenId == "1") ||
                    (state.status == CaseListStatus.addNewRespiratory &&
                        specimenId == "3") ||
                    (state.status == CaseListStatus.addNewSpinal &&
                        specimenId == "4"))
                    ? _NewCaseTagField()
                    : Container(),
                ((state.status == CaseListStatus.addNewBlood &&
                            specimenId == "2") ||
                        (state.status == CaseListStatus.addNewUrine &&
                            specimenId == "1") ||
                        (state.status == CaseListStatus.addNewRespiratory &&
                            specimenId == "3") ||
                        (state.status == CaseListStatus.addNewSpinal &&
                            specimenId == "4"))
                    ? _OKRegisterButton(specimenId: specimenId)
                    : _CaseRegisterButton(
                        specimenId: specimenId,
                      ),
                ...caseList
                    .map((caseValue) => Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          customTile(
                              context: context,
                              imagePath: 'assets/images/bacteria_icon.png',
                              titleText: '${caseValue.caseTag}',
                              bodyTextList: [
                                '${"imageNum".tr()}: ${caseValue.imageTotal}'
                              ],
                              navIndex: 10,
                              subParameter1: state.patientTag,
                              subParameter2: state.patientId,
                              subParameter3: caseValue.caseTag,
                              subParameter4: caseValue.caseId,
                              subParameter5: specimenId,
                              subParameter16: false,
                              backgroundColor: HexColor('#FFF0E0')),
                          SizedBox(
                            height: 10,
                          ),
                        ]))
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
