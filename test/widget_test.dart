// import 'package:carbgem/modules/basic_home/basic_home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:carbgem/widgets/widgets.dart';
// import 'package:carbgem/modules/all.dart';
//
// class MyWidget extends StatelessWidget {
//   const MyWidget({
//     Key? key,
//     required this.title,
//     required this.message,
//   }) : super(key: key);
//
//   final String title;
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(title),
//         ),
//         body: Center(
//           child: Text(message),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//
//   testWidgets('Sample Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
//     // Create the Finders.
//     final titleFinder = find.text('T');
//     final messageFinder = find.text('M');
//
//     // Use the `findsOneWidget` matcher provided by flutter_test to
//     // verify that the Text widgets appear exactly once in the widget tree.
//     expect(titleFinder, findsOneWidget);
//     expect(messageFinder, findsOneWidget);
//   });
//
//   testWidgets('ActivationPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ActivationPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('CaseAttachingImageListPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const CaseAttachingImageListPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('CaseListPerPatientPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const CaseListPerPatientPage());
//     // Create the Finders.
//     expect(find.byKey(Key('case_not_classified_button')), findsOneWidget);
//     expect(find.byKey(Key('case_detail_button')), findsOneWidget);
//     expect(find.byKey(Key('case_register_button')), findsOneWidget);
//     expect(find.byKey(Key('case_choose_button')), findsOneWidget);
//
//   });
//
//   testWidgets('CaseNotClassifiedImageListPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const CaseNotClassifiedImageListPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('DrugDetailDescriptionPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const DrugDetailDescriptionPage());
//     // Create the Finders.
//     expect(find.byKey(Key('drug_sucep_slider')), findsOneWidget);
//     expect(find.byKey(Key('doctor_comment_text')), findsOneWidget);
//
//   });
//
//   testWidgets('DrugListPerFungiPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const DrugListPerFungiPage());
//     // Create the Finders.
//     // None To Test
//
//   });
//
//   testWidgets('FungiClassificationGroupListPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const FungiClassificationGroupListPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('HomePage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const BasicHomePage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('ImageClassListReleasePage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ImageClassListReleasePage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('ImageClassificationResultPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ImageClassificationResultPage());
//     // Create the Finders.
//     expect(find.byKey(Key('original_image_box')), findsOneWidget);
//     expect(find.byKey(Key('colored_image_box')), findsOneWidget);
//     expect(find.byKey(Key('show_fungi_detection_resul_button')), findsOneWidget);
//     expect(find.byKey(Key('original_image_title')), findsOneWidget);
//     expect(find.byKey(Key('colored_image_title')), findsOneWidget);
//     expect(find.byKey(Key('fungi_classified_status_text')), findsOneWidget);
//     expect(find.byKey(Key('fungi_final_register_button')), findsOneWidget);
//     expect(find.byKey(Key('fungi_type_choose_button')), findsOneWidget);
//
//   });
//
//   testWidgets('ImageClassificationResultDetailPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ImageClassificationResultDetailPage());
//     // Create the Finders.
//     expect(find.byKey(Key('detection_original_image_box')), findsOneWidget);
//     expect(find.byKey(Key('detection_colored_image_box')), findsOneWidget);
//     expect(find.byKey(Key('fungi_type_list_view_text_button')), findsOneWidget);
//     expect(find.byKey(Key('image_desc_original_title')), findsOneWidget);
//     expect(find.byKey(Key('image_desc_colored_title')), findsOneWidget);
//     expect(find.byKey(Key('fungi_final_register_button')), findsOneWidget);
//     expect(find.byKey(Key('fungi_type_choose_button')), findsOneWidget);
//
//   });
//
//   testWidgets('ImageListPerCasePage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ImageListPerCasePage());
//     // Create the Finders.
//     expect(find.byKey(Key('image_with_text_button')), findsOneWidget);
//     expect(find.byKey(Key('case_de_register_button')), findsOneWidget);
//
//   });
//
//   testWidgets('ImageUploadPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ImageUploadPage());
//     // Create the Finders.
//     expect(find.byKey(Key('image_camera_icon')), findsOneWidget);
//     expect(find.byKey(Key('image_upload_button')), findsOneWidget);
//
//   });
//
//   testWidgets('InfectionMapPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const InfectionMapPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('LoginPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const LoginPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('PatientAttachingImageListPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const PatientAttachingImageListPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('PatientListPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const PatientListPage());
//     // Create the Finders.
//     expect(find.byKey(Key("patient_not_classified_button")), findsOneWidget);
//     expect(find.byKey(Key("loginForm_createAccount_button")), findsOneWidget);
//     expect(find.byKey(Key("patient_detail_button")), findsOneWidget);
//     expect(find.byKey(Key("loginForm_createAccount_button")), findsOneWidget);
//     expect(find.byKey(Key("patient_register_button")), findsOneWidget);
//     expect(find.byKey(Key("patient_id_choose_button")), findsOneWidget);
//
//   });
//
//   testWidgets('PatientNotClassifiedImagePage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const PatientNotClassifiedImagePage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('PhoneRegisterPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(PhoneRegisterPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('ResendEmailPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ResendEmailPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('SignUpPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const SignUpPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
//   testWidgets('VersionDisplayPage Testing', (WidgetTester tester) async {
//
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(const ActivationPage());
//     // Create the Finders.
//     expect(find.byKey(Key('sample_key')), findsOneWidget);
//
//   });
//
// }
