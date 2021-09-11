import 'package:equatable/equatable.dart';

class RangeParam extends Equatable{
  final DateTime start;
  final DateTime end;

  RangeParam(this.start, this.end);

  @override

  List<Object?> get props => [start,end];
}