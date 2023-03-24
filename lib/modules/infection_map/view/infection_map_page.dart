import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/constants/api_path.dart';
import 'package:carbgem/constants/app_constants.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/infection_map/infection_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:loading_animations/loading_animations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geodesy/geodesy.dart' show Geodesy;
import 'package:geodesy/geodesy.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';

class InfectionMapPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: InfectionMapPage());
  const InfectionMapPage({Key? key}): super(key: key);
  static Route route(){
    return MaterialPageRoute(builder: (_) => const InfectionMapPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Label_Title_infectionMap'.tr(), style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.withOpacity(0.9),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0
      ),
      endDrawer: CustomDrawer(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) => InfectionMapCubit(context.read<BitteApiClient>(), context.read<AuthenticationRepository>()),
            child: InfectionMap(),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class InfectionMap extends StatelessWidget {
  const InfectionMap({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<InfectionMapCubit, InfectionMapState>(
      listener: (context, state) {
        if (state.status == InfectionMapStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        }
      },
      child: BlocBuilder<InfectionMapCubit, InfectionMapState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterOption(),
                SizedBox(height: 20,),
                _MapLayer(),
                SizedBox(height: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLayer extends StatelessWidget {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfectionMapCubit, InfectionMapState>(
      builder: (context, state) =>  (state.status == InfectionMapStatus.loading) ?
        Center(child: LoadingBouncingGrid.square(backgroundColor: Theme.of(context).primaryColor,),) :
        Container(
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.height*0.5,
          child: FlutterMap(
            options: MapOptions(
              center: japanLatLng,
              zoom: 4.5,
              plugins: [ZoomButtonsPlugin()],
              onTap: (clickPoint, latlngClick) {
                var _detail = onPolygon(
                  clickPoint: latlngClick,
                  pointList: state.shapeList,
                  detailList: state.detailList,
                );
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            state.selectDrug.whoAware=="Access" ? Colors.green :
                            state.selectDrug.whoAware=="Watch" ? Colors.orange :
                            state.selectDrug.whoAware=="Reserve" ? Colors.redAccent :
                            state.selectDrug.whoAware=="Not_Reccommended" ? Colors.brown : Colors.grey,
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
                    height: MediaQuery.of(context).size.height*0.35,
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Center(child: Text(_detail!=null ? _detail['name'] : 'Label_InfectionMap_noInformation'.tr(), style: Theme.of(context).textTheme.headline5,) ),
                        SizedBox(height: 10,),
                        _detail!=null ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Label_InfectionMap_susceptibleNum'.tr(), style: Theme.of(context).textTheme.caption,),
                            SizedBox(width: 10,),
                            Text('${_detail['susceptible']}', style: Theme.of(context).textTheme.caption,),
                          ],
                        ) : Container(),
                        SizedBox(height: 10,),
                        _detail!=null ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Label_InfectionMap_resistantNum'.tr(), style: Theme.of(context).textTheme.caption,),
                            SizedBox(width: 10,),
                            Text('${_detail['resistant']}', style: Theme.of(context).textTheme.caption,),
                          ],
                        ) : Container(),
                        SizedBox(height: 10,),
                        _detail!=null ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Label_InfectionMap_intermediateNum'.tr(), style: Theme.of(context).textTheme.caption,),
                            SizedBox(width: 10,),
                            Text('${_detail['intermediate']}', style: Theme.of(context).textTheme.caption,),
                          ],
                        ) : Container(),
                        SizedBox(height: 10,),
                        _detail!=null ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('susceptibilityRate'.tr(), style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            Text(
                              '${(_detail['susceptible']/(_detail['susceptible'] + _detail['intermediate'] + _detail['resistant'] + _detail['nonsusceptible'])*100).toStringAsFixed(2)} %',
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ) : Container(),
                        SizedBox(height: 20,),
                        RoundedLoadingButton(
                          controller: _btnController,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: _detail!=null ? (){
                            context.read<BasicHomeCubit>().pageChanged(
                              value: 17, subPageParameter: "", subPageParameter2nd: "", subPageParameter3rd: "", subPageParameter4th: "", subPageParameter5th: "",
                              subPageParameter6th: "", subPageParameter7th: state.fungiId, subPageParameter8th: "", subPageParameter9th: state.selectDrug.drugName,
                              subPageParameter10th: _detail["area_id"], subPageParameter11th: state.specimenId, subPageParameter12th: _detail['name'],subPageParameter13th: "${state.sourcePage}"
                            );
                            _btnController.reset();
                            Navigator.pop(context);
                          } : null,
                          child: Text("details".tr()),
                        ),
                        SizedBox(height: 10,),
                      ],
                    )
                  ),
                );
              }
            ),
            layers: [
              TileLayerOptions(urlTemplate: '$mapBoxPath$mapBoxToken'),
              ...state.antiMapList.map((e) => PolygonLayerOptions(polygons: e.areaShape)),
              // PolygonLayerOptions(polygons: state.antiMapList[3].areaShape),
            ],
            nonRotatedLayers: [
              ZoomButtonsPluginOption(
                  minZoom: 1,
                  maxZoom: 20,
                  mini: true,
                  padding: 10,
                  alignment: Alignment.bottomRight
              )
            ],
          ),
        ),
    );
  }
}


