part of 'sign_up_cubit.dart';
enum SignUpStatus {
  pure, valid, invalid, submissionInProgress, submissionSuccess,
  submissionFailure, loading, error, success,
}

class SignUpValidationState {
  SignUpStatus validate({required FormzStatus status}) {
    switch(status){
      case FormzStatus.valid:
        return SignUpStatus.valid;
      case FormzStatus.invalid:
        return SignUpStatus.invalid;
      case FormzStatus.submissionInProgress:
        return SignUpStatus.submissionInProgress;
      case FormzStatus.submissionFailure:
        return SignUpStatus.submissionFailure;
      case FormzStatus.submissionSuccess:
        return SignUpStatus.submissionSuccess;
      case FormzStatus.pure:
      default:
        return SignUpStatus.pure;
    }
  }
}

class SignUpState extends Equatable {
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final PhoneNumber phoneNumber;
  final SignUpStatus status;
  final String errorMessage;
  final List<CountryAPI> countryList;
  final List<AreaAPI> areaList;
  final List<HospitalAPI> hospitalList;
  final String selectCountryId;
  final String selectAreaId;
  final String selectHospitalId;
  final SigningCharacter selectUserType;
  final String languageLocale;
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = SignUpStatus.pure,
    this.errorMessage = '',
    this.countryList = const [CountryAPI(countryName: "日本", countryId: "109"), CountryAPI(countryName: 'Vietnam', countryId: "240")],
    this.areaList = const [],
    this.hospitalList = const [],
    this.selectCountryId = "109", this.selectAreaId = "", this.selectHospitalId = "", this.selectUserType = SigningCharacter.doctor,
    this.languageLocale = "ja",
  });

  @override
  List<Object?> get props => [
    email, password, confirmedPassword, phoneNumber, status, errorMessage, countryList,
    hospitalList, areaList, selectUserType, selectCountryId, selectAreaId, selectHospitalId,
    languageLocale
  ];

  SignUpState copyWith({
    Email? email, Password? password,
    ConfirmedPassword? confirmedPassword,
    PhoneNumber? phoneNumber, SmsCode? smsCode,
    String? verId, SignUpStatus? status,
    String? errorMessage, List<CountryAPI>? countryList,
    List<HospitalAPI>? hospitalList, List<AreaAPI>? areaList,
    SigningCharacter? selectUserType, String? selectCountryId, String? selectAreaId,
    String? selectHospitalId, String? languageLocale,
  }){
    return SignUpState(
      email: email ?? this.email, password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber, status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      countryList: countryList?? this.countryList,
      areaList: areaList ?? this.areaList, hospitalList: hospitalList?? this.hospitalList,
      selectAreaId: selectAreaId ?? this.selectAreaId, selectCountryId: selectCountryId ?? this.selectCountryId,
      selectHospitalId: selectHospitalId ?? this.selectHospitalId, selectUserType: selectUserType?? this.selectUserType,
      languageLocale: languageLocale?? this.languageLocale,
    );
  }
}