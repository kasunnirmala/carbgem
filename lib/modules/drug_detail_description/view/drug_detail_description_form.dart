import 'dart:math';
import 'package:carbgem/constants/app_constants.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/drug_detail_description/drug_detail_description.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class DrugDetailDescriptionForm extends StatefulWidget {
  @override
  _DrugDetailDescriptionFormState createState() => _DrugDetailDescriptionFormState();
}

class _DrugDetailDescriptionFormState extends State<DrugDetailDescriptionForm> {
  final ScrollController _scrollController = ScrollController();
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
      listener: (context, state) {
        if (state.status == DrugDetailDescriptionStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        } else if (state.status == DrugDetailDescriptionStatus.judgementSuccess) {
          getAlert(context: context,
            title: 'dialog_title'.tr(),
            msg: '${"chosenMedicine".tr()}: \n ${state.drugCode}',
            clickFunction: true, okButton: true, okFunction: (){},
          );
        }
      },
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
          builder: (context, state) {
            Color _drugColor = state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green :
            state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange :
            state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.redAccent : state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown : Colors.grey;
            return (state.status == DrugDetailDescriptionStatus.loading) ?
            Center(child: LoadingBouncingGrid.square(backgroundColor: Colors.blueAccent,),) :
            WillPopScope(
              onWillPop: () async => (state.inputAreaId!='') ?
              onBackPressed(context: context, pageNumber: 2, navNumber: 2) :
              onBackPressed(
                context: context, pageNumber: 16, navNumber: 0, subParameter: state.fungiName, subParameter2nd: state.finalJudgement,
                subParameter3rd: state.patientId, subParameter4th: state.patientName, subParameter5th: state.caseId,
                subParameter6th: state.caseName, subParameter7th: state.fungiId, subParameter8th: "${state.sourcePage}",
                subParameter9th: state.imageId, subParameter10th: state.specimenId,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height*1.0,
                child: Align(
                  alignment: Alignment(0,-1/3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                (context.locale==Locale("ja"))?"${state.drugTimeSeriesAnti.drugNameJP} (${state.drugTimeSeriesAnti.drugCodeJP})":state.drugTimeSeriesAnti.drugName,
                                style: Theme.of(context).textTheme.headline5!.copyWith(color: _drugColor),
                              ),
                              (context.locale==Locale("ja"))? Text(state.drugTimeSeriesAnti.categoryJP,
                                style: Theme.of(context).textTheme.headline5!.copyWith(color: _drugColor.withOpacity(0.85)),) : Container(),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          // height: (state.inputAreaId!="") | (state.sourcePage==1) ? MediaQuery.of(context).size.height*0.65 : MediaQuery.of(context).size.height*0.58,
                          child: Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController,
                            thickness: 4.0,
                            child: ListView(
                              controller: _scrollController,
                              children: [
                                SizedBox(height: 10,),
                                _DrugView(),
                                SizedBox(height: 10,),
                                (context.locale == Locale("ja")) ? _ProductView() : Container(),
                                SizedBox(height: 10,),
                                (state.drugTimeSeriesAnti.hospitalTimeList.length>0) ? _HospitalAntibiogramTimeSeries():_AntibiogramNoData(),
                                SizedBox(height: 10,),
                                _FilterOption(),
                                SizedBox(height: 40,),
                                _AntibiogramTimeSeries()
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      (state.inputAreaId!="") | (state.sourcePage==1) ? Container() : RoundedLoadingButton(
                        controller: _btnController,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () async {
                          await context.read<DrugDetailDescriptionCubit>().selectDrug();
                          _btnController.success();
                          },
                        child: Text("Label_drugDetailDescription_choose".tr()),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}

class _AntibiogramTimeSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
        builder: (context, state){
          Color _drugColor = state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green :
          state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange :
          state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.redAccent : state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown : Colors.grey;
          List<FlSpot> spotData = [];
          List<int> showSpot = [];
          List<double> originalData = [];
          List<String> resultYear = [];
          int listLength = state.drugTimeSeriesAnti.timeList.length;
          state.drugTimeSeriesAnti.timeList.sublist(max(0, listLength-7), listLength).forEach((element) {
            originalData.add(element.susceptibilityRate);
            resultYear.add('${element.year}');
          });
          originalData.asMap().forEach((key, value) {
            spotData.add(FlSpot(key.toDouble(), value));
            showSpot.add(key);
          });
          double minRate = originalData.reduce(min);
          double maxRate = originalData.reduce(max);
          List<LineChartBarData> lineBarData = [
            LineChartBarData(
              spots: spotData, isCurved: true, curveSmoothness: 0.1, colors: [Colors.white],
              belowBarData: BarAreaData(show: true, colors: [_drugColor, _drugColor.withAlpha(40), _drugColor])
            )
          ];
          List<LineTooltipItem> _touchedCustom(touchedSpots) {
            List<LineTooltipItem> outList;
            outList = touchedSpots.map<LineTooltipItem>((LineBarSpot touchedSpot) {
              final textStyle = Theme.of(context).textTheme.overline!;
              return LineTooltipItem("${originalData[touchedSpot.spotIndex].toStringAsFixed(2)}%", textStyle);
            }).toList();
            return outList;
          }
          LineChartData lineChartData = LineChartData(
            lineBarsData: lineBarData,
            showingTooltipIndicators: showSpot.map((e){
              return ShowingTooltipIndicators([LineBarSpot(lineBarData[0], 0, lineBarData[0].spots[e])]);
            }).toList(),
            lineTouchData: LineTouchData(
              enabled: false,
              touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.transparent, getTooltipItems: _touchedCustom),
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 15,
                  // margin: 10,
                  getTextStyles: (value, check) => Theme.of(context).textTheme.subtitle2,
                  getTitles: (value){
                    return resultYear[value.toInt()];
                  }
              ),
              leftTitles: SideTitles(
                showTitles: false,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                  bottom: BorderSide(color: Colors.blueAccent, width: 0.8),
                  left: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent)
              ),
            ),
            minY: minRate==100 ? 99 : max(minRate - (100-minRate)/10,0),
            maxY: minRate==100 ? 101 : min(maxRate + (100-maxRate)/10, 101),
          );
          return (state.status == DrugDetailDescriptionStatus.filterLoading) ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: LoadingBouncingGrid.square(backgroundColor: _drugColor,),
          ) : Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: LineChart(lineChartData, swapAnimationDuration: Duration(microseconds: 50),),
            ),
          );
        },
      ),
    );
  }
}

