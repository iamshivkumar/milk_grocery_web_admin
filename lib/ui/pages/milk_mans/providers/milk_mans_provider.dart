import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final milkMansProvider = StreamProvider<List<MilkMan>>((ref) {
    return ref.read(repositoryProvider).streamMilkMans;
});