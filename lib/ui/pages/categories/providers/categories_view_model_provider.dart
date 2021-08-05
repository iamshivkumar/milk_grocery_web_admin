import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final categoriesViewModelProvider = ChangeNotifierProvider<PartnerViewModel>(
  (ref) => PartnerViewModel(ref),
);

class PartnerViewModel extends ChangeNotifier {
  final ProviderReference ref;
  PartnerViewModel(this.ref);

  Repository get repository => ref.read(repositoryProvider);

  List<ProductCategory> selectedCategories = [];

  void onSelecteChanged(ProductCategory category, bool value) {
    if (value) {
      selectedCategories.add(category);
    } else {
      selectedCategories.remove(category);
    }
    notifyListeners();
  }

  void onSelectAll(List<ProductCategory> categories, bool vlaue) {
    if (vlaue) {
      for (var category in categories) {
        if (!selectedCategories.contains(category)) {
          selectedCategories.add(category);
        }
      }
    } else {
      for (var category in categories) {
        if (selectedCategories.contains(category)) {
          selectedCategories.remove(category);
        }
      }
    }
    notifyListeners();
  }

  void deleteSlabs() {
    repository.removeCategory(list: selectedCategories);
    selectedCategories.clear();
    notifyListeners();
  }
}
