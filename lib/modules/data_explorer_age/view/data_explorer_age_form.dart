import 'dart:math';

import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/constants/app_constants.dart';
import 'package:carbgem/modules/data_explorer_age/data_explorer_age.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class DataExplorerAgeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DataExplorerAgeCubit, DataExplorerAgeState>(
      listener: (context, state) {
        if (state.status == DataExplorerAgeStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        }
      },
      child: BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(
        builder: (context, state) => (state.status == DataExplorerAgeStatus.loading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,),) :
        WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 21, navNumber: 3),
          child: Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopInfoDisplay(topText: patientAgeGroupList.firstWhere((element) => (element['code']==state.ageGroup))['value'], bottomText1: "", bottomText2: ""),
                  //filtering
                  _FilterOption(),
                  SizedBox(height: 40,),
                  (state.dataList.length<2) ? Container(
                    child: Center(child: Text('No Data Available'),),
                  ) : _PieChart(),
                  SizedBox(height: 40,),
                  (state.dataList.length<2) ? Container() :_RawNumberBarChart(),
                  SizedBox(height: 40,),
                  (state.dataList.length<2) ? Container() :_PercentageBarChart(),
                  SizedBox(height: 40,),
                  (state.dataList.length<2) ? Container() :_SusceptibilityLineChart(),
                  SizedBox(height: 60,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  final formatter = NumberFormat('###,###,000');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(builder: (context, state) {
      bool display = state.dataList.firstWhere((element) => '${element.year}'=='${state.year}', orElse: () => Antibiogram.empty) == Antibiogram.empty;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.4,
                child: display ? Container(
                  child: Center(child: Text('noData'.tr()),),
                ) : PieChart(
                  PieChartData(
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          color: Colors.redAccent,
                          value: state.dataList.firstWhere((element) => '${element.year}'==state.year).breakdownShare*100,
                          title: '${(state.dataList.firstWhere((element) => '${element.year}'==state.year).breakdownShare*100).toStringAsFixed(2)}%',
                          titleStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 18),
                          titlePositionPercentageOffset: 0.7,
                          radius: MediaQuery.of(context).size.width*0.2,
                        ),
                        PieChartSectionData(
                          color: Colors.lightBlueAccent,
                          value: (1-state.dataList.firstWhere((element) => '${element.year}'==state.year).breakdownShare)*100,
                          title: '',
                          radius: MediaQuery.of(context).size.width*0.2,
                        ),
                      ]
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text('year'.tr(), style: Theme.of(context).textTheme.caption,),),
                        Expanded(flex: 3, child: DropdownButton(
                          value: state.year,
                          items: janisYearList.map((e) => DropdownMenuItem(
                            child: Text(e, style: Theme.of(context).textTheme.caption,),
                            value: e,
                          )).toList(),
                          onChanged: (value) => context.read<DataExplorerAgeCubit>().changeSelectYear(year: '$value'),
                        ),),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width*0.4,
                  ),
                  SizedBox(height: 10,),
                  display ? Container() : Container(
                    child: Text("${"Label_dataExplorer_age_AllAgeGroup".tr()}:", style: Theme.of(context).textTheme.caption,),
                    width: MediaQuery.of(context).size.width*0.4,
                  ),
                  display ? Container() : Container(
                    child: Text("${formatter.format(state.dataList.firstWhere((element) => '${element.year}'==state.year).overallTotal)}", style: Theme.of(context).textTheme.caption,),
                    width: MediaQuery.of(context).size.width*0.4,
                  ),
                  SizedBox(height: 10,),
                  display ? Container() : Container(
                    child: Text("${"ageGroup".tr()} ${state.ageGroup}:", style: Theme.of(context).textTheme.caption,),
                    width: MediaQuery.of(context).size.width*0.4,
                  ),
                  display ? Container() : Container(
                    child: Text("${formatter.format(state.dataList.firstWhere((element) => '${element.year}'==state.year).breakdownTotal)}", style: Theme.of(context).textTheme.caption,),
                    width: MediaQuery.of(context).size.width*0.4,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _RawNumberBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(
      builder: (context, state) {
        int displayLength = state.dataList.length >8 ? 8: state.dataList.length;
        int baseUnit = state.dataList[0].breakdownTotal<1000 ? 1000 : state.dataList[0].breakdownTotal<100000 ? 10000 :
        state.dataList[0].breakdownTotal<1000000 ? 100000 : 1000000;
        List<BarChartGroupData> _barGroupData = List.generate(displayLength, (index) =>  BarChartGroupData(
          x: index,
          showingTooltipIndicators: [0],
          barRods: [BarChartRodData(
            y: state.dataList[index+(state.dataList.length-displayLength)].breakdownTotal/baseUnit,
            colors: [Colors.blueAccent, Colors.tealAccent],
          ),],
        ));
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
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
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('${"Label_dataExplorer_age_RawNumberBarChart_title_head".tr()} ${state.ageGroup} ${"Label_dataExplorer_age_RawNumberBarChart_title_back".tr()}', style: Theme.of(context).textTheme.caption,),
                Text('${"unit".tr()}: $baseUnit', style: Theme.of(context).textTheme.caption,),
                SizedBox(height: 60,),
                Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.9,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BarChart(
                    BarChartData(
                      barGroups: _barGroupData,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                          leftTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) => Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 12),
                              getTitles: (double value) {
                                return '${state.dataList[value.toInt()+(state.dataList.length-displayLength)].year}';
                              }
                          )
                      ),
                      barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            getTooltipItem: (group, groupIndex, rod, rodIndex){
                              return BarTooltipItem('${rod.y.toStringAsFixed(2)}', TextStyle(color: Colors.blueAccent,fontSize: 14, fontWeight: FontWeight.bold));
                            }
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PercentageBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(
        builder: (context,state) {
          int displayLength = state.dataList.length >8 ? 8: state.dataList.length;
          double maxY = state.dataList.reduce((value, element) {
            if (value.breakdownShare > element.breakdownShare) {
              return value;
            } else {
              return element;
            }
          }).breakdownShare*100;
          List<BarChartGroupData> _barGroupData = List.generate(displayLength, (index) =>  BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(
              y: state.dataList[index+(state.dataList.length-displayLength)].breakdownShare*100,
              colors: [Colors.redAccent],
              backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  y: (maxY*1.5 > 100) ? 100 : maxY*1.5
              ),
            )],
          ));
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
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
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text('${"Label_dataExplorer_age_PercentageBarChart_title_head".tr()} ${state.ageGroup} ${"Label_dataExplorer_age_PercentageBarChart_title_back".tr()}', style: Theme.of(context).textTheme.caption,),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BarChart(
                      BarChartData(
                        barGroups: _barGroupData,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                            leftTitles: SideTitles(showTitles: false),
                            bottomTitles: SideTitles(
                                showTitles: true,
                                getTextStyles: (context, value) => Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 12),
                                getTitles: (double value) {
                                  return '${state.dataList[value.toInt()+(state.dataList.length-displayLength)].year}';
                                }
                            )
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.y.toStringAsFixed(2)}%', TextStyle(color: Colors.redAccent,fontSize: 14, fontWeight: FontWeight.bold),
                                );
                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          );
        }
    );
  }
}

