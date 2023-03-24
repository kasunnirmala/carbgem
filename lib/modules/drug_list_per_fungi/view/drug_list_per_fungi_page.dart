import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/modules/all.dart';
import 'package:carbgem/utils/utils.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/drug_list_per_fungi/drug_list_per_fungi.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrugListPerFungiPage extends StatefulWidget {
  final String fungiName;
  final String fungiCode;
  final String finalJudgement;
  final String caseId;
  final String patientName;
  final String patientId;
  final String caseName;
  final int sourcePage;
  final String imageId;
  final String specimenId;
  const DrugListPerFungiPage({
    Key? key, required this.fungiName, required this.fungiCode,required this.finalJudgement,
    required this.caseId, required this.patientName, required this.patientId, required this.caseName,
    required this.sourcePage, required this.imageId, required this.specimenId,
  }) : super(key: key);

  static Page page({
    required String finalJudgement, required String caseId,
    required String patientName, required String patientId, required String caseName,
    required String fungiName, required String fungiCode, required int sourcePage,
    required String imageId, required String specimenId,
  }) => MaterialPage<void>(child: DrugListPerFungiPage(
    finalJudgement: finalJudgement, caseName: caseName, caseId: caseId,
    patientId: patientId, patientName: patientName, fungiCode: fungiCode, fungiName: fungiName,
    sourcePage: sourcePage, imageId: imageId, specimenId: specimenId,
  ));

  @override
  _DrugListPerFungiPageState createState() => _DrugListPerFungiPageState();
}

class _DrugListPerFungiPageState extends State<DrugListPerFungiPage> with SingleTickerProviderStateMixin{
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Label_Title_antibioticsResult'.tr(), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.withOpacity(0.9),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white,),
          onPressed: () {
            if (widget.sourcePage==0) {
              context.read<BasicHomeCubit>().pageChanged(
                value: 18, subPageParameter: widget.patientName, subPageParameter2nd: widget.patientId,
                subPageParameter3rd: widget.caseName, subPageParameter4th: widget.caseId, subPageParameter5th: widget.specimenId,
              );
            } else if (widget.sourcePage==1){
              context.read<BasicHomeCubit>().pageChanged(
                value: 13, subPageParameter: widget.imageId, subPageParameter2nd: widget.finalJudgement,
                subPageParameter3rd: widget.patientId, subPageParameter4th: widget.patientName, subPageParameter5th: widget.caseId,
                subPageParameter6th: widget.caseName, subPageParameter7th: widget.specimenId
              );
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)
            ),
            color: HexColor("#94dfff"),
          ),
          tabs: [
            Tab(child: Container(child: Text("Hospital Antibiogram", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),),),
            Tab(child: Container(child: Text("JANIS Antibiogram", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),),),
          ],
        ),
      ),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: CustomNavigationBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: BlocProvider(
              create: (_) => DrugListPerFungiCubit(
                context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), widget.fungiCode,
                widget.fungiName, widget.finalJudgement, widget.caseId, widget.caseName, widget.patientId, widget.patientName,0,
                false, true, true,
                widget.sourcePage, widget.imageId, widget.specimenId,
              ),
              child: DrugListPerFungiForm(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: BlocProvider(
              create: (_) => DrugListPerFungiCubit(
                context.read<AuthenticationRepository>(), context.read<BitteApiClient>(), widget.fungiCode,
                widget.fungiName, widget.finalJudgement, widget.caseId, widget.caseName, widget.patientId, widget.patientName,1,
                false, true, true,
                widget.sourcePage, widget.imageId, widget.specimenId,
              ),
              child: DrugListPerFungiForm(),
            ),
          ),
        ],
      ),
    );
  }
}