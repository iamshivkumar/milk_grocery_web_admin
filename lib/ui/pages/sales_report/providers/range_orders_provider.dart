import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/models/tranz_params.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rangeOrdersProvider = StreamProvider.family<List<Order>, RangeParam>(
  (ref, params) => ref.read(repositoryProvider).rangeOrders(params),
);