class _SusceptibilityLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(
      builder: (context, state) {
        List<LineChartBarData> _lineBarData = [
          LineChartBarData(
            isCurved: true, curveSmoothness: 0.1, colors: [Colors.redAccent,],
            spots: state.dataList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), double.parse('${(e.value.breakdownSusceptible*100).toStringAsFixed(2)}') )).toList(),
            dotData: FlDotData(show: false), barWidth: 5,
          ),
          LineChartBarData(
            isCurved: true, curveSmoothness: 0.1, colors: [Colors.blueAccent, ],
            spots: state.dataList.asMap().entries.map((e) => FlSpot(e.key.toDouble(), double.parse('${(e.value.overallSusceptible*100).toStringAsFixed(2)}'))).toList(),
            dotData: FlDotData(show: false), barWidth: 5,
          ),
        ];
        double minRateA = state.dataList.reduce((value, element) {
          if(value.breakdownSusceptible<element.breakdownSusceptible) {
            return value;
          } else {
            return element;
          }
        }).breakdownSusceptible;
        double minRateB = state.dataList.reduce((value, element) {
          if(value.overallSusceptible<element.overallSusceptible) {
            return value;
          } else {
            return element;
          }
        }).overallSusceptible;
        double maxRateA = state.dataList.reduce((value, element) {
          if(value.breakdownSusceptible>element.breakdownSusceptible) {
            return value;
          } else {
            return element;
          }
        }).breakdownSusceptible;
        double maxRateB = state.dataList.reduce((value, element) {
          if(value.overallSusceptible>element.overallSusceptible) {
            return value;
          } else {
            return element;
          }
        }).overallSusceptible;
        double minRate = minRateA<minRateB ? minRateA*100 : minRateB*100;
        double maxRate = maxRateA>maxRateB ? maxRateA*100 : maxRateB*100;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
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
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  child: Text('susceptibilityRate'.tr(), style: Theme.of(context).textTheme.caption,),
                  width: MediaQuery.of(context).size.width*0.8,
                ),
                SizedBox(height: 10,),
                Indicator(color: Colors.redAccent, text: '${state.ageGroup}', isSquare: false),
                Indicator(color: Colors.blueAccent, text: "Label_dataExplorer_age_SusceptibilityLineChart_legend_All".tr(), isSquare: false),
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.9,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LineChart(
                    LineChartData(
                      minY: minRate==100 ? 99 : max(minRate - (100-minRate)/10,0),
                      maxY: minRate==100 ? 101 : min(maxRate + (100-maxRate)/10, 101),
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
                            return '${state.dataList[value.toInt()].year}';},),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class _FilterOption extends StatelessWidget {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataExplorerAgeCubit, DataExplorerAgeState>(
      builder: (context, state) => (state.status == DataExplorerAgeStatus.loading) ? Container(): Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
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
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              leading: Icon(Icons.filter_alt_outlined),
              title: Center(child: Text('filter'.tr()),),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("area".tr(), style: Theme.of(context).textTheme.caption,)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.selectArea,
                          onChanged: (AreaAPI? value){
                            context.read<DataExplorerAgeCubit>().changeArea(selectArea: value!);
                          },
                          items: state.areaList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.areaName, style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("specimen".tr(), style: Theme.of(context).textTheme.caption,)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.specimenId,
                          onChanged: (value){
                            context.read<DataExplorerAgeCubit>().changeSpecimenType(specimenId: '$value');
                          },
                          items: specimenList.map((e) {
                            return DropdownMenuItem(
                              value: e['code'],
                              child: Text(e['value'], style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("fungi".tr(), style: Theme.of(context).textTheme.caption)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.selectFungi,
                          onChanged: (FungiType? value){
                            context.read<DataExplorerAgeCubit>().changeFungiType(selectFungi: value!);
                          },
                          items: state.fungiList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Container(child: Text(e.fungiName, style: Theme.of(context).textTheme.caption), width: MediaQuery.of(context).size.width*0.4,),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("drug".tr(), style: Theme.of(context).textTheme.caption)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.selectDrug,
                          onChanged: (DrugType? value){
                            context.read<DataExplorerAgeCubit>().changeDrugType(selectDrug: value!);
                          },
                          items: state.drugList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.drugName, style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("patientOrigin".tr(), style: Theme.of(context).textTheme.caption)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.origin,
                          onChanged: (value){
                            context.read<DataExplorerAgeCubit>().changeOrigin(origin: '$value');
                          },
                          items: patientTypeList.map((e) {
                            return DropdownMenuItem(
                              value: e['code'],
                              child: Text(e['value'], style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("sex".tr(), style: Theme.of(context).textTheme.caption)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.sex,
                          onChanged: (value){
                            context.read<DataExplorerAgeCubit>().changeSex(sex: '$value');
                          },
                          items: patientSexList.map((e) {
                            return DropdownMenuItem(
                              value: e['code'],
                              child: Text(e['value'], style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("ageGroup".tr(), style: Theme.of(context).textTheme.caption),),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.ageGroup,
                          onChanged: (value){
                            context.read<DataExplorerAgeCubit>().changeAgeGroup(ageGroup: '$value');
                          },
                          items: patientAgeGroupList.sublist(1,12).map((e) {
                            return DropdownMenuItem(
                              value: e['code'],
                              child: Text(e['value'], style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("hospitalSize".tr(), style: Theme.of(context).textTheme.caption,)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.bedSize,
                          onChanged: (value){
                            context.read<DataExplorerAgeCubit>().changeBedSize(bedSize: '$value');
                          },
                          items: bedSizeList.map((e) {
                            return DropdownMenuItem(
                              value: e['code'],
                              child: Text(e['value'], style: Theme.of(context).textTheme.caption),
                            );
                          }).toList(),
                        ),)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      color: Theme.of(context).colorScheme.secondary,
                      key: const Key("patient_register_button"),
                      onPressed: (){
                        context.read<DataExplorerAgeCubit>().getTSList();
                      },
                      child: Text('OK', style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white, fontSize: 20, letterSpacing: 2),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
