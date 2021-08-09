import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/selected_product_provider.dart';

final writeMilkManViewModelProvider =
    ChangeNotifierProvider<WriteMilkManViewModel>(
        (ref) => WriteMilkManViewModel(ref));

class WriteMilkManViewModel extends ChangeNotifier {
  final ProviderReference _ref;

  WriteMilkManViewModel(this._ref);

  MilkMan get _milkMan =>
      _ref.read(selectedMilkManProvider).state ?? MilkMan.empty();
  Repository get _repository => _ref.read(repositoryProvider);

  bool get forEdit => _milkMan.id.isNotEmpty;

  String? _name;
  String get name => _name ?? _milkMan.name;
  set name(String name) {
    _name = name;
  }

  String? _mobile;
  String get mobile => _mobile ?? _milkMan.mobile;
  set mobile(String mobile) {
    _mobile = mobile;
  }

  String areaName = '';
  String cityName = '';

  String get area => areaName + ", " + cityName;

  List<String> _areas = [];
  List<String> _removedAreas = [];
  List<String> get areas => (_areas + _milkMan.areas)
      .where((element) => !_removedAreas.contains(element))
      .toList();

  void removeArea(String option) {
    if (_areas.contains(option)) {
      _areas.remove(option);
    } else {
      _removedAreas.add(option);
    }
    notifyListeners();
  }

  void addArea() {
    if (!areas.contains(area)) {
      _areas.add(area);
    }
    areaName = '';
    cityName = '';
    notifyListeners();
  }

  void writeMilkMan() {
    _repository.writeMilkMan(
        milkMan: _milkMan.copyWith(
      areas: areas,
      mobile: mobile,
      name: name,
    ));
    clear();
    notifyListeners();
  }

  void clear() {
    _ref.read(selectedMilkManProvider).state = null;
    _name = null;
    _mobile = null;
    _areas = [];
    _removedAreas = [];
  }
}
