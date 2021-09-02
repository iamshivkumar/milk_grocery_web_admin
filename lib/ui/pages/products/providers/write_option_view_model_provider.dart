import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/option.dart';
import 'package:grocery_web_admin/core/models/write_option_param.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/write_product_view_model_provider.dart';

final writeSlabViewModelProvider =
    ChangeNotifierProvider.family<WriteSlabViewModel, WriteOptionParam>(
  (ref, param) => WriteSlabViewModel(
    list: param.list,
    prevOption: param.prevOption,
    ref: ref,
  ),
);

class WriteSlabViewModel extends ChangeNotifier {
  final Option? prevOption;
  final List<Option> list;
  final ProviderReference ref;

  WriteSlabViewModel({
    this.prevOption,
    required this.list,
    required this.ref,
  });

  Option? _option;
  Option get option => _option??prevOption??Option.empty();
  set option(Option option) {
    _option = option;
    notifyListeners();
  }


  Repository get repository => ref.read(repositoryProvider);

  void write() {
    if (prevOption != null) {
      list.remove(prevOption);
    }
    list.add(option);
    ref.read(writeProductViewModelProivider).setOptions(list);
  }
}
