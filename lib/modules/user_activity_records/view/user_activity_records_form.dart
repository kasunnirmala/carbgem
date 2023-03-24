import 'dart:math';

import 'package:carbgem/modules/user_activity_records/cubit/user_activity_records_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';

class UserActivityRecordForm extends StatelessWidget {
  const UserActivityRecordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserActivityRecordsCubit, UserActivityRecordsState>(
      listener: (context, state) {
        if (state.status == UserActivityRecordsStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<UserActivityRecordsCubit, UserActivityRecordsState>(
        builder: (context, state) => (state.status==UserActivityRecordsStatus.loading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent,),) :
        WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
          child: Align(
            alignment: Alignment(0,-1/3),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height*0.8,
                child: ListView(
                  children: [
                    SizedBox(height: 30,),
                    _SummaryTile(),
                    SizedBox(height: 20,),
                    _GraphTile(),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityRecordsCubit, UserActivityRecordsState>(
      builder: (context,state) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0,3)
            )]
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Align(alignment: Alignment.centerLeft,
                child: Container(
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.periscope),
                      SizedBox(width: 30,),
                      Text("${"userActivityRecords_summary_title".tr()}", style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: Icon(FontAwesomeIcons.neuter),),
                        Expanded(flex: 6, child: Text("${"userActivityRecords_summary_topInfo_Heading".tr()}: ", style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold),),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_fungiInference".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.inferenceRecord.totalUse}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_drugAssignment".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.drugRecord.totalUse}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: Icon(FontAwesomeIcons.neuter),),
                        Expanded(flex: 6, child: Text("${"userActivityRecords_summary_middleInfo_Heading".tr()}: ", style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold),),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_fungiInference".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.inferenceRecord.totalLast12}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_drugAssignment".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.drugRecord.totalLast12}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: Icon(FontAwesomeIcons.neuter),),
                        Expanded(flex: 6, child: Text("${"userActivityRecords_summary_bottomInfo_Heading".tr()}: ", style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold),),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_fungiInference".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.inferenceRecord.countList[0]}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(),),
                        Expanded(flex: 4, child: Text("${"userActivityRecords_drugAssignment".tr()}: ", style: Theme.of(context).textTheme.bodyText2)),
                        Expanded(flex: 2, child: Text("${state.activityRecord.drugRecord.countList[0]}", style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphTile extends StatelessWidget {
  const _GraphTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityRecordsCubit, UserActivityRecordsState>(
      builder: (context,state) {
        List<LineChartBarData> _lineBarData = [
          LineChartBarData(
            isCurved: true, curveSmoothness: 0.1, colors: [Colors.redAccent,],
            spots: List.from(state.activityRecord.inferenceRecord.countList.sublist(0,6).reversed).asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble(),)).toList(),
            dotData: FlDotData(show: false), barWidth: 2,
          ),
          LineChartBarData(
            isCurved: true, curveSmoothness: 0.1, colors: [Colors.blueAccent, ],
            spots: List.from(state.activityRecord.drugRecord.countList.sublist(0,6).reversed).asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble(),)).toList(),
            dotData: FlDotData(show: false), barWidth: 2,
          ),
        ];
        double maxRateA = state.activityRecord.inferenceRecord.countList.reduce((value, element) {
          if(value>element) {
            return value;
          } else {
            return element;
          }
        }).toDouble();
        double maxRateB = state.activityRecord.drugRecord.countList.reduce((value, element) {
          if(value>element) {
            return value;
          } else {
            return element;
          }
        }).toDouble();
        print(_lineBarData);
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0,3)
              )]
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text('${"userActivityRecords_graph_title".tr()}', style: Theme.of(context).textTheme.caption,),
              SizedBox(height: 10,),
              Indicator(color: Colors.redAccent, text: '${"userActivityRecords_fungiInference".tr()}', isSquare: false),
              Indicator(color: Colors.blueAccent, text: "${"userActivityRecords_fungiInference".tr()}", isSquare: false),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width*0.9,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: max(maxRateA, maxRateB),
                    gridData: FlGridData(show: false),
                    lineBarsData: _lineBarData,
                    borderData: FlBorderData(show: true, border: Border(
                      bottom: BorderSide(width: 1), top: BorderSide(color: Colors.transparent),
                      left: BorderSide(color: Colors.transparent), right: BorderSide(color: Colors.transparent),
                    )),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 12),
                        getTitles: (double value) {
                          return '${List.from(state.activityRecord.drugRecord.timeList.sublist(0,6).reversed)[value.toInt()]}';},),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
