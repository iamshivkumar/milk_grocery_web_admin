import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/models/params_with_date.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final ordersProvider = StreamProvider.family<List<Order>, ParamsWithDate>(
  (ref, params) => ref.read(repositoryProvider).ordersStream(params),
);
