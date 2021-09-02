import 'package:equatable/equatable.dart';
import 'package:grocery_web_admin/core/models/option.dart';


class WriteOptionParam extends Equatable {
  final Option? prevOption;
  final List<Option> list;

  WriteOptionParam({ this.prevOption, required this.list});

  @override
  List<Object?> get props => [prevOption,list];
}