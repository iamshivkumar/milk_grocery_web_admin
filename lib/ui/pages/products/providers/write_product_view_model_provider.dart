// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/product.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/selected_product_provider.dart';
import 'package:grocery_web_admin/utils/utils.dart';

final writeProductViewModelProivider =
    ChangeNotifierProvider.autoDispose<WriteProductViewModel>(
  (ref) => WriteProductViewModel(ref),
);

class WriteProductViewModel extends ChangeNotifier {
  final ProviderReference _ref;
  WriteProductViewModel(this._ref);

  bool loading = false;

  Product get _product => _ref.read(selectedProductProvider).state??Product.empty();
  Repository get _repository => _ref.read(repositoryProvider);

  bool get forEdit => _product.id.isNotEmpty;

  String? _name;
  String get name => _name ?? _product.name;
  set name(String name) {
    _name = name;
  }

  String? _amount;
  String get amount => _amount ?? _product.amount;
  set amount(String amount) {
    _amount = amount;
  }

  double? _price;
  double get price => _price ?? _product.price;
  set price(double price) {
    _price = price;
  }

  String? _description;
  String get description => _description ?? _product.description;
  set description(String description) {
    _description = description;
  }

  String _unit = Utils.units.first;
  String get unit => _unit;
  set unit(String unit) {
    _unit = unit;
    notifyListeners();
  }

  String? _category;
  String? get category => _category??_product.category;
  set category(String? category) {
    _category = category;
  }

  bool? _active;
  bool get active => _active??_product.active;
  set active(bool active) {
    _active = active;
    notifyListeners();
  }
  bool? _popular;
  bool get popular => _popular??_product.popular;
  set popular(bool popular) {
    _popular = popular;
    notifyListeners();
  }

  Future<void> writeProduct() async {
    loading = true;
    notifyListeners();
    var updated = _product.copyWith(
      name: name,
      amount: amount,
      description: description,
      price: price,
      unit: unit,
      active: active,
      category: category,
      popular: popular,
    );
    updated = updated.copyWith(
      images: _product.images
          .where((element) => !_removedImages.contains(element))
          .toList(),
    );
    try {
      await _repository.writeProduct(
        product: updated,
        images: _images,
        map: _map,
      );
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  List<String> _images = [];
  List<String> _removedImages = [];

  List<String> get images => (_product.images + _images)
      .where((element) => !_removedImages.contains(element))
      .toList();

  void removeImage(String url) {
    if (_product.images.contains(url)) {
      _removedImages.add(url);
    } else {
      _images.remove(url);
    }
    notifyListeners();
  }

  Map<String, File> _map = {};

  Future<void> pickImage() async {
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      for (var file in input.files!) {
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          _images.add(reader.result as String);
          _map[reader.result as String] = file;
          notifyListeners();
        });
      }
    });
  }

  List<String> _keys() {
    List<String> values = [];
    String initValue = "";
    for (var item in name.toLowerCase().split("")) {
      initValue = initValue + item;
      values.add(initValue);
    }
    return values;
  }
}
