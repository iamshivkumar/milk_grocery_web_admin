// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/banner.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final writeBannerViewModelProvider =
    ChangeNotifierProvider.family<WriteBannerViewModel, WriteBannerParam>(
  (ref, param) => WriteBannerViewModel(
    list: param.list,
    prev: param.prev,
    ref: ref,
  ),
);

class WriteBannerViewModel extends ChangeNotifier {
  final BannerModel? prev;
  final List<BannerModel> list;

  final ProviderReference ref;

  WriteBannerViewModel({this.prev, required this.list, required this.ref});

  Repository get repository => ref.read(repositoryProvider);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String? _category;
  String? get category => _category ?? prev?.category;
  set category(String? category) {
    _category = category;
  }

  String? _image;
  String? get image => _image ?? prev?.image;
  set image(String? image) {
    _image = image;
  }

  File? _file;

  void write() async {
    loading = true;
    if (image == null) {
      return;
    }
    if (prev != null) {
      list.remove(prev);
    }
    try {
      await repository.addBanner(
          banner: BannerModel(category: category!, image: image!),
          file: _file,
          banners: list);
    } catch (e) {}
    loading = false;
  }

  Future<void> pickImage() async {
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      _file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(_file!);
      reader.onLoadEnd.listen((event) {
        image = reader.result as String;
        notifyListeners();
      });
    });
  }
}
