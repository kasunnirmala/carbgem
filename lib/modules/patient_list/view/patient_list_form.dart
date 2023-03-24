import 'package:carbgem/modules/all.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/patient_list/patient_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PatientListForm extends StatelessWidget {
  const PatientListForm({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientListCubit, PatientListState>(
      listener: (context, state) {
        if (state.status == PatientListStatus.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        } else if (state.status == PatientListStatus.addNewSucess){
          getAlert(context: context,
            title: 'dialog_title'.tr(),
            msg: 'Label_PatientList_registerPatientSuccess'.tr(),
            clickFunction: true, okButton: true, okFunction: (){},
          );
        } else if (state.status == PatientListStatus.addNewError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Label_PatientList_registerTag".tr())));
        }
      },
      child: BlocBuilder<PatientListCubit, PatientListState>(
        // buildWhen: (previous, current) => previous.filterPatientList!=current.filterPatientList,
        builder: (context, state){
          return WillPopScope(
            onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
                context.read<PatientListCubit>().changeStatusSuccess();
              },
              child: Align(
                alignment: Alignment(0,-1/2),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (state.status==PatientListStatus.addNew) ? Container() : TextField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.blue,),
                          hintText: 'Label_case_list_per_patient_input_tag'.tr(),
                          hintStyle: TextStyle(color: Colors.blue),
                        ),
                        onChanged: (value){
                          context.read<PatientListCubit>().searchTextChanged(value: value);
                        },
                      ),
                      SizedBox(height: 10,),
                      (state.status==PatientListStatus.addNew) ? Column(
                        children: [
                          _NewPatientTagField(),
                          _OKRegisterButton(),
                        ],
                      ) : _PatientRegisterButton(),
                      // (state.status==PatientListStatus.addNew) ? _NewPatientTagField() : Container(),
                      // (state.status==PatientListStatus.addNew) ?SizedBox(height: 20,):Container(),
                      // (state.status == PatientListStatus.addNew) ? _OKRegisterButton() : _PatientRegisterButton(),
                      // (state.status==PatientListStatus.addNew) ?SizedBox(height: 20,): Container(),
                      _PatientDetailButtonList(),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}

class _NewPatientTagField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientListCubit, PatientListState>(
      builder: (context, state) => Container(
        key: const Key("patient_not_classified_button"),
        width: double.infinity,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), spreadRadius: 5,
              blurRadius: 5, offset: Offset(0,3),
            )],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            key: const Key("patient_tag_field"),
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (value) {
              context.read<PatientListCubit>().patientTagChanged(value);
              },
            decoration: InputDecoration(labelText: "Label_PatientList_inputTag".tr(), helperText: ""),
          ),
        ),
      ),
    );
  }
}

class _PatientDetailButton extends StatelessWidget {
  final String patientName;
  final String patientId;
  final int caseNumber;
  _PatientDetailButton({required this.patientName, required this.patientId, required this.caseNumber});
  
  @override
  Widget build(BuildContext context) {
    return customTile(
      context: context, imagePath: 'assets/images/patient_icon.png',
      titleText: patientName, bodyTextList: ['${"CaseNum".tr()}: $caseNumber'],
      navIndex: 7, subParameter1: patientId, subParameter2: patientName);
  }
}

class _PatientDetailButtonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientListCubit, PatientListState>(
      buildWhen: (previous, current) => previous.filterPatientList != current.filterPatientList,
      builder: (context, state){
        return (state.status == PatientListStatus.loading) ?
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,)),
        ) :
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [for (var i = 0; i < state.filterPatientList.length; i++) ...[
            SizedBox(height: 15,),
            _PatientDetailButton(
              patientName: state.filterPatientList[i].patientTag,
              patientId: state.filterPatientList[i].patientId,
              caseNumber: state.filterPatientList[i].caseNumber,
            ),
            SizedBox(height: 15,),
          ],],
        );
      },
    );
  }
}
class _PatientRegisterButton extends StatefulWidget {
  @override
  __PatientRegisterButtonState createState() => __PatientRegisterButtonState();
}

class __PatientRegisterButtonState extends State<_PatientRegisterButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientListCubit, PatientListState>(
      builder: (context, state) {
        return RoundedLoadingButton(
          controller: _btnController,
          color: Theme.of(context).colorScheme.secondary,
          key: const Key("patient_register_button"),
          onPressed: () async {
            context.read<PatientListCubit>().emit(state.copyWith(status: PatientListStatus.addNew));
            _btnController.reset();
          },
          child: Text('Label_PatientList_registerPatient'.tr()),);
      },
    );
  }
}
class _OKRegisterButton extends StatefulWidget {
  @override
  __OKRegisterButtonState createState() => __OKRegisterButtonState();
}

class __OKRegisterButtonState extends State<_OKRegisterButton> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientListCubit, PatientListState>(
      builder: (context, state) {
        return RoundedLoadingButton(
          controller: _btnController,
          color: Theme.of(context).colorScheme.secondary,
          key: const Key("ok_register_button"),
          onPressed: (state.newPatientTag=="")? null : () async {
            await context.read<PatientListCubit>().patientAdd();
          },
          child: Text('OK'),);
      },);
  }
}

// class PatientRegisterDialog extends StatelessWidget{
//   RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PatientListCubit, PatientListState>(
//         builder: (context,state) {
//           return AlertDialog(
//             content: Column(
//               children: [
//                 Container(
//                   key: const Key("patient_not_classified_button"),
//                   width: double.infinity,
//                   margin: const EdgeInsets.all(15.0),
//                   padding: const EdgeInsets.all(3.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3), spreadRadius: 5,
//                         blurRadius: 5, offset: Offset(0,3),
//                       )],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: TextField(
//                       key: const Key("patient_tag_field"),
//                       autofocus: true,
//                       textAlign: TextAlign.center,
//                       onChanged: (value) {
//                         context.read<PatientListCubit>().patientTagChanged(value);
//                       },
//                       decoration: InputDecoration(labelText: "Label_PatientList_inputTag".tr(), helperText: ""),
//                     ),
//                   ),
//                 ),
//                 RoundedLoadingButton(
//                   controller: _btnController,
//                   color: Theme.of(context).colorScheme.secondary,
//                   key: const Key("ok_register_button"),
//                   onPressed: (state.newPatientTag=="")? null : () async {
//                     await context.read<PatientListCubit>().patientAdd();
//                   },
//                   child: Text('OK'),)
//               ],
//             ),
//           );
//         }
//     );
//   }
// }
