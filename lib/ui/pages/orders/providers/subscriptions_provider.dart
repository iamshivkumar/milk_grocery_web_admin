import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/subscription.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final subscriptionsProivder = StreamProvider.family<List<Subscription>, Params>(
  (ref, params) => ref.read(repositoryProvider).subscriptionsStream(params),
);
