import 'package:equatable/equatable.dart';

class CountryAPI extends Equatable{
  final String countryName;
  final String countryId;

  const CountryAPI({required this.countryName, required this.countryId});

  @override
  // TODO: implement props
  List<Object?> get props => [countryName, countryId];
  static const empty = CountryAPI(countryName: "", countryId: "");
}