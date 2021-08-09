import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/banner.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final bannersProvider = StreamProvider<List<BannerModel>>((ref)=>ref.read(repositoryProvider).streamBanners);