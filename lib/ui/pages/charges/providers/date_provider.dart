import 'package:grocery_web_admin/utils/dates.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dateProvider = StateProvider.autoDispose<DateTime>((ref) => Dates.today);
