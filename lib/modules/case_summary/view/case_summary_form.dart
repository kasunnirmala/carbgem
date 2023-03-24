import 'package:carbgem/modules/case_summary/case_summary.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaseSummaryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CaseSummaryCubit, CaseSummaryState>(
      listener: (context, state) {
        if (state.status == CaseSummaryStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        }
      },
      child: BlocBuilder<CaseSummaryCubit, CaseSummaryState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async => onBackPressed(
            context: context, pageNumber: 10, navNumber: 0, subParameter: state.patientName,
            subParameter2nd: state.patientId, subParameter3rd: state.caseName, subParameter4th: state.caseId,
            subParameter5th: state.specimenId,
          ),
          child: Align(
            alignment: Alignment(0,-1/3),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20,),
                    _TopInfoTile(),
                    SizedBox(height: 20,),
                    _FungiTileList(),
                    // _CaseDeRegisterButton(caseId: caseId, caseName: caseName, patientId: patientId, patientName: patientName,)
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopInfoTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseSummaryCubit, CaseSummaryState>(
      builder: (context, state) => TopInfoDisplay(
        topText: '${"Label_title_patientName".tr()}: ${state.patientName} \n${"Label_case_summary_case".tr()}: ${state.caseName}', bottomText1: '${"diagnoseContent".tr()}: ${state.fungiSummaryAPI.fungiJudgement}',
        bottomText2: '${"chosenMedicine".tr()}: ${state.fungiSummaryAPI.drugJudgement}'
      ),
    );
  }
}

class _FungiTileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseSummaryCubit, CaseSummaryState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: ListView(
          children: [
            (state.fungiSummaryAPI.unsorted.count==0) ? Container() : SizedBox(height: 10,),
            (state.fungiSummaryAPI.unsorted.count==0) ? Container() :
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      HexColor('#bbeaff'),
                      Colors.white
                    ],
                  ),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0,3),
                  )],
                ),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.solidQuestionCircle, size: 35,),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Container(
                      child: Text('${state.fungiSummaryAPI.unsorted.fungiName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      width: MediaQuery.of(context).size.width*0.7,
                    ),
                  ),
                  subtitle:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: LinearProgressIndicator(
                            value: (state.fungiSummaryAPI.totalImage!=0) ? (state.fungiSummaryAPI.unsorted.count/state.fungiSummaryAPI.totalImage) : 0, backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          width: MediaQuery.of(context).size.width*0.3,
                        ),
                        Text('${state.fungiSummaryAPI.unsorted.count}/${state.fungiSummaryAPI.totalImage} ${"Label_case_summary_imageNum_unit".tr()}')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ...state.fungiSummaryAPI.summaryList.map((fungi)=>Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Container(
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          HexColor('#ecad8f'),
                          Colors.white
                        ],
                      ),
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0,3),
                      )],
                    ),
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.stethoscope, size: 30,),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                        child: Container(
                          child: Text('${fungi.fungiName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          width: MediaQuery.of(context).size.width*0.7,
                        ),
                      ),
                      subtitle:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: LinearProgressIndicator(
                                value: (state.fungiSummaryAPI.totalImage!=0) ? (fungi.count/state.fungiSummaryAPI.totalImage) : 0, backgroundColor: Theme.of(context).colorScheme.secondary,
                              ),
                              width: MediaQuery.of(context).size.width*0.3,
                            ),
                            Text('${fungi.count}/${state.fungiSummaryAPI.totalImage} ${"Label_case_summary_imageNum_unit".tr()}')
                          ],
                        ),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,size: 20,),
                      onTap: (){
                        context.read<BasicHomeCubit>().pageChanged(
                          value: 16, subPageParameter: fungi.fungiName, subPageParameter2nd: state.fungiSummaryAPI.fungiJudgement,
                          subPageParameter3rd: state.patientId, subPageParameter4th: state.patientName, subPageParameter5th: state.caseId,
                          subPageParameter6th: state.caseName, subPageParameter7th: '${fungi.fungiId}', subPageParameter8th: "0", subPageParameter9th: "",
                          subPageParameter10th: state.specimenId,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            )),
          ],
        ),
      ),
    );
  }
}


