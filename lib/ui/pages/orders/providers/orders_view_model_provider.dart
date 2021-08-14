import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/utils/dates.dart';

final ordersViewModelProvider =
    ChangeNotifierProvider((ref) => OrdersViewModel());

class OrdersViewModel extends ChangeNotifier {
  
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

  DateTime _dateTime = Dates.today;
  DateTime get dateTime => _dateTime;
  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

}
