// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/models/product.dart';

final repositoryProvider = Provider((ref) => Repository(ref));

class Repository {
  final ProviderReference ref;
  Repository(this.ref);

  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> writeProduct(
      {required Product product,
      required List<String> images,
      required Map<String, File> map}) async {
    for (var image in images) {
      product.images.add(await _uploadImage(map[image] as File));
    }
    var data = product.toMap();
    data['keys'] = _keys(product.name);
    if (product.id.isEmpty) {
      await _firestore.collection('products').add(data);
    } else {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(data);
    }
  }

  Future<String> _uploadImage(File file) async {
    return await (await _storage.ref(DateTime.now().toString()).putBlob(file))
        .ref
        .getDownloadURL();
  }

  Future<bool> checkAdminExist(String email) async {
    return _firestore
        .collection('admins')
        .where("email", isEqualTo: email)
        .get()
        .then((value) => value.docs.isNotEmpty);
  }

  void removeCategory({required List<ProductCategory> list}) {
    _firestore.collection('categories').doc('categories').update(
      {
        "categories": FieldValue.arrayRemove(
          list.map((e) => e.toMap()).toList(),
        ),
      },
    );
  }

  Future<void> addCategory({
    required ProductCategory category,
    required List<ProductCategory> categories,
    File? file,
  }) async {
    String? image;
    if (file != null) {
      image = await _uploadImage(file);
    }
    categories.add(category.copyWith(image: image));
    await _firestore.collection('categories').doc('categories').update(
      {"categories": categories.map((e) => e.toMap()).toList()},
    );
  }

  Stream<List<ProductCategory>> get streamCategories {
    return _firestore
        .collection('categories')
        .doc('categories')
        .snapshots()
        .map((event) {
      final Iterable list = event.data()!['categories'];
      return list.map((e) => ProductCategory.fromMap(e)).toList();
    });
  }

  void updatedActive(String id, bool value) {
    _firestore.collection('products').doc(id).update({
      'active': value,
    });
  }

  void updatedPopular(String id, bool value) {
    _firestore.collection('products').doc(id).update({
      'popular': value,
    });
  }

  List<String> _keys(String name) {
    List<String> values = [];
    String initValue = "";
    for (var item in name.toLowerCase().split("")) {
      initValue = initValue + item;
      values.add(initValue);
    }
    return values;
  }
}
