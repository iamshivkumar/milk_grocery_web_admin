import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/customer.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final customersProivder = StreamProvider.family<List<Customer>, Params>(
  (ref, params) => ref.read(repositoryProvider).customersStream(params),
);
