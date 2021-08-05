import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final categoriesProvider = StreamProvider<List<ProductCategory>>((ref)=>ref.read(repositoryProvider).streamCategories);