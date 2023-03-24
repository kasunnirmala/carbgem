import 'package:carbgem/modules/auth_wizard/auth_wizard.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/modules/phone_register/phone_register.dart';
import 'package:carbgem/modules/resend_email/resend_email.dart';
import 'package:flutter/widgets.dart';
import 'package:carbgem/modules/firebase_flutter/firebase_flutter.dart';
import 'package:carbgem/modules/login/login.dart';

List<Page> onGenerateFirebaseFlutterViewPages(
    FirebaseFlutterStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case FirebaseFlutterStatus.authenticated:
      return [BasicHomeRoute.page()];
    case FirebaseFlutterStatus.authenticatedUnverified:
      return [ResendEmailPage.page()];
    case FirebaseFlutterStatus.authenticatedPhoneUnregistered:
      return [PhoneRegisterPage.page()];
    case FirebaseFlutterStatus.unauthenticated:
    default:
      // return [LoginPage.page()];
      return [AuthWizardPage.page()];
  }
}
