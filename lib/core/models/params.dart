import 'package:equatable/equatable.dart';

class Params extends Equatable {
  final String milkManId;
  final String area;

  Params({required this.milkManId, required this.area});

  @override
  List<Object?> get props => [milkManId, area];
}