class _AntibiogramNoData extends StatelessWidget {
  const _AntibiogramNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
        builder: (context, state){
          Color _drugColor = state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green :
          state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange :
          state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.redAccent : state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown : Colors.grey;
          return (state.status == DrugDetailDescriptionStatus.filterLoading) ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: LoadingBouncingGrid.square(backgroundColor: _drugColor,),
          ) : Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.2,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [_drugColor, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("${state.currentUser.hospitalName} ${"antibiogram".tr()}", style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("noData".tr(), style: Theme.of(context).textTheme.bodyText2,),
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


class _HospitalAntibiogramTimeSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// change to percentage bar chart
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
        builder: (context, state){
          Color _drugColor = state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green :
          state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange :
          state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.redAccent : state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown : Colors.grey;
          List<FlSpot> spotData = [];
          List<int> showSpot = [];
          List<double> originalData = [];
          List<String> resultYear = [];
          int listLength = state.drugTimeSeriesAnti.hospitalTimeList.length;
          state.drugTimeSeriesAnti.hospitalTimeList.sublist(max(0, listLength-4), listLength).forEach((element) {
            originalData.add(element.susceptibilityRate);
            resultYear.add('${element.year}');
          });
          originalData.asMap().forEach((key, value) {
            spotData.add(FlSpot(key.toDouble(), value));
            showSpot.add(key);
          });
          double minRate = originalData.reduce(min);
          double maxRate = originalData.reduce(max);
          List<LineChartBarData> lineBarData = [
            LineChartBarData(
              spots: spotData, isCurved: true, curveSmoothness: 0.5, colors: [Colors.white],
              belowBarData: BarAreaData(show: true, colors: [Colors.white]),
            )
          ];
          List<LineTooltipItem> _touchedCustom(touchedSpots) {
            List<LineTooltipItem> outList;
            outList = touchedSpots.map<LineTooltipItem>((LineBarSpot touchedSpot) {
              final textStyle = Theme.of(context).textTheme.caption!;
              return LineTooltipItem("${originalData[touchedSpot.spotIndex].toStringAsFixed(2)}%", textStyle);
            }).toList();
            return outList;
          }
          LineChartData lineChartData = LineChartData(
            lineBarsData: lineBarData,
            showingTooltipIndicators: showSpot.map((e){
              return ShowingTooltipIndicators([LineBarSpot(lineBarData[0], 0, lineBarData[0].spots[e])]);
            }).toList(),
            lineTouchData: LineTouchData(
              enabled: false,
              touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.transparent, getTooltipItems: _touchedCustom),
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 15,
                  // margin: 10,
                  getTextStyles: (value, check) => Theme.of(context).textTheme.bodyText2,
                  getTitles: (value){
                    return resultYear[value.toInt()];
                  }
              ),
              leftTitles: SideTitles(
                showTitles: false,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                  bottom: BorderSide(color: Colors.blueAccent, width: 0.8),
                  left: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent)
              ),
            ),
            minY: minRate==100 ? 99 : max(minRate - (100-minRate)/10,0),
            maxY: minRate==100 ? 101 : min(maxRate + (100-maxRate)/10, 101),
          );
          return (state.status == DrugDetailDescriptionStatus.filterLoading) ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: LoadingBouncingGrid.square(backgroundColor: _drugColor,),
          ) : Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.4,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [_drugColor, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("${state.currentUser.hospitalName} ${"antibiogram".tr()}", style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 60,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LineChart(lineChartData, swapAnimationDuration: Duration(microseconds: 50),),
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

class _FilterOption extends StatelessWidget {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green.shade700 :
                  state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange.shade700 :
                  state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.red.shade700 :
                  state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown.shade700 : Colors.grey.shade700,
                  Colors.white
                ],
              ),
            ),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(FontAwesomeIcons.filter, color: Colors.black,),
                title: Column(
                  children: [
                    Text('${(state.inputAreaId!="") ? state.inputAreaName : state.currentUser.areaName} ${"antibiogram".tr()}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Center(child: Text('filter'.tr(), style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),)),
                  ],
                ),
                // title: Center(child: Text('filter'.tr(), style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),)),
                initiallyExpanded: true,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      child: Row(
                        children: [
                          Expanded(flex: 2,child: Text("patientOrigin".tr())),
                          Expanded(flex: 3,child: DropdownButton(
                            value: state.origin,
                            onChanged: (value){
                              context.read<DrugDetailDescriptionCubit>().changeOrigin(value: '$value');
                            },
                            items: patientTypeList.map((e) {
                              return DropdownMenuItem(
                                value: e['code'],
                                child: Text(e['value']),
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
                          Expanded(flex: 2,child: Text("sex".tr())),
                          Expanded(flex: 3,child: DropdownButton(
                            value: state.sex,
                            onChanged: (value){
                              context.read<DrugDetailDescriptionCubit>().changeSex(value: '$value');
                            },
                            items: patientSexList.map((e) {
                              return DropdownMenuItem(
                                value: e['code'],
                                child: Text(e['value']),
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
                          Expanded(flex: 2,child: Text("ageGroup".tr())),
                          Expanded(flex: 3,child: DropdownButton(
                            value: state.ageGroup,
                            onChanged: (value){
                              context.read<DrugDetailDescriptionCubit>().changeAgeGroup(value: '$value');
                            },
                            items: patientAgeGroupList.map((e) {
                              return DropdownMenuItem(
                                value: e['code'],
                                child: Text(e['value']),
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
                          Expanded(flex: 2,child: Text("hospitalSize".tr(),)),
                          Expanded(flex: 3,child: DropdownButton(
                            value: state.bedSize,
                            onChanged: (value){
                              context.read<DrugDetailDescriptionCubit>().changeBedSize(value: '$value');
                            },
                            items: bedSizeList.map((e) {
                              return DropdownMenuItem(
                                value: e['code'],
                                child: Text(e['value']),
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
                          context.read<DrugDetailDescriptionCubit>().drugInfoGet(update: true);
                        },
                        child: Text('OK', style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white, fontSize: 20, letterSpacing: 2),),
                      ),
                    ),
                  ),

                  /// RoundedLoadingButton instead of TextButton,
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: RoundedLoadingButton(
                  //     controller: _btnController,
                  //     color: Theme.of(context).colorScheme.secondary,
                  //     onPressed: () {
                  //       context.read<DrugDetailDescriptionCubit>().drugInfoGet(update: true);
                  //     },
                  //     height: 30,
                  //     width: 200,
                  //     child: Text('OK',style: TextStyle(color: Colors.white),),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
        builder: (context, state) => Container(
          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green.shade500 :
                  state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange.shade500 :
                  state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.red.shade500 :
                  state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown.shade500 : Colors.grey.shade500,
                  Colors.white
                ],
              ),
            ),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(20),
                leading: Icon(FontAwesomeIcons.pills, size: 35,color: Colors.black,),
                title: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("市販薬:", style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${state.drugTimeSeriesAnti.productJP} \u{00AE}${"Label_detailDescription_drugName_etc".tr()}', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                initiallyExpanded: true,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Icon(FontAwesomeIcons.squareFull, size: 15,),),
                      Expanded(flex: 5, child: Text("先発品:", style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold)),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  ...state.drugTimeSeriesAnti.brandDetailJP.map((e){
                    return Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Icon(FontAwesomeIcons.circle, size: 10,),),
                          Expanded(flex: 5, child: Text((e=="No data") ? "Label_drugDetailDescription_noSpectrum".tr() : e, style: Theme.of(context).textTheme.subtitle1),),
                        ],
                      ),
                    );
                  }).toList(),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Icon(FontAwesomeIcons.squareFull, size: 15,),),
                      Expanded(flex: 5, child: Text("後発品(一部）:", style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold)),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  ...state.drugTimeSeriesAnti.genericDetailJP.map((e){
                    return Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Icon(FontAwesomeIcons.circle, size: 10,),),
                          Expanded(flex: 5, child: Text((e=="No data") ? "Label_drugDetailDescription_noSpectrum".tr() : e, style: Theme.of(context).textTheme.subtitle1),),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrugView extends StatelessWidget {
  const _DrugView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: BlocBuilder<DrugDetailDescriptionCubit, DrugDetailDescriptionState>(
        builder: (context, state) => Container(
          child: Container(
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  state.drugTimeSeriesAnti.whoAware=="Access" ? Colors.green.shade300 :
                  state.drugTimeSeriesAnti.whoAware=="Watch" ? Colors.orange.shade300 :
                  state.drugTimeSeriesAnti.whoAware=="Reserve" ? Colors.red.shade300 :
                  state.drugTimeSeriesAnti.whoAware=="Not_Reccommended" ? Colors.brown.shade300 : Colors.grey.shade300,
                  Colors.white
                ],
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(20),
                leading: Icon(FontAwesomeIcons.bars, size: 35,color: Colors.black,),
                title: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(child: Text('details'.tr(), style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),)),
                ),
                initiallyExpanded: true,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 50, bottom: 5),
                    child: Align(
                      child: Text('${"whoAware".tr()}:', style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 80, bottom: 10),
                    child: Align(
                      child: Text("${state.drugTimeSeriesAnti.whoAware}".tr(), style: Theme.of(context).textTheme.bodyText2),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 50, bottom: 5),
                    child: Align(
                      child: Text('${"Label_drugDetailDescription_spectrumScore".tr()}:', style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 80, bottom: 10),
                    child: Align(
                      child: Text((state.drugTimeSeriesAnti.spectrumScore==999) ? "Label_drugDetailDescription_noSpectrum".tr() : "${state.drugTimeSeriesAnti.spectrumScore}", style: Theme.of(context).textTheme.bodyText2),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 50, bottom: 5),
                    child: Align(
                      child: Text('処方上の注意点:', style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 80, bottom: 20, right: 30),
                    child: Align(
                      child: Text(state.drugTimeSeriesAnti.drugNotification == "" ? "Label_drugDetailDescription_noNotification".tr() : state.drugTimeSeriesAnti.drugNotification, style: Theme.of(context).textTheme.bodyText2),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
