import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbgem/modules/user_info_profile/user_info_profile.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInfoProfileForm extends StatefulWidget {
  final TextEditingController _hospitalController = TextEditingController();
  UserInfoProfileForm({Key? key}) : super(key: key);

  @override
  UserInfoProfileFormState createState() {
    _hospitalController.text = UserInfoProfileState().selectHospitalName;
    return UserInfoProfileFormState(_hospitalController);
  }
}

class UserInfoProfileFormState extends State<UserInfoProfileForm> {
  final TextEditingController _hospitalController;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String hospitalName = "";
  String hospitalId = "";

  callback(varHospitalName, varHospitalId) {
    setState(() {
      hospitalName = varHospitalName;
      hospitalId = varHospitalId;
    });
  }

  UserInfoProfileFormState(this._hospitalController);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoProfileCubit, UserInfoProfileState>(
      listener: (context, state) {
        if (state.status == UserInfoProfileStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("errorFetch".tr())));
        } else if (state.status == UserInfoProfileStatus.submissionSuccess) {
          getAlert(context: context,
              title: 'dialog_title'.tr(),
              msg: 'Label_UserInfoProfile_successUpdate'.tr(),
              clickFunction: true, okButton: true, okFunction: (){}
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async => onBackPressed(context: context, pageNumber: 0, navNumber: 0),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: BlocBuilder<UserInfoProfileCubit, UserInfoProfileState>(
            builder:(context, state) => Align(
              alignment: Alignment(0,-1/3),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.8,
                  child:ListView(
                    children: [
                      SizedBox(height: 30,),
                      _JobTitle(),
                      SizedBox(height: 20,),
                      _CountrySelection(initialHospital: state.selectHospitalName, callback: callback,),
                      // CountryChoose(),
                      SizedBox(height: 20,),
                      // TODO: convert below widget to Class like _ModifyButton
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: RoundedLoadingButton(
                          key: const Key('signUpForm_continue_button'),
                          controller: _btnController,
                          onPressed: () async {
                            // await context.read<UserInfoProfileCubit>().modifyUserProfileInfo();
                            context.read<UserInfoProfileCubit>().hospitalIdChanged(value: hospitalId, valueName: hospitalName);
                            AwesomeDialog(
                              context: context,
                              title: "変更を確定しますか。",
                              dialogType: DialogType.WARNING,
                              animType: AnimType.BOTTOMSLIDE,
                              borderSide: BorderSide(color: Colors.orange, width: 2),
                              buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                              btnCancelText: "NO",
                              btnOkText: "YES",
                              showCloseIcon: true,
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                context.read<UserInfoProfileCubit>().hospitalIdChanged(value: hospitalId, valueName: hospitalName);
                                await context.read<UserInfoProfileCubit>().modifyUserProfileInfo();
                              },
                            )..show();
                            _btnController.reset();
                          },
                          child: Text('registerButton'.tr()),
                        ),
                      ),
                      // _ModifyButton(hospitalName: hospitalName, hospitalId: hospitalId,),
                      // _ModifyButton(),
                      // _AntiBiogramTypeText(),
                      // AntibiogramType(function:setAntibiogramType),
                      // SizedBox(height: 10,),
                      // _UserInfoUpdateButton(userType,countryId,phoneNumber,antibiogramType),
                      SizedBox(height: MediaQuery.of(context).size.height*0.15,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JobTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoProfileCubit, UserInfoProfileState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0,3)
              )]
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Align(alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.medkit),
                        SizedBox(width: 30,),
                        Text("jobTitle".tr(), style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<SigningCharacter>(
                          value: SigningCharacter.doctor,
                          groupValue: state.selectUserType,
                          onChanged: (value) => context.read<UserInfoProfileCubit>().userTypeChanged(value: value!),
                        ),
                        SizedBox(width: 10,),
                        Text('doctor'.tr(), style: Theme.of(context).textTheme.subtitle1,)
                      ],
                    ),
                    Row(
                      children: [
                        Radio<SigningCharacter>(
                          value: SigningCharacter.physician,
                          groupValue: state.selectUserType,
                          onChanged: (value) => context.read<UserInfoProfileCubit>().userTypeChanged(value: value!),
                        ),
                        SizedBox(width: 10,),
                        Text('physician'.tr(), style: Theme.of(context).textTheme.subtitle1,)
                      ],
                    ),
                    Row(
                      children: [
                        Radio<SigningCharacter>(
                          value: SigningCharacter.others,
                          groupValue: state.selectUserType,
                          onChanged: (value) => context.read<UserInfoProfileCubit>().userTypeChanged(value: value!),
                        ),
                        SizedBox(width: 10,),
                        Text('others'.tr(), style: Theme.of(context).textTheme.subtitle1,)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountrySelection extends StatefulWidget {
  final String initialHospital;
  final TextEditingController _hospitalController = TextEditingController();
  final Function callback;
  _CountrySelection({Key? key, required this.initialHospital, required this.callback}) : super(key: key);

  @override
  ___CountrySelectionState createState() {
    _hospitalController.text = initialHospital;
    return ___CountrySelectionState(this._hospitalController, this.callback);
  }
}

///TODO: if account is activated, change in hospital need to switch off current activation and ask for new activation code
class ___CountrySelectionState extends State<_CountrySelection> {
  final TextEditingController _hospitalController;
  final Function callback;
  String _hospitalName =  "";
  String _hospitalId = "";

  ___CountrySelectionState(this._hospitalController, this.callback);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoProfileCubit, UserInfoProfileState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0,3)
              )]
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Align(alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.globe),
                        SizedBox(width: 30,),
                        Text("location".tr(), style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("country".tr(), style: Theme.of(context).textTheme.caption,),
                        SizedBox(width: 75,),
                        DropdownButton<String>(
                          value: state.selectCountryId,
                          icon: Icon(FontAwesomeIcons.chevronCircleDown, color: Theme.of(context).colorScheme.secondary,),
                          iconSize: 24,
                          style: Theme.of(context).textTheme.caption,
                          items: state.countryList.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(e.countryName),
                            ), value: e.countryId,);
                          }).toList(),
                          onChanged: (String? value) {
                            context.read<UserInfoProfileCubit>().countryIdChanged(value: value!, hospitalController: _hospitalController);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("area".tr(), style: Theme.of(context).textTheme.caption,),
                        SizedBox(width: 25,),
                        DropdownButton<String>(
                          value: state.selectAreaId,
                          icon: Icon(FontAwesomeIcons.chevronCircleDown, color: Theme.of(context).colorScheme.secondary,),
                          iconSize: 24,
                          style: Theme.of(context).textTheme.caption,
                          items: state.areaList.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(e.areaName),
                            ), value: e.areaId,);
                          }).toList(),
                          onChanged: (String? value) {
                            context.read<UserInfoProfileCubit>().areaIdChanged(value: value!, hospitalController: _hospitalController);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("hospitalCompany".tr(), style: Theme.of(context).textTheme.caption,),
                        SizedBox(width: 15,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: TextFormField(
                            controller: _hospitalController,
                            style: Theme.of(context).textTheme.bodyText2,
                            onTap: (){
                              showBarModalBottomSheet(context: context, builder: (context) {
                                List<HospitalAPI> filterHospitalList = state.hospitalList;
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setModalState) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height,
                                        child: ListView(
                                            children: [
                                              SizedBox(height: 10,),
                                              TextFormField(
                                                style: Theme.of(context).textTheme.bodyText2,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(FontAwesomeIcons.search),
                                                  hintText: "病院・会社名を入力してください",
                                                ),
                                                onChanged: (value){
                                                  List<HospitalAPI> tempList = [];
                                                  for (int i=0; i<state.hospitalList.length; i++){
                                                    if (state.hospitalList[i].hospitalName.toLowerCase().contains(value.toLowerCase())) {
                                                      tempList.add(state.hospitalList[i]);
                                                    }
                                                  }
                                                  tempList.sort((a,b) => a.hospitalName.compareTo(b.hospitalName));
                                                  setModalState((){
                                                    filterHospitalList = tempList;
                                                  });
                                                  //context.read<UserInfoProfileCubit>().hospitalIdChanged(value: suggestion.hospitalId, valueName: suggestion.hospitalName);
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              ...filterHospitalList.map((suggestion) {
                                                return Card(
                                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  color: Colors.lightBlue.shade50,
                                                  elevation: 5,
                                                  child: ListTile(
                                                    leading: Icon(FontAwesomeIcons.hospital),
                                                    title: Text("${suggestion.hospitalName}", style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),),
                                                    onTap: (){
                                                      setState(() {
                                                        _hospitalController.text = suggestion.hospitalName;
                                                        _hospitalName = _hospitalController.text;
                                                        _hospitalId = suggestion.hospitalId;
                                                      });
                                                      callback(_hospitalName, _hospitalId);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                            ]
                                        ),
                                      );
                                    }
                                );
                              },);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}


class _ModifyButton extends StatefulWidget {
  _ModifyButton({Key? key}) : super(key: key);
  @override
  __ModifyButtonState createState() {
    return __ModifyButtonState();
  }

}

class __ModifyButtonState extends State<_ModifyButton> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoProfileCubit, UserInfoProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: RoundedLoadingButton(
            key: const Key('signUpForm_continue_button'),
            controller: _btnController,
            onPressed: (state.status == UserInfoProfileStatus.valid) ? () async {
              await context.read<UserInfoProfileCubit>().modifyUserProfileInfo();
              _btnController.reset();
              print(state.selectHospitalId);
              print(state.selectHospitalName);
            } : null,
            child: Text('registerButton'.tr()),
          ),
        );
      },
    );
  }
}

// class _AntiBiogramTypeText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       key: const Key("patient_not_classified_button"),
//       width: double.infinity,
//       margin: const EdgeInsets.all(15.0),
//       padding: const EdgeInsets.all(3.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         "アンチバイオグラム種別"
//       ),
//     );
//   }
// }

// class _UserInfoUpdateButton extends StatelessWidget {
//   final int userType;
//   final int countryId;
//   final String phoneNumber;
//   final int antibiogramType;
//   _UserInfoUpdateButton(
//     this.userType,
//     this.countryId,
//     this.phoneNumber,
//     this.antibiogramType,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UserInfoProfileCubit, UserInfoProfileState>(
//       builder: (context, state) {
//         return ElevatedButton(
//           key: const Key("user_info_profile_update"),
//           onPressed: () {
//             context.read<UserInfoProfileCubit>().modifyUserProfileInfo(userType: state.userType, countryId: state.countryId, phoneNumber: state.phoneNumber);
//             // context.read<UserInfoProfileCubit>().refresh(value: "refresh");
//             // Navigator.of(context).push<void>(BasicHome.route());
//             Navigator.pop(context);
//           },
//           child: Text('ユーザー情報編集確定'),);
//       },);
//   }
// }
