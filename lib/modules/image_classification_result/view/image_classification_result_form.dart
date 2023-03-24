import 'package:before_after/before_after.dart';
import 'package:carbgem/modules/basic_home/basic_home.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/image_classification_result/image_classification_result.dart';
/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class ImageClassificationResultForm extends StatefulWidget {

  @override
  State<ImageClassificationResultForm> createState() => _ImageClassificationResultFormState();
}


class _ImageClassificationResultFormState extends State<ImageClassificationResultForm> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageClassificationResultCubit, ImageClassificationResultState>(
      listener: (context, state) {
        if (state.status == ImageClassificationResultStatus.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        }
      },
      child: BlocBuilder<ImageClassificationResultCubit, ImageClassificationResultState>(
        builder: (context, state) {
          return (state.status == ImageClassificationResultStatus.loading) ? Center(child: CircularProgressIndicator(),)
          :WillPopScope(
            onWillPop: () async => onBackPressed(
              context: context, pageNumber: 10, navNumber: 0, subParameter: state.patientName, subParameter2nd: state.patientId,
                subParameter3rd: state.caseName, subParameter4th: state.caseId,
            ),
            child: Align(
                alignment: Alignment(0,-1/3),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      (state.fungiResult.imageGrad=="") ? _DetectionImageListViewForCloud(imagePathLeft: state.fungiResult.imagePath) :
                      _DetectionImageListViewForCloud(imagePathLeft: state.fungiResult.imagePrep, imagePathRight: state.fungiResult.imageGrad,),
                      SizedBox(height: 10,),
                      Text(
                        "Label_imageClassificationResult_diagnose".tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _FungiClassifiedStatusTextWithCubit(),
                      SizedBox(height: 10,),
                      Text(
                        "Label_imageClassificationResult_guessFungi".tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10,),
                      _ShowFungiDetectionResultButton(),
                      SizedBox(height: 10,),
                      // _FungiFinalRegisterButton(),
                    ],
                  ),
                ),
              ),
          );
      })
    );
  }
}

class _DetectionImageListViewForCloud extends StatelessWidget {
  final String imagePathLeft;
  final String imagePathRight;
  _DetectionImageListViewForCloud({required this.imagePathLeft, this.imagePathRight = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.4,
      child: (imagePathRight == "") ?
      Image.network(imagePathLeft) : BeforeAfter(
        beforeImage: Image.network(imagePathLeft),
        afterImage: Image.network(imagePathRight),
      )
    );
  }
}

class _ShowFungiDetectionResultButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultCubit, ImageClassificationResultState>(
      builder: (context, state) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          child: Text("Label_imageClassificationResult_resultFungi".tr()),
          key: const Key("show_fungi_detection_result_button"),
          onPressed: () => context.read<BasicHomeCubit>().pageChanged(
            value: 13, subPageParameter: state.imageId, subPageParameter2nd: state.finalJudgement,
            subPageParameter3rd: state.patientId, subPageParameter4th: state.patientName,
            subPageParameter5th: state.caseId, subPageParameter6th: state.caseName,
          ),
        ),
      ),
    );
  }
}

class _FungiClassifiedStatusText extends StatelessWidget {
  final String classificationStatus;
  _FungiClassifiedStatusText(this.classificationStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        classificationStatus,
        key: const Key("fungi_classified_status_text"),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FungiClassifiedStatusTextWithCubit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassificationResultCubit, ImageClassificationResultState>(
      buildWhen: (previous, current) => previous.fungiResult.imagePath != current.fungiResult.imagePath,
      builder: (context, state){
            return _FungiClassifiedStatusText(state.finalJudgement);
      },
    );
  }
}

class FungiTypeChoose extends StatefulWidget {
  const FungiTypeChoose({Key? key}) : super(key: key);

  @override
  State<FungiTypeChoose> createState() => _FungiTypeChooseState();
}

/// This is the private State class that goes with FungiTypeChoose.
class _FungiTypeChooseState extends State<FungiTypeChoose> {
  String dropdownValue = '菌類種別A';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      key: const Key("fungi_type_choose_button"),
      value: dropdownValue,
      isExpanded: false,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['${"Label_imageClassificationResult_fungiType".tr()}A', '${"Label_imageClassificationResult_fungiType".tr()}B', '${"Label_imageClassificationResult_fungiType".tr()}C', '${"Label_imageClassificationResult_fungiType".tr()}D']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
