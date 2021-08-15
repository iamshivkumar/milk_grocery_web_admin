import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';

final subscriptionsViewModelProvider =
    ChangeNotifierProvider((ref) => SubscriptionsViewModel());

class SubscriptionsViewModel extends ChangeNotifier {
  
  MilkMan? _milkMan;

  MilkMan? get milkMan => _milkMan;
  set milkMan(MilkMan? milkMan) {
    _milkMan = milkMan;
    _area =null;
    notifyListeners();
  }

  List<String>? get  areas => milkMan?.areas;

  String? _area;
  String? get area => _area;
  set area(String? area) {
    _area = area;
    notifyListeners();
  }

}
