import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:flutter/material.dart';
String getErrorMessage({required Exception exception}){
  if (exception is AuthenticationInvalidPhoneNumber) {
    return 'Invalid Phone Number';
  } else if (exception is AuthenticationEmailAlreadyExists) {
    return 'Email Already Exists';
  } else if (exception is AuthenticationUserNotFound) {
    return 'User Not Found';
  } else if (exception is AuthenticationInvalidEmail) {
    return 'Invalid Email Address';
  } else if (exception is AuthenticationInvalidCredential) {
    return 'Invalid Authentication Credential';
  } else if (exception is AuthenticationInvalidIdToken) {
    return 'Invalid Authentication ID Token';
  } else if (exception is AuthenticationInvalidPassword) {
    return 'Invalid Password';
  } else if (exception is AuthenticationPhoneAlreadyExists) {
    return 'Phone Number Already Exists';
  } else if (exception is AuthenticationInvalidVerificationCode) {
    return 'Invalid Verification Code';
  } else if (exception is AuthenticationCodeExpired) {
    return 'Expired Verification Code';
  } else if (exception is AuthenticationQuotaExceed) {
    return 'Quota Exceeded';
  } else if (exception is SignUpFailure) {
    return 'Sign Up Failure';
  } else if (exception is LoginFailure) {
    return 'Log In Failure';
  } else if (exception is EmailVerifiedFailure) {
    return 'Email Verification Failure';
  } else if (exception is PhoneRegisterFailure) {
    return 'Phone Registration Failure';
  } else if (exception is PhoneLinkFailure) {
    return 'Phone Link Failure';
  } else if (exception is ResetPasswordEmailFailure) {
    return 'Reset Password Email Failure';
  } else if (exception is LogoutFailure) {
    return 'Log Out Failure';
  } else if(exception is AuthenticationWrongPassword){
    return 'Wrong Password';
  } else if (exception is AuthenticationWeakPassword){
    return 'Weak Password';
  } else if (exception is AuthenticationUserTokenExpired) {
    return 'Current User Token Expired';
  } else if (exception is AuthenticationNullUser) {
    return 'User to be Updated is Null';
  } else if (exception is AuthenticationAlreadyExists){
    return 'Phone Already Exists';
  } else if (exception is NoNetworkConnection) {
    return "No Internet Connection Detects";
  } else if (exception is SocketException) {
    return "No Internet Connection Detects";
  } else if (exception is TimeoutException) {
    return exception.message ?? "Connection Time Out. Please retry";
  } else if (exception is AntibiogramDrugInfFilterFailure) {
    return "Error on API fungi/antibiogram: ${exception.statusCode}";
  } else if (exception is RegisterUserFailure) {
    return "Error on API login/init_login_v1: ${exception.statusCode}";
  } else if (exception is RegisterActivationCodeFailure) {
    return "Error on API login/activation: ${exception.statusCode}";
  } else if (exception is UserProfileModify) {
    return "Error on API users/ POST: ${exception.statusCode}";
  } else if (exception is AddingPatientFailure) {
    return "Error on API patient/add POST: ${exception.statusCode}";
  } else if (exception is PatientListFetchFailure) {
    return "Error on API patient/add GET: ${exception.statusCode}";
  } else if (exception is AddingCaseFailure) {
    return "Error on API case/add POST: ${exception.statusCode}";
  } else if (exception is CaseListFetchFailure) {
    return "Error on API case/list POST: ${exception.statusCode}";
  } else if (exception is FinalDrugJudgementFailure) {
    return "Error on API drug/feedback POST: ${exception.statusCode}";
  } else if (exception is FinalFungiJudgementFailure) {
    return "Error on API feedback/fungi_judge_confirm POST: ${exception.statusCode}";
  } else if (exception is UnclassifiedImageToPatientListFailure) {
    return "Error on API users/image_list GET: ${exception.statusCode}";
  } else if (exception is CaseImageListFailure) {
    return "Error on API case/ POST: ${exception.statusCode}";
  } else if (exception is FungiUndetectedError) {
    return "Uploaded image contains no fungi";
  } else if (exception is FungiDetectionAPIError) {
    return "Error on API /api/fungi/ai_common_function_v1 POST: ${exception.statusCode}";
  } else if (exception is FetchFungiResultFailure) {
    return "Error on API image/detect_result POST: ${exception.statusCode}";
  } else if (exception is FungiFinalJudgementFailure) {
    return "Error on API fungi/final_judge POST: ${exception.statusCode}";
  } else if (exception is AttachImageToPatientFailure) {
    return "Error on API image/full_attach POST: ${exception.statusCode}";
  } else if (exception is DrugDetailsFailure) {
    return "Error on API drug/antibiogram POST: ${exception.statusCode}";
  } else if (exception is CaseDetachFailure) {
    return "Error on API case/detach POST: ${exception.statusCode}";
  } else if (exception is PatientDetachFailure) {
    return "Error on API patient/detach POST: ${exception.statusCode}";
  } else if (exception is FungiListFullFailure) {
    return "Error on API fungi/all_fungi GET: ${exception.statusCode}";
  } else if (exception is CaseSummaryFailure) {
    return "Error on API case/summary POST: ${exception.statusCode}";
  } else if (exception is CaseFeedbackFungiFailure) {
    return "Error on API case/feedback_fungi POST: ${exception.statusCode}";
  } else if (exception is CaseFeedbackDrugFailure) {
    return "Error on API case/feedback_drug POST: ${exception.statusCode}";
  } else if (exception is FetchAreaListFailure) {
    return "Error on API area/list POST: ${exception.statusCode}";
  } else if (exception is FetchHospitalListFailure) {
    return "Error on API hospital/list POST: ${exception.statusCode}";
  } else if (exception is FetchAntibiogramMapFailure) {
    return "Error on API fungi/antibiogram_map POST: ${exception.statusCode}";
  } else if (exception is FetchJANISFungiListFailure) {
    return "Error on API fungi/all_fungi POST: ${exception.statusCode}";
  } else if (exception is FetchJANISDrugListFailure) {
    return "Error on API drug/drug_janis_list POST: ${exception.statusCode}";
  } else if (exception is FetchPurchaseHistoryFailure) {
    return "Error on API service/item_purchase_history GET: ${exception.statusCode}";
  } else if (exception is CreatePurchaseHistoryFailure) {
    return "Error on API service/item_purchase_history POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownAreaFailure) {
    return "Error on API antibiogram/area POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownAgeFailure) {
    return "Error on API antibiogram/age POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownDrugFailure) {
    return "Error on API antibiogram/drug POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownOriginFailure) {
    return "Error on API antibiogram/origin POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownSexFailure) {
    return "Error on API antibiogram/sex POST: ${exception.statusCode}";
  } else if (exception is FetchBreakdownSizeFailure) {
    return "Error on API antibiogram/size POST: ${exception.statusCode}";
  } else if (exception is DeleteImageAPIFailure) {
    return "Error on API image/detect_result DELETE: ${exception.statusCode}";
  } else if (exception is DeleteCaseAPIFailure) {
    return "Error on API case/ DELETE: ${exception.statusCode}";
  } else if (exception is DeletePatientAPIFailure) {
    return "Error on API patient/image_list DELETE: ${exception.statusCode}";
  } else if (exception is FetchUserRecordAPIFailure) {
    return "Error on API records/ GET: ${exception.statusCode}";
  } else {
    return 'Authentication Failure';
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}