import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/all.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class PatientAttachingImageListForm extends StatefulWidget {
  const PatientAttachingImageListForm({Key? key}) : super(key: key);

  @override
  State<PatientAttachingImageListForm> createState() => PatientAttachingImageListFormState();
}

class PatientAttachingImageListFormState extends State<PatientAttachingImageListForm> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientAttachingImageListCubit, PatientAttachingImageListState>(
      listener: (context, state) {
        if (state.status == PatientListStatusInPatientAttaching.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        } else if (state.status == PatientListStatusInPatientAttaching.addNew) {
          getAlert(context: context,
            title: 'dialog_title'.tr(),
            msg: 'successPatientLink'.tr(),
            clickFunction: true, okButton: true, okFunction: (){},
          );
        }
      },
      child: BlocBuilder<PatientAttachingImageListCubit, PatientAttachingImageListState>(
        buildWhen:  (previous, current) => previous.imageList != current.imageList,
        builder: (context, state) {
          return (state.status == PatientListStatusInPatientAttaching.loading) 
          ? Center(child: CircularProgressIndicator(),) 
          : WillPopScope(
            onWillPop: () async => onBackPressed(context: context, pageNumber: 5, navNumber: 0),
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: Align(
                    alignment: Alignment(0,-1/3),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PatientCaseSelect(),
                          SizedBox(height: 20,),
                          _ImageListView(),
                        ],
                      ),
                    ),
                  ),
            ),
          );
        }
      )
    );
  }
}

class _ImageListView extends StatefulWidget {
  @override
  __ImageListViewState createState() => __ImageListViewState();
}

class __ImageListViewState extends State<_ImageListView> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  List _selectedList = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAttachingImageListCubit, PatientAttachingImageListState>(
      builder: (context, state) => Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.35,
            child:GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: List.generate(state.imageList.length, (index) {
                return InkWell(
                  onTap: (){
                    if (_selectedList.contains(int.parse(state.imageList[index].imageId))) {
                      setState(() {
                        _selectedList.remove(int.parse(state.imageList[index].imageId));
                      });
                    } else {
                      setState(() {
                        _selectedList.add(int.parse(state.imageList[index].imageId));
                      });
                    }
                    context.read<PatientAttachingImageListCubit>().changeSelection(selectedImageId: _selectedList);
                    },
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              child: Image.network(
                                state.imageList[index].imageThumbnail!="" ? state.imageList[index].imageThumbnail : state.imageList[index].imagePath,
                                fit: BoxFit.fitWidth, colorBlendMode: BlendMode.modulate,
                                color: _selectedList.contains(int.parse(state.imageList[index].imageId)) ? Color.fromRGBO(255, 255, 255, 0.5) : Color.fromRGBO(255, 255, 255, 1.0),
                              ),
                              height: MediaQuery.of(context).size.width*0.3,
                            ),
                            Container(
                              child: Center(child: Text('${state.imageList[index].modelPrediction}', style: Theme.of(context).textTheme.caption,)),
                              width: MediaQuery.of(context).size.width*0.4,
                            ),
                          ]
                        ),
                        Icon(Icons.check_circle, color: _selectedList.contains(int.parse(state.imageList[index].imageId)) ? Colors.blueAccent : Colors.transparent,),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20,),
          RoundedLoadingButton(
            controller: _btnController,
            color: Theme.of(context).colorScheme.secondary,
            key: const Key("loginForm_createAccount_button"),
            onPressed: (state.selectedPatientId=="" || state.selectedImage.length==0 || state.selectedCaseId == '' || state.imageList.length==0) ?
            null : () async {
              await context.read<PatientAttachingImageListCubit>().attachingPatientNameForImageIds();
              _btnController.reset();
            },
            child: Text('Label_patientAttachingImageList_decidePatient'.tr()),
          ),
          SizedBox(height: 20,),
        ]
      ),
    );
  }
}

class _PatientCaseSelect extends StatefulWidget {
  @override
  __PatientCaseSelectState createState() => __PatientCaseSelectState();
}

class __PatientCaseSelectState extends State<_PatientCaseSelect> {
  final TextEditingController _patientController = TextEditingController();
  final TextEditingController _caseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAttachingImageListCubit, PatientAttachingImageListState>(
      builder: (context,state) => Container(
        height: MediaQuery.of(context).size.height*0.18,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: _patientController,
                  decoration: InputDecoration(
                    labelText: 'Label_patientAttachingImageList_selectPatient'.tr(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor))
                  )
              ),
              onSuggestionSelected: (suggestion) {
                suggestion = suggestion as Patient;
                _patientController.text = suggestion.patientTag;
                context.read<PatientAttachingImageListCubit>().changePatientSelection(selectedPatient: suggestion.patientId);
              },
              itemBuilder: (context, suggestion) {
                suggestion = suggestion as Patient;
                return ListTile(
                  title: Text("${suggestion.patientTag}"),
                );
              },
              suggestionsCallback: (pattern){
                return state.patientList.where((element) => element.patientTag.toLowerCase().contains(pattern.toLowerCase()));
              },
            ),
            SizedBox(height: 10,),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: _caseController,
                  decoration: InputDecoration(
                    labelText: 'Label_patientAttachingImageList_selectCase'.tr(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                  )
              ),
              onSuggestionSelected: (suggestion) {
                suggestion = suggestion as Case;
                _caseController.text = suggestion.caseTag;
                context.read<PatientAttachingImageListCubit>().changeCaseSelection(selectedCase: suggestion.caseId);
              },
              itemBuilder: (context, suggestion) {
                suggestion = suggestion as Case;
                return Container(
                  child: ListTile(
                    title: (suggestion.specimenId=="1") ? Text("${suggestion.caseTag} - Urine") :
                    (suggestion.specimenId=="2") ? Text("${suggestion.caseTag} - Blood") :
                    (suggestion.specimenId=="3") ? Text("${suggestion.caseTag} - Sputum") : Text("${suggestion.caseTag} - Spinal"),
                  ),
                );
              },
              suggestionsCallback: (pattern){
                return state.caseList.where((element) => element.caseTag.toLowerCase().contains(pattern.toLowerCase()));
              },
            ),
          ],
        ),
      ),
    );
  }
}