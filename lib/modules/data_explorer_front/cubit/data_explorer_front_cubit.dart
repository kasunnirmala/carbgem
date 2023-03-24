import 'package:authentication_repository/authentication_repository.dart';
import 'package:bitte_api/bitte_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'data_explorer_front_state.dart';
class DataExplorerFrontCubit extends Cubit<DataExplorerFrontState>{
  final AuthenticationRepository _authenticationRepository;
  final BitteApiClient _bitteApiClient;

  DataExplorerFrontCubit(this._authenticationRepository, this._bitteApiClient): super(DataExplorerFrontState());

}