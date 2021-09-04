import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final noticesProvider = StreamProvider<List<String>>((ref)=>ref.read(repositoryProvider).lowStockNoticesStream);