class ZoomButtonsPluginOption extends LayerOptions {
  final double minZoom;
  final double maxZoom;
  final bool mini;
  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;

  ZoomButtonsPluginOption({
    Key? key,
    this.minZoom = 1,
    this.maxZoom = 20,
    this.mini = true,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
    Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class ZoomButtonsPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ZoomButtonsPluginOption) {
      return ZoomButtons(options, mapState, stream);
    }
    throw Exception('${"Label_InfectionMap_unknownOption".tr()}: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ZoomButtonsPluginOption;
  }
}

class ZoomButtons extends StatelessWidget {
  final ZoomButtonsPluginOption zoomButtonsOpts;
  final MapState map;
  final Stream<Null> stream;
  final FitBoundsOptions options =
  const FitBoundsOptions(padding: EdgeInsets.all(12.0));

  ZoomButtons(this.zoomButtonsOpts, this.map, this.stream)
      : super(key: zoomButtonsOpts.key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: zoomButtonsOpts.alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: zoomButtonsOpts.padding,
                top: zoomButtonsOpts.padding,
                right: zoomButtonsOpts.padding),
            child: FloatingActionButton(
              heroTag: 'Label_InfectionMap_zoomIn'.tr(),
              mini: zoomButtonsOpts.mini,
              backgroundColor:
              zoomButtonsOpts.zoomInColor ?? Theme.of(context).primaryColor,
              onPressed: () {
                var bounds = map.getBounds();
                var centerZoom = map.getBoundsCenterZoom(bounds, options);
                var zoom = centerZoom.zoom + 1;
                if (zoom < zoomButtonsOpts.minZoom) {
                  zoom = zoomButtonsOpts.minZoom;
                } else {
                  map.move(centerZoom.center, zoom, source: MapEventSource.initialization);
                }
              },
              child: Icon(zoomButtonsOpts.zoomInIcon,
                  color: zoomButtonsOpts.zoomInColorIcon ??
                      IconTheme.of(context).color),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(zoomButtonsOpts.padding),
            child: FloatingActionButton(
              heroTag: 'Label_InfectionMap_zoomOut'.tr(),
              mini: zoomButtonsOpts.mini,
              backgroundColor: zoomButtonsOpts.zoomOutColor ??
                  Theme.of(context).primaryColor,
              onPressed: () {
                var bounds = map.getBounds();
                var centerZoom = map.getBoundsCenterZoom(bounds, options);
                var zoom = centerZoom.zoom - 1;
                if (zoom > zoomButtonsOpts.maxZoom) {
                  zoom = zoomButtonsOpts.maxZoom;
                } else {
                  map.move(centerZoom.center, zoom, source: MapEventSource.initialization);
                }
              },
              child: Icon(zoomButtonsOpts.zoomOutIcon,
                  color: zoomButtonsOpts.zoomOutColorIcon ??
                      IconTheme.of(context).color),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfectionMapCubit, InfectionMapState>(
      builder: (context, state) {
        return (state.status==InfectionMapStatus.loading) ? Container() : Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                state.selectDrug.whoAware=="Access" ? Colors.green :
                state.selectDrug.whoAware=="Watch" ? Colors.orange :
                state.selectDrug.whoAware=="Reserve" ? Colors.redAccent :
                state.selectDrug.whoAware=="Not_Recommended" ? Colors.brown : Colors.grey,
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
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
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
                        Expanded(flex: 2,child: Text("specimen".tr(), style: Theme.of(context).textTheme.caption,)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.specimenId,
                          onChanged: (value){
                            context.read<InfectionMapCubit>().changeSpecimenId(value: '$value');
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
                          value: state.fungiId,
                          onChanged: (value){
                            context.read<InfectionMapCubit>().changeFungiId(value: '$value');
                          },
                          items: state.fungiList.map((e) {
                            return DropdownMenuItem(
                              value: '${e.fungiId}',
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
                          onChanged: (value){
                            context.read<InfectionMapCubit>().changeDrugId(value: value);
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
                        Expanded(flex: 2,child: Text("year".tr(), style: Theme.of(context).textTheme.caption)),
                        Expanded(flex: 3,child: DropdownButton(
                          value: state.year,
                          onChanged: (value){
                            context.read<InfectionMapCubit>().changeYear(value: '$value');
                          },
                          items: janisYearList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e, style: Theme.of(context).textTheme.caption),
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
                            context.read<InfectionMapCubit>().changeOrigin(value: '$value');
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
                            context.read<InfectionMapCubit>().changeSex(value: '$value');
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
                            context.read<InfectionMapCubit>().changeAgeGroup(value: '$value');
                          },
                          items: patientAgeGroupList.map((e) {
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
                            context.read<InfectionMapCubit>().changeBedSize(value: '$value');
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
                        context.read<InfectionMapCubit>().getInfectionData();
                      },
                      child: Text('OK', style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white, fontSize: 20, letterSpacing: 2),),
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

onPolygon({required LatLng clickPoint, required  List<Polygon> pointList, required  List detailList}){
  var geodesy = Geodesy();
  print(pointList);
  for (int i=0; i<pointList.length; i++) {
    if (geodesy.isGeoPointInPolygon(clickPoint, pointList[i].points)) {
      return detailList[i];
    }
  }
  return null;
}
