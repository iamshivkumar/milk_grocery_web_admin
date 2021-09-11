import 'package:grocery_web_admin/core/models/tranz_params.dart';
import 'package:grocery_web_admin/core/models/tranzaction.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tranzactionsProvider = FutureProvider.family<List<Tranzactions>, RangeParam>(
  (ref, date) => ref.read(repositoryProvider).tranzactionsFuture(date),
);
