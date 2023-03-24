import 'package:bitte_api/bitte_api.dart';
import 'package:carbgem/constants/app_constants.dart';
import 'package:carbgem/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:carbgem/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}): super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {

    ///
    /// The below code make language not changeable => japanese
    // context.setLocale(Locale("ja"));
    ///

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if(state.status == SignUpStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        } else if (state.status == SignUpStatus.submissionSuccess) {
            getAlert(
              context: context, title: 'Label_SignUp_verifyEmail'.tr(),
              msg: 'Label_SignUp_checkEmail'.tr(),
              clickFunction: true, okButton: true,
              okFunction: () {
                Navigator.of(context).pop();
              },
            );
        }
      },
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state){
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Align(
              alignment: Alignment(0,-1/3),
              child: SingleChildScrollView(
                child:Container(
                  height: MediaQuery.of(context).size.height*0.8,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      _JobTitle(),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      _CountrySelection(),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      _UserDetail(),
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      _SignUpButton(),
                      SizedBox(height: MediaQuery.of(context).size.height*0.15,),
                    ],
                  ),
                )
              ),
            ),
          );
        },
      ),
    );
  }
}

class _JobTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                          onChanged: (value) => context.read<SignUpCubit>().changeUserType(value: value!),
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
                          onChanged: (value) => context.read<SignUpCubit>().changeUserType(value: value!),
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
                          onChanged: (value) => context.read<SignUpCubit>().changeUserType(value: value!),
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
  @override
  __CountrySelectionState createState() => __CountrySelectionState();
}

class __CountrySelectionState extends State<_CountrySelection> {
  final TextEditingController _hospitalController = TextEditingController();
  String _hospitalName =  "";
  String _hospitalId = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                            context.read<SignUpCubit>().changeSelectCountry(value: value!);
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
                            context.read<SignUpCubit>().changeSelectArea(value: value!);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("利用言語".tr(), style: Theme.of(context).textTheme.caption,),
                        SizedBox(width: 25,),
                        DropdownButton<String>(
                          value: state.languageLocale,
                          icon: Icon(FontAwesomeIcons.chevronCircleDown, color: Theme.of(context).colorScheme.secondary,),
                          iconSize: 24,
                          style: Theme.of(context).textTheme.caption,
                          items: countryCodes.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                              value: e["code"],
                              child: Row(
                                children: [
                                  Text(e["flag"]),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Text(tr(e["name"])),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            context.read<SignUpCubit>().changeLocale(newValue!, context);
                          },
                        )
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Text("hospitalCompany".tr(), style: Theme.of(context).textTheme.caption,),
                    //     SizedBox(width: 15,),
                    //     Container(
                    //       width: MediaQuery.of(context).size.width*0.5,
                    //       child: TypeAheadFormField(
                    //         onSuggestionSelected: (suggestion){
                    //           suggestion = suggestion as HospitalAPI;
                    //           _hospitalController.text = suggestion.hospitalName;
                    //           context.read<SignUpCubit>().changeSelectHospital(value: suggestion.hospitalId);
                    //         },
                    //         direction: AxisDirection.up,
                    //         itemBuilder: (context, suggestion) {
                    //           suggestion = suggestion as HospitalAPI;
                    //           return ListTile(title: Text('${suggestion.hospitalName}'),);
                    //         },
                    //         suggestionsCallback: (pattern) {
                    //           return state.hospitalList.where((element) => element.hospitalName.toLowerCase().contains(pattern.toLowerCase()));
                    //         },
                    //         textFieldConfiguration: TextFieldConfiguration(
                    //           controller: _hospitalController,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                              void changeHospital(String newId){
                                print("change hospital");
                                context.read<SignUpCubit>().changeSelectHospital(value: newId);
                              }
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
                                                        changeHospital(suggestion.hospitalId);
                                                      });
                                                      // callback(_hospitalName, _hospitalId);
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

                    SizedBox(height: 20,),
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email!=current.email,
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Focus(
              child: Builder(builder: (BuildContext context) {
                final bool hasFocus = Focus.of(context).hasFocus;
                return TextField(
            style: Theme.of(context).textTheme.caption,
            key: const Key("signUpForm_email_textField"),
            onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_rounded, color: Theme.of(context).colorScheme.secondary,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'email'.tr(), helperText: '', errorText: (!hasFocus && state.email.invalid) ? 'invalid_email'.tr() : null,
            ),
          );
          }),
        ));
      },
    );
  }
}

