import 'package:carbgem/modules/image_class_list_release/cubit/image_class_list_release_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// renders form in response to LoginState
/// invokes methods on LoginCubit in response to user interaction

class ImageClassListReleaseForm extends StatelessWidget {
  final String caseName;
  ImageClassListReleaseForm({Key? key, required this.caseName}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageClassListReleaseCubit, ImageClassListReleaseState>(
      listener: (context, state) {
        if (state.status == ImageClassListReleaseStatus.error) {
          ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state.status == ImageClassListReleaseStatus.detachSuccess) {
          getAlert(context: context,
            title: 'dialog_title'.tr(),
            msg: 'releaseSuccess'.tr(),
            clickFunction: true, okButton: false,
          );
        }
      },
      child: BlocBuilder<ImageClassListReleaseCubit, ImageClassListReleaseState>(
        builder:(context, state) => WillPopScope(
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
                  Text("Label_imageClassListRelease_imageList".tr(), style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 16,),
                  _ImageListView(),
                  _ClassReleaseButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class _ImageListView extends StatefulWidget {
  @override
  __ImageListViewState createState() => __ImageListViewState();
}

class __ImageListViewState extends State<_ImageListView> {
  List _selectedImageList = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassListReleaseCubit, ImageClassListReleaseState>(
      builder: (context, state) => (state.status == ImageClassListReleaseStatus.loading) ? Container(child: CircularProgressIndicator(),) :
      Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height*0.55,
        child: SizedBox(
          child:GridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(state.imageList.length, (index) {
              return InkWell(
                onTap: (){
                  if (_selectedImageList.contains(int.parse(state.imageList[index].imageId))) {
                    setState(() {
                      _selectedImageList.remove(int.parse(state.imageList[index].imageId));
                    });
                  } else {
                    setState(() {
                      _selectedImageList.add(int.parse(state.imageList[index].imageId));
                    });
                  }
                  context.read<ImageClassListReleaseCubit>().changeSelectedList(selectedList: _selectedImageList.cast<int>());
                },
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        child: Image.network(
                          state.imageList[index].imagePath,
                          fit: BoxFit.fitWidth,
                          colorBlendMode: BlendMode.modulate,
                          color: _selectedImageList.contains(int.parse(state.imageList[index].imageId))
                              ? Color.fromRGBO(255, 255, 255, 0.5)
                              : Color.fromRGBO(255, 255, 255, 1.0),
                        ),
                      ),
                      Icon(Icons.check_circle, color: _selectedImageList.contains(int.parse(state.imageList[index].imageId))
                          ? Colors.blueAccent : Colors.transparent,),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ClassReleaseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageClassListReleaseCubit, ImageClassListReleaseState>(
      builder: (context, state) => ElevatedButton(
        key: const Key("class_release_button"),
        onPressed: () {
          context.read<ImageClassListReleaseCubit>().detachCaseList();
        },
        child: Text('Label_imageClassListRelease_releaseCase'.tr()),
      ),
    );
  }
}
