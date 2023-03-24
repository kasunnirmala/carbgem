part of 'basic_home_cubit.dart';
enum BasicHomeStatus { loading, unactivated, activated, failure }
class BasicHomeState extends Equatable{
  final BasicHomeStatus status;
  final bitte.User currentUser;
  final int navigationIndex;
  final int pageNavigation;
  final String errorMessage;
  final String subPageParameter;
  final String subPageParameter2nd;
  final String subPageParameter3rd;
  final String subPageParameter4th;
  final String subPageParameter5th;
  final String subPageParameter6th;
  final String subPageParameter7th;
  final String subPageParameter8th;
  final String subPageParameter9th;
  final String subPageParameter10th;
  final String subPageParameter11th;
  final String subPageParameter12th;
  final String subPageParameter13th;
  final String subPageParameter14th;
  final String subPageParameter15th;
  final bool subPageParameter16th;
  const BasicHomeState({this.status = BasicHomeStatus.loading, this.navigationIndex=0,
    this.pageNavigation=0, this.subPageParameter="", this.subPageParameter2nd = "",
    this.subPageParameter3rd = "", this.subPageParameter4th = "", this.subPageParameter5th="",
    this.subPageParameter6th = "", this.subPageParameter7th="", this.subPageParameter8th="",
    this.subPageParameter9th = "", this.subPageParameter10th = "", this.subPageParameter11th="",
    this.subPageParameter12th="", this.subPageParameter13th = '', this.subPageParameter14th = '',
    this.subPageParameter15th='', this.errorMessage="",
    this.currentUser = bitte.User.empty, this.subPageParameter16th = false
  });

  @override
  List<Object?> get props => [
    status, currentUser, navigationIndex, pageNavigation, subPageParameter, subPageParameter2nd,
    subPageParameter3rd, subPageParameter4th, subPageParameter5th, subPageParameter6th, subPageParameter7th,
    subPageParameter8th,subPageParameter9th, subPageParameter10th, subPageParameter11th, subPageParameter12th,
    subPageParameter13th, subPageParameter14th, subPageParameter15th, errorMessage, subPageParameter16th
  ];

  BasicHomeState copyWith({BasicHomeStatus? status, bitte.User? currentUser, String? errorMessage,}){
    return BasicHomeState(
      status: status ?? this.status, currentUser: currentUser?? this.currentUser,
      errorMessage: errorMessage?? this.errorMessage,
    );
  }

  BasicHomeState copyWithNavigation({required int pageNavigation, String? subPageParameter, String? subPageParameter2nd,
    String? subPageParameter3rd, String? subPageParameter4th, String? subPageParameter5th, String? subPageParameter6th,
    String? subPageParameter7th, String? subPageParameter8th, String? subPageParameter9th, String? subPageParameter10th,
    String? subPageParameter11th, String? subPageParameter12th, String? subPageParameter13th, String? subPageParameter14th,
    String? subPageParameter15th, bool? subPageParameter16th
  }) {
    return BasicHomeState(pageNavigation: pageNavigation, status: this.status,
      subPageParameter: subPageParameter ?? this.subPageParameter,
      subPageParameter2nd: subPageParameter2nd ?? this.subPageParameter2nd,
      subPageParameter3rd: subPageParameter3rd ?? this.subPageParameter3rd,
      subPageParameter4th: subPageParameter4th ?? this.subPageParameter4th,
      subPageParameter5th: subPageParameter5th ?? this.subPageParameter5th,
      subPageParameter6th: subPageParameter6th ?? this.subPageParameter6th,
      subPageParameter7th: subPageParameter7th ?? this.subPageParameter7th,
      subPageParameter8th: subPageParameter8th ?? this.subPageParameter8th,
      subPageParameter9th: subPageParameter9th ?? this.subPageParameter9th,
      subPageParameter10th: subPageParameter10th ?? this.subPageParameter10th,
      subPageParameter11th: subPageParameter11th ?? this.subPageParameter11th,
      subPageParameter12th: subPageParameter12th ?? this.subPageParameter12th,
      subPageParameter13th: subPageParameter13th?? this.subPageParameter13th,
      subPageParameter14th: subPageParameter14th?? this.subPageParameter14th,
      subPageParameter15th: subPageParameter15th?? this.subPageParameter15th,
      subPageParameter16th: subPageParameter16th?? this.subPageParameter16th
    );
  }
}
