import 'package:equatable/equatable.dart';

class ParamsWithDate extends Equatable {
  final String milkManId;
  final String area;
  final DateTime dateTime;
  
  ParamsWithDate({
    required this.milkManId,
    required this.area,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [dateTime, milkManId, area];
}
