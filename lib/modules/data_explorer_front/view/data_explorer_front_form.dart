import 'package:carbgem/modules/data_explorer_front/cubit/data_explorer_front_cubit.dart';
import 'package:carbgem/utils/ui/ui_utils.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';

class DataExplorerFrontForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DataExplorerFrontCubit, DataExplorerFrontState>(
      listener: (context, state) {
        if (state.status == DataExplorerFrontStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        }
      },
      child: BlocBuilder<DataExplorerFrontCubit, DataExplorerFrontState>(
        builder: (context, state) => (state.status==DataExplorerFrontStatus.loading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,)) :
        WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            height: MediaQuery.of(context).size.height*0.9,
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                // Breakdown by area
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#FE6862'),
                    ),
                    child: Column(
                     children: [
                       SizedBox(height: 20,),
                       Padding(child: Text('Label_dataExplorer_front_area'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                       SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                       Icon(FontAwesomeIcons.globeAsia, size: MediaQuery.of(context).size.width*0.2, color: Colors.white,),
                     ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 22);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#77DD78'),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(child: Text('Label_dataExplorer_front_drug'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Icon(FontAwesomeIcons.pills, size: MediaQuery.of(context).size.width*0.2, color: Colors.white,),
                      ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 23);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#B19CD8'),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(child: Text('Label_dataExplorer_front_sex'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Icon(FontAwesomeIcons.venusMars, size: MediaQuery.of(context).size.width*0.2, color: Colors.white,),
                      ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 24);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#FFB346'),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(child: Text('Label_dataExplorer_front_age'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Icon(
                          FontAwesomeIcons.baby,
                          size: MediaQuery.of(context).size.width*0.2,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 25);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#FCA0E3'),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(child: Text('Label_dataExplorer_front_origin'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Icon(FontAwesomeIcons.procedures, size: MediaQuery.of(context).size.width*0.2, color: Colors.white,),
                      ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 26);
                  },
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#6CB2D1'),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(child: Text('Label_dataExplorer_front_hospitalSize'.tr(), style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),), padding: EdgeInsets.symmetric(horizontal: 15),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Icon(FontAwesomeIcons.hospital, size: MediaQuery.of(context).size.width*0.2, color: Colors.white,),
                      ],
                    ),
                  ),
                  onTap: (){
                    context.read<BasicHomeCubit>().pageChanged(value: 27);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
