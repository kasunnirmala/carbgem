part of 'data_explorer_front_cubit.dart';
enum DataExplorerFrontStatus {loading, error, success, initial}

class DataExplorerFrontState extends Equatable{
  final DataExplorerFrontStatus status;
  final String errorMessage;

  const DataExplorerFrontState({
    this.status = DataExplorerFrontStatus.initial,
    this.errorMessage = ""});

  @override
  List<Object?> get props => [status, errorMessage];
  DataExplorerFrontState copyWith({DataExplorerFrontStatus? status, String? errorMessage}){
    return DataExplorerFrontState(status: status?? this.status, errorMessage: errorMessage?? this.errorMessage);
  }
}