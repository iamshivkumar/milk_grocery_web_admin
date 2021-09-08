import 'package:equatable/equatable.dart';

class TranzParam extends Equatable{
  final DateTime start;
  final DateTime end;

  TranzParam(this.start, this.end);

  @override

  List<Object?> get props => [start,end];
}