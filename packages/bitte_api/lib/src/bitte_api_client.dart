import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:cache/cache.dart';
import 'package:bitte_api/src/models/models.dart';
import 'package:bitte_api/src/models/exceptions.dart';
import 'dart:async';
import 'package:flutter_flavor/flutter_flavor.dart';

// Bitte API　Client Which Has Functions
class BitteApiClient {
  // final _baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final _baseUrl = 'https://bitte-api.carbgem.app/api/';
  final CacheClient _cache;
  BitteApiClient({CacheClient? client}) : _cache = client ?? CacheClient();

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Future<void> sampleAPI(
      {required String sampledata, required String idToken}) async {
    final url = '${_baseUrl}sample/sample_action';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
    );
    if (response.statusCode != 200) {
      throw RegisterActivationCodeFailure(statusCode: response.statusCode);
    }
  }

// This is Sample API For Referinng
  Future<Map> sample2API(
      {required String sampledata, required String idToken}) async {
    final url = '${_baseUrl}sample/sample_action';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode(<String, String>{'sample_key': sampledata}),
    );
    if (response.statusCode != 200) {
      throw RegisterActivationCodeFailure(statusCode: response.statusCode);
    }
    final Map sampleMapData = json.decode(response.body);
    return sampleMapData;
  }

  Future<User> fetchUser({required String idToken}) async {
    final url = '${_baseUrl}users';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
    ).timeout(Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw FetchUserFailureBitte(statusCode: response.statusCode);
    }
    final json = jsonDecode(response.body);
    final User userBitte = User.fromJson(json["user"]);
    _cache.write(key: userCacheKey, value: userBitte);
    return userBitte;
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  String get phoneNumber {
    return this.currentUser.phoneNumber;
  }

  Future<void> registerUser(
      {required String idToken,
      required String password,
      required String countryId,
      required String hospitalId,
      required String userType,
      required String phoneNumber}) async {
    final url = '${_baseUrl}login/init_login_v1';
    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'ACCESS_TOKEN': '$idToken'
          },
          body: jsonEncode(<String, String>{
            'password': password,
            'country_id': countryId,
            'hospital_id': hospitalId,
            "user_type": userType,
            'phone_number': phoneNumber,
          }),
        )
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw RegisterUserFailure(statusCode: response.statusCode);
    }
  }

  Future<int> registerActivationCode(
      {required String activationCode, required String idToken}) async {
    final url = '${_baseUrl}login/activation';
    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'ACCESS_TOKEN': '$idToken'
          },
          body: jsonEncode(
              <String, String>{'activation_password': activationCode}),
        )
        .timeout(Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw RegisterActivationCodeFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<DrugAntibiogram>> antibiogramDrugInfoFilterAPI({
    required String fungiId,
    required String idToken,
    String specimenId = "1",
    String areaId = "0",
    String year = "2019",
    String bedSize = "ALL",
    String sex = "ALL",
    String origin = "ALL",
    String ageGroup = "ALL",
  }) async {
    final url = '${_baseUrl}fungi/antibiogram';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'year': year,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw AntibiogramDrugInfFilterFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<DrugAntibiogram> drugList = List<DrugAntibiogram>.from(
          json['antibiogram'].map((model) => DrugAntibiogram.fromJson(model)));
      return drugList;
    }
  }

  Future<int> modifyUserProfile({
    required int userType,
    required int countryId,
    required int areaId,
    required int hospitalId,
    required String idToken,
  }) async {
    final url = '${_baseUrl}users/';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'user_type': userType,
        "hospital_id": hospitalId,
      }),
    );
    if (response.statusCode != 200) {
      throw UserProfileModify(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> patientAddAPI(
      {required String patientIdTag, required String idToken}) async {
    final url = '${_baseUrl}patient/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode(<String, String>{
        'patient_id_tag': patientIdTag,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw AddingPatientFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<Patient>> patientListAPI({required String idToken}) async {
    final url = '${_baseUrl}patient/add';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw PatientListFetchFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Patient> patientList = List<Patient>.from(
          json['patient_list'].map((model) => Patient.fromJson(model)));
      return patientList;
    }
  }

  Future<int> caseAddAPI(
      {required String caseTag,
      required String specimenId,
      required String patientId,
      required String idToken}) async {
    final url = '${_baseUrl}case/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode(<String, String>{
        'case_id_tag': caseTag,
        'patient_id': patientId,
        'specimen_id': specimenId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw AddingCaseFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<Case>> caseListAPI(
      {required String idToken, required String patientId}) async {
    final url = '${_baseUrl}case/list';
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'ACCESS_TOKEN': '$idToken'
        },
        body: jsonEncode(<String, String>{
          'patient_id': patientId,
        }));
    if (response.statusCode != 200) {
      print(jsonDecode(response.body));
      throw CaseListFetchFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Case> caseList = List<Case>.from(
          json['message']['case'].map((model) => Case.fromJson(model)));
      return caseList;
    }
  }

  Future<int> determineFinalDrugJudgementAPI(
      {required String caseId,
      required String idToken,
      required String imageId,
      required String drugCode,
      required String fungiId,
      required String patientStatusId}) async {
    final url = '${_baseUrl}drug/feedback';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        "case_id": caseId,
        'image_id': imageId,
        'fungi_id': fungiId,
        'drug_code': drugCode,
        'patient_status_id': patientStatusId
      }),
    );
    if (response.statusCode != 200) {
      throw FinalDrugJudgementFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> determineFinalFungiJudgementAPI(
      {required String fungiJudgementName,
      required String historyId,
      required String idToken}) async {
    final url = '${_baseUrl}feedback/fungi_judge_confirm';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'fungi_detection_result_id': historyId,
        'feedback_fungi_name': fungiJudgementName,
      }),
    );
    if (response.statusCode != 200) {
      throw FinalFungiJudgementFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<ImagePath>> unclassifiedImageToPatientListAPI(
      {required String idToken}) async {
    final _url = '${_baseUrl}users/image_list';
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
    );
    if (response.statusCode != 200) {
      throw UnclassifiedImageToPatientListFailure(
          statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<ImagePath> imageList = List<ImagePath>.from(json["user"]
              ["image_paths"]
          .map((model) => ImagePath.fromJson(model)));
      return imageList;
    }
  }

  Future<ImageResult> caseImageListAPI(
      {required String idToken, required String caseId}) async {
    final _url = '${_baseUrl}case/';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'case_id': caseId,
      }),
    );
    if (response.statusCode != 200) {
      throw CaseImageListFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      return ImageResult.fromJson(json);
    }
  }

  Future<String> fungiDetectAPI(
      {required File uploadImage,
      required String idToken,
      required String caseId,
      required String patientId}) async {
    final stream = new http.ByteStream((uploadImage.openRead()).cast());
    final length = await uploadImage.length();
    final _url = '/api/fungi/ai_common_function_v1';
    final queryParameters = {
      'patient_id': patientId,
      'case_id': caseId,
    };
    final String _protocolName = _baseUrl.split('/')[0];
    final String _hostName = _baseUrl.split('/')[2];
    late Uri _finalUrl;
    if (_protocolName == 'http:') {
      _finalUrl = (patientId == "")
          ? Uri.http(_hostName, _url)
          : Uri.http(_hostName, _url, queryParameters);
    } else if (_protocolName == 'https:') {
      _finalUrl = (patientId == "")
          ? Uri.https(_hostName, _url)
          : Uri.https(_hostName, _url, queryParameters);
    }
    final request = http.MultipartRequest('POST', _finalUrl);
    final multiFile = new http.MultipartFile('image', stream, length,
        filename: basename(uploadImage.path));
    request.files.add(multiFile);
    request.headers.addAll(
        {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'});
    final response = await request.send();
    final check = await response.stream.bytesToString();
    final resultMessage = jsonDecode(check);
    final responseStatus = response.statusCode;
    if ((responseStatus == 202) &&
        (resultMessage["message"] == 'Uploaded image contains no fungi')) {
      throw FungiUndetectedError();
    } else if (responseStatus == 200) {
      return resultMessage["image_id"];
    } else {
      throw FungiDetectionAPIError(statusCode: response.statusCode);
    }
  }

  Future<String> fungi15CatAPI(
      {required String imageURL,
      required String idToken,
      required String caseId,
      required String patientId}) async {
    final _url = '${_baseUrl}fungi/is_fungi_type';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'image_url': imageURL,
        "patient_id": patientId,
        "case_id": caseId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FungiDetectionAPIError(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      return json["image_id"];
    }
  }

  Future<Fungi3Cat> fungi3CatAPI(
      {required File uploadImage,
      required String idToken,
      required String caseId,
      required String patientId}) async {
    final stream = new http.ByteStream((uploadImage.openRead()).cast());
    final length = await uploadImage.length();
    final _url = '/api/fungi/is_fungi_judge';
    final queryParameters = {
      'patient_id': patientId,
      'case_id': caseId,
    };
    final String _protocolName = _baseUrl.split('/')[0];
    final String _hostName = _baseUrl.split('/')[2];
    late Uri _finalUrl;
    if (_protocolName == 'http:') {
      _finalUrl = (patientId == "")
          ? Uri.http(_hostName, _url)
          : Uri.http(_hostName, _url, queryParameters);
    } else if (_protocolName == 'https:') {
      _finalUrl = (patientId == "")
          ? Uri.https(_hostName, _url)
          : Uri.https(_hostName, _url, queryParameters);
    }
    final request = http.MultipartRequest('POST', _finalUrl);
    final multiFile = new http.MultipartFile('image', stream, length,
        filename: basename(uploadImage.path));
    request.files.add(multiFile);
    request.headers.addAll(
        {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'});
    final response = await request.send();
    final check = await response.stream.bytesToString();
    final resultMessage = jsonDecode(check);
    final responseStatus = response.statusCode;
    if (responseStatus == 200) {
      return Fungi3Cat.fromJson(resultMessage);
    } else {
      throw FungiDetectionAPIError(statusCode: response.statusCode);
    }
  }

  Future<FungiResult> getFungiDetectResultAPI(
      {required String idToken, required String imageId}) async {
    final _url = '${_baseUrl}image/detect_result';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'image_id': imageId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FetchFungiResultFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      FungiResult imageList = FungiResult.fromJson(json["image_result"]);
      return imageList;
    }
  }

  Future<String> getFinalJudgement(
      {required String idToken, required String imageId}) async {
    final _url = '${_baseUrl}fungi/final_judge';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'image_id': imageId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FungiFinalJudgementFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      String finalJudgement = json["final_judgement"];
      return finalJudgement;
    }
  }

  Future<int> attachingPatientCaseImageAPI(
      {required String idToken,
      required List imageIdsList,
      required String patientId,
      required String caseId}) async {
    final _url = '${_baseUrl}image/full_attach';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'image_id_list': imageIdsList,
        'patient_id': patientId,
        'case_id': caseId
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw AttachImageToPatientFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<DrugTimeSeriesAnti> drugDetailsAPI({
    required String idToken,
    required String fungiId,
    required String drugCode,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
    required String hospitalId,
  }) async {
    final _url = '${_baseUrl}drug/antibiogram_v2';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_code': drugCode,
        'specimen_id': specimenId,
        'area_id': areaId,
        'hospital_id': hospitalId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw DrugDetailsFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      DrugTimeSeriesAnti result = DrugTimeSeriesAnti.fromJson(json);
      return result;
    }
  }

  Future<int> caseDetachAPI(
      {required List imageIdList, required String idToken}) async {
    final _url = '${_baseUrl}case/detach';
    final response = await http.post(Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'ACCESS_TOKEN': '$idToken'
        },
        body: jsonEncode({'image_id_list': imageIdList}));
    if (response.statusCode != 200) {
      print(response.body);
      throw CaseDetachFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> patientDetachAPI(
      {required List imageIdList, required String idToken}) async {
    final _url = '${_baseUrl}patient/detach';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({'image_id_list': imageIdList}),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw PatientDetachFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<FungiType>> fungiListFullAPI() async {
    final _url = '${_baseUrl}fungi/all_fungi';
    final response = await http.get(
      Uri.parse(_url),
    );
    if (response.statusCode != 200) {
      throw FungiListFullFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<FungiType> outList = FungiType.fromJsonList(json);
      return outList;
    }
  }

  Future<FungiSummaryAPI> fungiSummaryAPI(
      {required String caseId, required String idToken}) async {
    final _url = '${_baseUrl}case/summary';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({'case_id': caseId}),
    );
    if (response.statusCode != 200) {
      throw CaseSummaryFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      FungiSummaryAPI summaryApi = FungiSummaryAPI.fromJson(json);
      return summaryApi;
    }
  }

  Future<int> caseFeedbackFungiAPI(
      {required String idToken,
      required String caseId,
      required String fungiId}) async {
    final _url = '${_baseUrl}case/feedback_fungi';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'case_id': caseId,
        'fungi_id': fungiId,
      }),
    );
    if (response.statusCode != 200) {
      print(jsonEncode(response.body));
      throw CaseFeedbackFungiFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> caseFeedbackDrugAPI(
      {required String idToken,
      required String caseId,
      required String drugCode}) async {
    final _url = '${_baseUrl}case/feedback_drug';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({'case_id': caseId, 'drug_code': drugCode}),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw CaseFeedbackDrugFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<AreaAPI>> getAreaListAPI({required String countryId}) async {
    final _url = '${_baseUrl}area/list';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'country_id': countryId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FetchAreaListFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      return AreaAPI.fromJsonList(json);
    }
  }

  Future<List<HospitalAPI>> getHospitalListAPI({required String areaId}) async {
    final _url = '${_baseUrl}hospital/list';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'area_id': areaId,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FetchHospitalListFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      return HospitalAPI.fromJsonList(json);
    }
  }

  Future<List<FungiMapAPI>> getAntibiogramMapAPI({
    required String idToken,
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String year,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
    required String whoAware,
  }) async {
    final _url = '${_baseUrl}fungi/antibiogram_map';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'year': year,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchAntibiogramMapFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<FungiMapAPI> result =
          FungiMapAPI.fromJsonList(json: json, whoAware: whoAware);
      return result;
    }
  }

  Future<List<FungiType>> getJANISFungiListAPI(
      {required String specimenId}) async {
    final _url = '${_baseUrl}fungi/all_fungi';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'specimen_id': specimenId,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchJANISFungiListFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<FungiType> result = FungiType.fromJsonList(json);
      return result;
    }
  }

  Future<List<DrugType>> getJANISDrugListAPI(
      {required String specimenId, required String fungiId}) async {
    final _url = '${_baseUrl}drug/drug_janis_list';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'specimen_id': specimenId, 'fungi_id': fungiId}),
    );
    if (response.statusCode != 200) {
      throw FetchJANISDrugListFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<DrugType> result = DrugType.fromJsonList(json);
      return result;
    }
  }

  Future<FullPurchaseHistory> getPurchaseHistoryAPI(
      {required String tokenId}) async {
    final _url = '${_baseUrl}service/item_purchase_history';
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
    );
    if (response.statusCode != 200) {
      throw FetchPurchaseHistoryFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      return FullPurchaseHistory.fromJson(json);
    }
  }

  Future<int> createPurchaseHistoryAPI(
      {required String tokenId,
      required String purchaseToken,
      required String productSKU,
      required int purchaseStatus}) async {
    final _url = '${_baseUrl}service/item_purchase_history';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
      body: jsonEncode({
        'purchase_token': purchaseToken,
        'product_sku': productSKU,
        'purchase_status': purchaseStatus
      }),
    );
    if (response.statusCode != 200) {
      throw CreatePurchaseHistoryFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<List<Antibiogram>> getBreakdownAreaAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    print("check: $drugId");
    final _url = '${_baseUrl}antibiogram/area';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw FetchBreakdownAreaFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<List<Antibiogram>> getBreakdownAgeAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    final _url = '${_baseUrl}antibiogram/age';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchBreakdownAgeFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<List<Antibiogram>> getBreakdownDrugAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    final _url = '${_baseUrl}antibiogram/drug';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchBreakdownDrugFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<List<Antibiogram>> getBreakdownOriginAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    final _url = '${_baseUrl}antibiogram/origin';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchBreakdownOriginFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<List<Antibiogram>> getBreakdownSexAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    final _url = '${_baseUrl}antibiogram/sex';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchBreakdownSexFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<List<Antibiogram>> getBreakdownSizeAPI({
    required String fungiId,
    required String drugId,
    required String specimenId,
    required String areaId,
    required String bedSize,
    required String sex,
    required String origin,
    required String ageGroup,
  }) async {
    final _url = '${_baseUrl}antibiogram/size';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'drug_id': drugId,
        'specimen_id': specimenId,
        'area_id': areaId,
        'bed_size': bedSize,
        'sex': sex,
        'origin': origin,
        'agegroup': ageGroup,
      }),
    );
    if (response.statusCode != 200) {
      throw FetchBreakdownSizeFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<Antibiogram> result = Antibiogram.fromJsonList(json);
      return result;
    }
  }

  Future<int> deleteImageAPI(
      {required List<int> imageIdList, required String tokenId}) async {
    final _url = '${_baseUrl}image/detect_result';
    final response = await http.delete(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
      body: jsonEncode({
        'image_id_list': imageIdList,
      }),
    );
    if (response.statusCode != 200) {
      throw DeleteImageAPIFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> deleteCaseAPI(
      {required String caseId, required String tokenId}) async {
    final _url = '${_baseUrl}case/';
    final response = await http.delete(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
      body: jsonEncode({
        'case_id': caseId,
      }),
    );
    if (response.statusCode != 200) {
      throw DeleteCaseAPIFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<int> deletePatientAPI(
      {required String patientId, required String tokenId}) async {
    final _url = '${_baseUrl}patient/image_list';
    final response = await http.delete(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
      body: jsonEncode({
        'patient_id': patientId,
      }),
    );
    if (response.statusCode != 200) {
      print(tokenId);
      print(jsonDecode(response.body));
      throw DeletePatientAPIFailure(statusCode: response.statusCode);
    } else {
      return response.statusCode;
    }
  }

  Future<UserRecords> fetchUserActivityRecordAPI(
      {required String tokenId}) async {
    final _url = '${_baseUrl}records/';
    print(tokenId);
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$tokenId'},
    );
    if (response.statusCode != 200) {
      throw FetchUserRecordAPIFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      UserRecords result = UserRecords.fromJson(json);
      return result;
    }
  }

  Future<String> fungiTfliteAPI({
    required File uploadImage,
    required String idToken,
    required String caseId,
    required String patientId,
    required String name1,
    required String code1,
    required String rate1,
    required String name2,
    required String code2,
    required String rate2,
    required String name3,
    required String code3,
    required String rate3,
    required String name4,
    required String code4,
    required String rate4,
    required String name5,
    required String code5,
    required String rate5,
  }) async {
    final stream = new http.ByteStream((uploadImage.openRead()).cast());
    final length = await uploadImage.length();
    final _url = '/api/fungi/ai_common_function_v2';
    final queryParameters1 = {
      'patient_id': patientId,
      'case_id': caseId,
      'name_1': name1,
      "code_1": code1,
      "rate_1": rate1,
      'name_2': name2,
      "code_2": code2,
      "rate_2": rate2,
      'name_3': name3,
      "code_3": code3,
      "rate_3": rate3,
      'name_4': name4,
      "code_4": code4,
      "rate_4": rate4,
      'name_5': name5,
      "code_5": code5,
      "rate_5": rate5,
    };
    final queryParameters2 = {
      'name_1': name1,
      "code_1": code1,
      "rate_1": rate1,
      'name_2': name2,
      "code_2": code2,
      "rate_2": rate2,
      'name_3': name3,
      "code_3": code3,
      "rate_3": rate3,
      'name_4': name4,
      "code_4": code4,
      "rate_4": rate4,
      'name_5': name5,
      "code_5": code5,
      "rate_5": rate5,
    };
    final String _protocolName = _baseUrl.split('/')[0];
    final String _hostName = _baseUrl.split('/')[2];
    late Uri _finalUrl;
    if (_protocolName == 'http:') {
      _finalUrl = (patientId == "")
          ? Uri.http(_hostName, _url, queryParameters2)
          : Uri.http(_hostName, _url, queryParameters1);
    } else if (_protocolName == 'https:') {
      _finalUrl = (patientId == "")
          ? Uri.https(_hostName, _url, queryParameters2)
          : Uri.https(_hostName, _url, queryParameters1);
    }
    final request = http.MultipartRequest('POST', _finalUrl);
    final multiFile = new http.MultipartFile('image', stream, length,
        filename: basename(uploadImage.path));
    request.files.add(multiFile);
    request.headers.addAll(
        {'Content-Type': 'application/json', 'ACCESS_TOKEN': '$idToken'});
    final response = await request.send();
    final check = await response.stream.bytesToString();
    final resultMessage = jsonDecode(check);
    final responseStatus = response.statusCode;
    print("result message: $check");
    if (responseStatus != 200) {
      throw FungiDetectionAPIError(statusCode: response.statusCode);
    } else {
      return resultMessage["image_id"];
    }
  }

  Future<FungiIndividual> fungiIndividualAPI({required String fungiId}) async {
    final _url = '${_baseUrl}fungi/individual_fungi';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
      }),
    );
    print("response: ${response.statusCode}");
    if (response.statusCode != 200) {
      throw FungiIndividualAPIFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      FungiIndividual fungiIndividual = FungiIndividual.fromJson(json);
      return fungiIndividual;
    }
  }

  Future<List<DrugAntibiogram>> hospitalAntibiogramAPI({
    required String hospitalId,
    required String fungiId,
    required String specimenId,
    required String year,
  }) async {
    final _url = '${_baseUrl}antibiogram/hospital_level';
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fungi_id': fungiId,
        'hospital_id': hospitalId,
        "specimen_id": specimenId,
        "year": year,
      }),
    );
    if (response.statusCode != 200) {
      throw FungiIndividualAPIFailure(statusCode: response.statusCode);
    } else {
      final json = jsonDecode(response.body);
      List<DrugAntibiogram> antibiogramList = List<DrugAntibiogram>.from(
          json['antibiogram'].map((model) => DrugAntibiogram.fromJson(model)));
      return antibiogramList;
    }
  }
}
