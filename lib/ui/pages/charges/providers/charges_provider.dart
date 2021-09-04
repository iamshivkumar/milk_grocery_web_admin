import 'package:grocery_web_admin/core/models/charge.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chargesProvider = FutureProvider.family<List<Charge>, DateTime>(
  (ref, date) => ref.read(repositoryProvider).chargesFuture(date),
);
