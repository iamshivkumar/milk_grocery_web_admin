import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';

final customersViewModelProvider =
    ChangeNotifierProvider((ref) => CustomersViewModel());

class CustomersViewModel extends ChangeNotifier {
  
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

  String _mobile = '';
  String get mobile => _mobile;
  set mobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }

  String _number = '';
  String get number => _number;
  set number(String number) {
    _number = number;
    notifyListeners();
  }

}
