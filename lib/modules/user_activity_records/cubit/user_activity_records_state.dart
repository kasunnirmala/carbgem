part of 'user_activity_records_cubit.dart';

enum UserActivityRecordsStatus {
  loading, error, success,
}

class UserActivityRecordsState extends Equatable{
  final UserRecords activityRecord;
  final UserActivityRecordsStatus status;
  final String errorMessage;

  UserActivityRecordsState({
    this.activityRecord = UserRecords.empty, this.status = UserActivityRecordsStatus.loading,
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [activityRecord, status, errorMessage];

  UserActivityRecordsState copyWith({UserRecords? activityRecord, UserActivityRecordsStatus? status, String? errorMessage}) {
    return UserActivityRecordsState(
      activityRecord: activityRecord?? this.activityRecord, status: status?? this.status, errorMessage: errorMessage?? this.errorMessage,
    );
  }
}