class _UserDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                        Icon(FontAwesomeIcons.userCog),
                        SizedBox(width: 30,),
                        Text("userInformation".tr(), style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 10.0),
               child: Column(
                children: [
                  SizedBox(height: 10,),
                  _EmailInput(),
                  Text("passwordRule".tr(),style: Theme.of(context).textTheme.subtitle2,),
                  SizedBox(height: 10,),
                  _PasswordInput(),
                  _ConfirmedPasswordInput(),
                  _PhoneNumberInput(),
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password, 
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Focus(
              child: Builder(builder: (BuildContext context) {
                final bool hasFocus = Focus.of(context).hasFocus;
                return TextField(
            style: Theme.of(context).textTheme.caption,
            key: const Key("signUpForm_password_textField"),
            onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.lock, color: Theme.of(context).colorScheme.secondary,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'password'.tr(), helperText: '', errorText: (!hasFocus && state.password.invalid) ? 'invalidPassword'.tr():null,
            ),
          );
          }),
        ));
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.confirmedPassword != current.confirmedPassword ||
          previous.password != current.password,
      builder: (context, state){
        return Container(
          width: MediaQuery.of(context).size.width*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Focus(
              child: Builder(builder: (BuildContext context) {
                final bool hasFocus = Focus.of(context).hasFocus;
                return TextField(
            style: Theme.of(context).textTheme.caption,
            key: const Key("signUpForm_confirmedPassword_textField"),
            onChanged: (confirmedPassword) => context.read<SignUpCubit>().confirmedPasswordChanged(confirmedPassword),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.solidCheckCircle, color: Theme.of(context).colorScheme.secondary,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'Label_SignUp_confirmedPassword'.tr(), helperText: '', errorText: (!hasFocus && state.confirmedPassword.invalid) ? 'passwordNotMatch'.tr():null,
            ),
          );
          }),
        ));
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
      builder: (context, state){
        return Container(
          width: MediaQuery.of(context).size.width*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Focus(
              child: Builder(builder: (BuildContext context) {
                final bool hasFocus = Focus.of(context).hasFocus;
                return TextField(
            style: Theme.of(context).textTheme.caption,
            key: const Key("signUpForm_phoneNumber_textField"),
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            onChanged: (phoneNumber) => context.read<SignUpCubit>().phoneNumberChanged(phoneNumber),
            decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.mobileAlt, color: Theme.of(context).colorScheme.secondary,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'phoneNum'.tr(),
              helperText: "",
              errorText: (!hasFocus && state.phoneNumber.invalid) ? 'invalidPhoneNumber'.tr() : null,
            ),
          );
          }),
        ));
      },
    );
  }
}

class _SignUpButton extends StatefulWidget {
  @override
  __SignUpButtonState createState() => __SignUpButtonState();
}
class __SignUpButtonState extends State<_SignUpButton> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        print(state.status);
        print(state.selectHospitalId);
        print(state.status == SignUpStatus.valid && state.selectHospitalId!="");
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: RoundedLoadingButton(
            key: const Key('signUpForm_continue_button'),
            controller: _btnController,
            onPressed: (state.status == SignUpStatus.valid && state.selectHospitalId!="") ? () async {
              String errorMessage = await context.read<SignUpCubit>().signUpFirst();
              if (errorMessage != "") {
                _btnController.reset();
                if (errorMessage == "noInternetConnection".tr()) {
                  context.read<SignUpCubit>().emit(state.copyWith(status: SignUpStatus.valid, errorMessage: ""));
                }
              }
            } : null,
            child: Text("registerButton".tr()),
          ),
        );
      },
    );
  }
}

///
/// Language selector base class
/// If you use this, define a Parameter, "languageLocale", in state file.
/// And define changeLocale class in cubit file.
///
// class _LanguageSelector extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignUpCubit, SignUpState>(
//       buildWhen: (previous, current) =>
//       previous.languageLocale != current.languageLocale,
//       builder: (context, state) {
//         return Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 40.0,
//           ),
//           child: DropdownButton<String>(
//             value: state.languageLocale,
//             icon: Icon(FontAwesomeIcons.chevronDown),
//             items: countryCodes.map<DropdownMenuItem<String>>((e) {
//               return DropdownMenuItem<String>(
//                 value: e["code"],
//                 child: Row(
//                   children: [
//                     Text(e["flag"]),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.1,
//                     ),
//                     Text(tr(e["name"])),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               context.read<SignUpCubit>().changeLocale(newValue!, context);
//             },
//           ),
//         );
//       },
//     );
//   }
// }

