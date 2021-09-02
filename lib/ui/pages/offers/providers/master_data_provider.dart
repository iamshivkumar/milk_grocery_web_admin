import 'package:grocery_web_admin/core/models/master_data.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterdataProvider = StreamProvider<Masterdata>((ref)=>ref.read(repositoryProvider).masterdataStream);