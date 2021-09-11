import 'package:flutter/foundation.dart';
import 'package:grocery_web_admin/utils/dates.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dateRangeProvider =
    ChangeNotifierProvider.autoDispose<DateRange>((ref) => DateRange());

class DateRange extends ChangeNotifier {
  DateTime _start = Dates.today;
  DateTime get start => _start;
  set start(DateTime start) {
    _start = start;
    notifyListeners();
  }

  DateTime _end = Dates.today;
  DateTime get end => _end;
  set end(DateTime end) {
    _end = end;
    notifyListeners();
  }
}
