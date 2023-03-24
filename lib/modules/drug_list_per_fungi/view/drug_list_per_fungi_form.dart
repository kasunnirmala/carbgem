import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/drug_list_per_fungi/drug_list_per_fungi.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class DrugListPerFungiForm extends StatefulWidget {
  @override
  _DrugListPerFungiFormState createState() => _DrugListPerFungiFormState();
}
class _DrugListPerFungiFormState extends State<DrugListPerFungiForm> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<DrugListPerFungiCubit, DrugListPerFungiState>(
      listener: (context, state) {
        if (state.status == DrugListPerFungiStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        } else if(state.status == DrugListPerFungiStatus.drugJudgement){
          getAlert(context: context,
            title: 'dialog_title'.tr(),
            msg: '${"diagnoseContent".tr()}: \n ${state.fungiName}',
            clickFunction: true, okButton: true, okFunction: (){},
          );
        }
      },
      child: BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
        builder:(context, state) => WillPopScope(
          onWillPop: () async => (state.sourcePage==0) ?
          onBackPressed(
            context: context, pageNumber: 18, navNumber: 0, subParameter: state.patientName, subParameter2nd: state.patientId,
            subParameter3rd: state.caseName, subParameter4th: state.caseId, subParameter5th: state.specimenId,
          ) :
          onBackPressed(
            context: context, pageNumber: 13, navNumber: 0, subParameter: state.imageId, subParameter2nd: state.finalJudgement,
            subParameter3rd: state.patientId, subParameter4th: state.patientName, subParameter5th: state.caseId,
            subParameter6th: state.caseName, subParameter7th: state.specimenId,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height*1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: width*0.06, top: height*0.01),
                    // color: Colors.red,

                    child: Text("${"Label_drugListPerFungi_fungiTitle".tr()}:", style:Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                SizedBox(height: height*0.005),
                Text(state.fungiName, style: Theme.of(context).textTheme.headline6,),
                SizedBox(height: height*0.005,),
                (state.tabIndex==1) ?
                Text('${state.currentUser.areaName} ${"antibiogram".tr()}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),):
                Text('${state.currentUser.hospitalName} ${"antibiogram".tr()}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),),
                SizedBox(height: height*0.02,),
                (state.sourcePage==0) ? RoundedLoadingButton(
                  controller: _btnController,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    await context.read<DrugListPerFungiCubit>().selectFungi();
                    _btnController.success();
                  },
                  child: Text('Label_drugListPerFungi_chooseFungi'.tr()),
                ) : Container(),
                SizedBox(height: height*0.03,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: width*0.06, top: height*0.01),
                    // color: Colors.red,
                    child: Text("Label_listPerFungi_lowestSusceptibility".tr(), style:Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                _InteractiveSusceptibilitySlider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: width*0.06),
                    // color: Colors.red,
                    child: Text("${"Label_drugListPerFungi_OrderTitle".tr()}:", style:Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                AscendingSpectrumAndWho(),
                SizedBox(height: height*0.005,),
                Flexible(child: _DrugDetailButtonList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractiveSusceptibilitySlider extends StatefulWidget {
  const _InteractiveSusceptibilitySlider({Key? key}) : super(key: key);

  @override
  State<_InteractiveSusceptibilitySlider> createState() => _InteractiveSusceptibilitySliderState();
}
class _InteractiveSusceptibilitySliderState extends State<_InteractiveSusceptibilitySlider> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
      builder: (context, state) => Row(
        children: [
          Expanded(
            flex: 4,
            child: Slider(
              activeColor: Theme.of(context).colorScheme.secondary,
              key: const Key("susceptibility_slider"),
              value: state.threshold,
              min: 0,
              max: 100,
              divisions: 100,
              label: state.threshold.round().toString(),
              onChanged: (double value) {
                context.read<DrugListPerFungiCubit>().changeThreshold(value: value);
              },
            ),
          ),

          /// Susceptibility ascending button
          // Expanded(
          //   flex: 1,
          //   child: IconButton(
          //     icon: Icon(
          //       state.descendingSusceptibility? FontAwesomeIcons.sortAmountUp : FontAwesomeIcons.sortAmountDown,
          //       color: Colors.blueAccent,
          //     ),
          //     onPressed: (){
          //       context.read<DrugListPerFungiCubit>().changeSortDirectionSusceptibility(sortDirection: !state.descendingSusceptibility);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AscendingSpectrumAndWho extends StatefulWidget {
  const AscendingSpectrumAndWho({Key? key}) : super(key: key);

  @override
  _AscendingSpectrumAndWhoState createState() => _AscendingSpectrumAndWhoState();
}
class _AscendingSpectrumAndWhoState extends State<AscendingSpectrumAndWho> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width:  MediaQuery.of(context).size.width*0.5,
                    child: Text("Label_drugDetailDescription_spectrumScore".tr(), style: Theme.of(context).textTheme.caption,)),
                Container(
                    width:  MediaQuery.of(context).size.width*0.2,
                    child: Text(state.descendingSpectrum? "Label_drugListPerFungi_descending".tr():"Label_drugListPerFungi_ascending".tr(), style: Theme.of(context).textTheme.caption,)),
                Container(
                  child: IconButton(
                    icon: Icon(
                      state.descendingSpectrum? FontAwesomeIcons.sortAmountDown : FontAwesomeIcons.sortAmountUpAlt,
                      color: Colors.blueAccent,
                    ),
                    onPressed: (){
                      context.read<DrugListPerFungiCubit>().changeSortDirectionSpectrum(sortDirection: !state.descendingSpectrum);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width:  MediaQuery.of(context).size.width*0.5,
                    child: Text("whoAware".tr(), style: Theme.of(context).textTheme.caption,)),
                Container(
                    width:  MediaQuery.of(context).size.width*0.2,
                    child: Text(state.descendingWhoAware? "Label_drugListPerFungi_recommend".tr():"Label_drugListPerFungi_notRecommend".tr(), style: Theme.of(context).textTheme.caption,)),
                Container(
                  // height: MediaQuery.of(context).size.height*0.1,
                  child: IconButton(
                    icon: Icon(
                      state.descendingWhoAware? FontAwesomeIcons.sortAmountDown : FontAwesomeIcons.sortAmountUpAlt,
                      color: Colors.blueAccent,
                    ),
                    onPressed: (){
                      context.read<DrugListPerFungiCubit>().changeSortDirectionWhoAware(sortDirection: !state.descendingWhoAware);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DrugDetailList extends StatelessWidget {
  final int indexValue;

  const _DrugDetailList({Key? key, required this.indexValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: MediaQuery.of(context).size.height*0.01),
        child: Container(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                (state.displayDrugList[indexValue].whoAware == "Access") ? HexColor('#77DD77') :
                (state.displayDrugList[indexValue].whoAware == "Watch") ? HexColor('#ff971a') :
                (state.displayDrugList[indexValue].whoAware == "Reserve") ? HexColor('#ff6961'):
                (state.displayDrugList[indexValue].whoAware == "Not_Recommended") ? HexColor('#836953'): HexColor('#b7bcb6'),
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
            leading: Icon(FontAwesomeIcons.pills, size: 35,),
            title: Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: Container(
                child: Text('${state.displayDrugList[indexValue].drugNameJp!=null ? state.displayDrugList[indexValue].drugNameJp : state.displayDrugList[indexValue].drugName} (${state.displayDrugList[indexValue].drugCodeJp!=null ?state.displayDrugList[indexValue].drugCodeJp: state.displayDrugList[indexValue].drugCode})', style: Theme.of(context).textTheme.caption,),
                width: MediaQuery.of(context).size.width*0.7,
              ),
            ),
            subtitle:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 3, child: Text("${"susceptibilityRate".tr()}: ", style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10),),),
                      Expanded(
                        flex: 2,
                        child: Text('${state.displayDrugList[indexValue].susceptibilityRate.toStringAsFixed(2)}%', style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Text("${"Label_drugDetailDescription_spectrumScore".tr()}: ", style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10),),),
                      Expanded(
                        flex: 1,
                        child: Text("${state.displayDrugList[indexValue].spectrumScore<999 ? state.displayDrugList[indexValue].spectrumScore : 'Unavailable'}",
                            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 3, child: Text("${"whoAware".tr()}: ", style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10),),),
                      Expanded(
                        flex: 2,
                        child: Text("${state.displayDrugList[indexValue].whoAware}".tr(), style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_right,size: 20,),
            onTap: (){
              ///TODO: need to adjust specimenId for unclassified images to reflect the right speciment selected
              context.read<BasicHomeCubit>().pageChanged(
                value: 17, subPageParameter: state.imageId, subPageParameter2nd: state.finalJudgement,
                subPageParameter3rd: state.patientId, subPageParameter4th: state.patientName,
                subPageParameter5th: state.caseId, subPageParameter6th: state.caseName,
                subPageParameter7th: state.fungiId, subPageParameter8th: state.fungiName,
                subPageParameter9th: state.displayDrugList[indexValue].drugCode,
                subPageParameter10th: "", subPageParameter11th: state.specimenId==""? "1": state.specimenId,
                subPageParameter12th: "", subPageParameter13th: "${state.sourcePage}",
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DrugDetailButtonList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
      builder: (context, state){
        return (state.status==DrugListPerFungiStatus.loading) ? Center(child: CircularProgressIndicator(),) :
        (state.drugList.length==0) ? Center(child: Text('noData'.tr()),):
        Container(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            thickness: 4.0,
            child: ListView(
              controller: _scrollController,
              children: [
                for (var i = 0; i < state.displayDrugList.length; i++) ...[
                  _DrugDetailList(indexValue: i,),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _InteractiveSliderSpectrum extends StatefulWidget {
//   const _InteractiveSliderSpectrum({Key? key}) : super(key: key);
//
//   @override
//   _InteractiveSliderSpectrumState createState() => _InteractiveSliderSpectrumState();
// }
// class _InteractiveSliderSpectrumState extends State<_InteractiveSliderSpectrum> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
//       builder: (context, state) => Row(
//         children: [
//           // Expanded(
//           //   flex: 4,
//           //   child: Slider(
//           //     activeColor: Theme.of(context).colorScheme.secondary,
//           //     key: const Key("spectrum_slider"),
//           //     value: state.thresholdSpectrum,
//           //     min: 0,
//           //     max: 50,
//           //     divisions: 400,
//           //     label: state.thresholdSpectrum.toStringAsFixed(2),
//           //     onChanged: (double value){
//           //       context.read<DrugListPerFungiCubit>().changeThresholdSpectrum(value: value);
//           //     },
//           //   ),
//           // ),
//           Expanded(
//             flex: 1,
//             child: IconButton(
//               icon: Icon(
//                 state.descendingSpectrum? FontAwesomeIcons.sortAmountUp : FontAwesomeIcons.sortAmountDown,
//                 color: Colors.blueAccent,
//               ),
//               onPressed: (){
//                 context.read<DrugListPerFungiCubit>().changeSortDirectionSpectrum(sortDirection: !state.descendingSpectrum);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WhoAwarePerFungiForm extends StatefulWidget {
//   const WhoAwarePerFungiForm({Key? key}) : super(key: key);
//
//   @override
//   _WhoAwarePerFungiFormState createState() => _WhoAwarePerFungiFormState();
// }
// class _WhoAwarePerFungiFormState extends State<WhoAwarePerFungiForm> {
//   RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DrugListPerFungiCubit, DrugListPerFungiState>(
//       listener: (context, state) {
//         if (state.status == DrugListPerFungiStatus.error) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
//         } else if(state.status == DrugListPerFungiStatus.drugJudgement){
//           getAlert(context: context,
//             title: '結果通知',
//             msg: '診断内容: \n ${state.fungiName}',
//             clickFunction: true, okButton: true, okFunction: (){},
//           );
//         }
//       },
//       child: BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
//         builder: (context, state) => WillPopScope(
//           onWillPop: () async => (state.sourcePage==0) ?
//           onBackPressed(
//             context: context, pageNumber: 18, navNumber: 0, subParameter: state.patientName, subParameter2nd: state.patientId,
//             subParameter3rd: state.caseName, subParameter4th: state.caseId, subParameter5th: state.specimenId,
//           ) :
//           onBackPressed(
//             context: context, pageNumber: 13, navNumber: 0, subParameter: state.imageId, subParameter2nd: state.finalJudgement,
//             subParameter3rd: state.patientId, subParameter4th: state.patientName, subParameter5th: state.caseId,
//             subParameter6th: state.caseName, subParameter7th: state.specimenId,
//           ),
//           child: Container(
//             height: MediaQuery.of(context).size.height*1.0,
//             child: Align(
//               alignment: Alignment(0,-1/3),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(state.fungiName, style: Theme.of(context).textTheme.headline6,),
//                   SizedBox(height: 5,),
//                   Text('${state.currentUser.areaName} ${"antibiogram".tr()}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),),
//                   SizedBox(height: 5,),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.only(left: 25, top: 10),
//                       // color: Colors.red,
//                       child: Text(
//                         "WHO AWARE Classification",
//                         style:Theme.of(context).textTheme.caption,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 6,
//                         child: MultiSelectChipField(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.transparent)
//                           ),
//                           items: state.whoAwareList.map((e) => MultiSelectItem<String>(e, e.tr())).toList(),
//                           initialValue: state.whoAwareSelected,
//                           textStyle: Theme.of(context).textTheme.caption,
//                           showHeader: false,
//                           scroll: false,
//                           onTap: (List<String> value){
//                             context.read<DrugListPerFungiCubit>().changeWhoAwareList(value: value);
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: IconButton(
//                           icon: Icon(
//                             state.descendingWhoAware? FontAwesomeIcons.sortAmountUp : FontAwesomeIcons.sortAmountDown,
//                             color: Colors.blueAccent,
//                           ),
//                           onPressed: (){
//                             context.read<DrugListPerFungiCubit>().changeSortDirectionWhoAware(sortDirection: !state.descendingWhoAware);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   _DrugDetailButtonList(),
//                   SizedBox(height: 10,),
//                   (state.sourcePage==0) ? RoundedLoadingButton(
//                     controller: _btnController,
//                     color: Theme.of(context).colorScheme.secondary,
//                     onPressed: () async {
//                       await context.read<DrugListPerFungiCubit>().selectFungi();
//                       _btnController.success();
//                     },
//                     child: Text('choose'.tr()),
//                   ) : Container(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SpectrumScoreFungiForm extends StatefulWidget {
//   const SpectrumScoreFungiForm({Key? key}) : super(key: key);
//
//   @override
//   _SpectrumScoreFungiFormState createState() => _SpectrumScoreFungiFormState();
// }
// class _SpectrumScoreFungiFormState extends State<SpectrumScoreFungiForm> {
//   RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DrugListPerFungiCubit, DrugListPerFungiState>(
//       listener: (context, state) {
//         if (state.status == DrugListPerFungiStatus.error) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
//         } else if(state.status == DrugListPerFungiStatus.drugJudgement){
//           getAlert(context: context,
//             title: '結果通知',
//             msg: '診断内容: \n ${state.fungiName}',
//             clickFunction: true, okButton: true, okFunction: (){},
//           );
//         }
//       },
//       child: BlocBuilder<DrugListPerFungiCubit, DrugListPerFungiState>(
//         builder: (context, state) => WillPopScope(
//           onWillPop: () async => (state.sourcePage==0) ?
//           onBackPressed(
//             context: context, pageNumber: 18, navNumber: 0, subParameter: state.patientName, subParameter2nd: state.patientId,
//             subParameter3rd: state.caseName, subParameter4th: state.caseId, subParameter5th: state.specimenId,
//           ) :
//           onBackPressed(
//             context: context, pageNumber: 13, navNumber: 0, subParameter: state.imageId, subParameter2nd: state.finalJudgement,
//             subParameter3rd: state.patientId, subParameter4th: state.patientName, subParameter5th: state.caseId,
//             subParameter6th: state.caseName, subParameter7th: state.specimenId,
//           ),
//           child: Container(
//             height: MediaQuery.of(context).size.height*1.0,
//             child: Align(
//               alignment: Alignment(0,-1/3),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(state.fungiName, style: Theme.of(context).textTheme.headline6,),
//                   SizedBox(height: 5,),
//                   Text('${state.currentUser.areaName} ${"antibiogram".tr()}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),),
//                   SizedBox(height: 10,),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.only(left: 25, top: 10),
//                       // color: Colors.red,
//                       child: Text(
//                         "Spectrum Score",
//                         style:Theme.of(context).textTheme.caption,
//                       ),
//                     ),
//                   ),
//                   _InteractiveSliderSpectrum(),
//                   SizedBox(height: 10,),
//                   _DrugDetailButtonList(),
//                   SizedBox(height: 10,),
//                   (state.sourcePage==0) ? RoundedLoadingButton(
//                     controller: _btnController,
//                     color: Theme.of(context).colorScheme.secondary,
//                     onPressed: () async {
//                       await context.read<DrugListPerFungiCubit>().selectFungi();
//                       _btnController.success();
//                     },
//                     child: Text('choose'.tr()),
//                   ) : Container(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }