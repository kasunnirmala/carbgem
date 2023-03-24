import 'package:easy_localization/src/public_ext.dart';
import 'package:latlong2/latlong.dart';
final LatLng japanLatLng = LatLng(36.2, 138.3);
final String japanCode = "109";
final String mapBoxToken = "pk.eyJ1IjoiYW5uZXh0Z2VtIiwiYSI6ImNrbjVodnY2cjA0YnkydWpuaDcwdHRqZW8ifQ.aJwphM7wm0agN5hoS_2ZiA";
final List specimenList = [{'value': 'urine'.tr(), 'code': "1"}, {'value': 'blood'.tr(), 'code': "2"}, {'value': 'sputum'.tr(), 'code': "3"}, {'value': 'spinal'.tr(), 'code': "4"}];
final List imageUploadSpecimenList = [{'value': 'urine'.tr(), 'code': "1"}, {'value': 'blood'.tr(), 'code': "2"}, {'value': 'sputum'.tr(), 'code': "3"}];
final List test = ["尿", "血液"];
final List patientTypeList = [{'value': 'Label_dataExplorer_origin_allPatient'.tr(), 'code': 'ALL'}, {'value': 'inpatient'.tr(), 'code': 'HO'}, {'value': 'outpatient'.tr(), 'code': 'CO'}];
final List patientSexList = [{'value': 'Label_dataExplorer_sex_PieChart_all'.tr(), 'code': 'ALL'}, {'value':'male'.tr(), 'code': 'M'}, {'value': 'female'.tr(), 'code': 'F'}];
final List patientAgeGroupList = [
  {'value': 'filter_age_all'.tr(), 'code': 'ALL'}, {'value': 'filter_age_lessThan1'.tr(), 'code': '<1'},{'value': 'filter_age_from1To4'.tr(), 'code': '01<04'},
  {'value': 'filter_age_from5To14'.tr(), 'code': '05<14'}, {'value': 'filter_age_from15To24'.tr(), 'code': '15<24'}, {'value': 'filter_age_from25To34'.tr(), 'code': '25<34'},
  {'value': 'filter_age_from35To44'.tr(), 'code': '35<44'}, {'value': 'filter_age_from45To54'.tr(), 'code': '45<54'}, {'value': 'filter_age_from55To64'.tr(), 'code': '55<64'},
  {'value': 'filter_age_from65To74'.tr(), 'code': '65<74'}, {'value': 'filter_age_from75To84'.tr(), 'code': '75<84'},{'value': 'filter_age_moreThan85'.tr(), 'code': '85<'}];
final List bedSizeList = [
  {'value': 'Label_dataExplorer_size_pieChart_all'.tr(), 'code': 'ALL'}, {'value': 'Label_dataExplorer_size_less'.tr(), 'code': '<200'},
  {'value': 'Label_dataExplorer_size_atLeast'.tr(), 'code': '500<='}, {'value': 'Label_dataExplorer_size_toFrom'.tr(), 'code': '200-499'}];
final List janisYearList = ["2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011"];
final List<Map<String, dynamic>> countryCodes = [
  {
    "flag": "\ud83c\uddfa\ud83c\uddf8", "name": "english", "code": "en",
  },
  {
    "flag": "\ud83c\uddef\ud83c\uddf5", "name": "japanese", "code": "ja",
  },
  {
    "flag": "\ud83c\uddfb\ud83c\uddf3", "name": "vietnamese", "code": "vi",
  },
];
final List<String> modelLabel = [
  "UDB_01","UDB_02","UDB_03","UDB_04","UDB_05","UDB_06","UDB_07","UDB_08",
  "UDB_09","UDB_10","UDB_11","UDB_12","UDB_13","UDB_14","UDB_15","UDB_16",
  "UDB_18","UDB_19",
];
final Map<String, dynamic> modelFungiList = {
  "UDB_01": {
    "name": "Candida spp.",
    "code": 54
  },
  "UDB_02": {
    "name": "Citrobacter freundii",
    "code": 23
  },
  "UDB_03": {
    "name": "GPC cluster",
    "code": 55
  },
  "UDB_04": {
    "name": "Corynebacterium spp.",
    "code": 48
  },
  "UDB_05": {
    "name": "Enterobacter cloacae",
    "code": 7
  },
  "UDB_06": {
    "name": "Enterococcus faecalis",
    "code": 9
  },
  "UDB_07": {
    "name": "Enterococcus faecium",
    "code": 10
  },
  "UDB_08": {
    "name": "Escherichia coli (ESBL)",
    "code": 12
  },
  "UDB_09": {
    "name": "Klebsiella oxytoca",
    "code": 41
  },
  "UDB_10": {
    "name": "Klebsiella pneumoniae",
    "code": 14
  },
  "UDB_11": {
    "name": "Proteus mirabilis",
    "code": 31
  },
  "UDB_12": {
    "name": "Pseudomonas aeruginosa",
    "code": 33
  },
  "UDB_13": {
    "name": "Serratia marcescens",
    "code": 34
  },
  "UDB_14": {
    "name": "Streptococcus agalactiae",
    "code": 37
  },
  "UDB_15": {
    "name": "Other GPC",
    "code": 56
  },
  "UDB_16": {
    "name": "Other GNR Enterobacteriaceae",
    "code": 57
  },
  "UDB_17": {
    "name": "Other GNR Glucose non-fermenting bacteria",
    "code": 59
  },
  "UDB_18": {
    "name": "Escherichia coli (Non-ESBL)",
    "code": 13
  },
  "UDB_19": {
    "name": "GNC",
    "code": 58
  },
};