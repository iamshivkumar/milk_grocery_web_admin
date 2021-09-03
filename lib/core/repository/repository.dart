// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/banner.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/models/charge.dart';
import 'package:grocery_web_admin/core/models/customer.dart';
import 'package:grocery_web_admin/core/models/master_data.dart';
import 'package:grocery_web_admin/core/models/offer.dart';
import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/models/params_with_date.dart';
import 'package:grocery_web_admin/core/models/product.dart';
import 'package:grocery_web_admin/core/models/subscription.dart';
import 'package:grocery_web_admin/utils/dates.dart';

final repositoryProvider = Provider((ref) => Repository(ref));

class Repository {
  final ProviderReference ref;
  Repository(this.ref);

  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> writeProduct(
      {required Product product,
      required List<String> images,
      required Map<String, File> map,
      String? prevName}) async {
    for (var image in images) {
      product.images.add(await _uploadImage(map[image] as File));
    }
    var data = product.toMap();
    data['keys'] = _keys(product.name);
    if (product.id.isEmpty) {
      await _firestore.collection('products').add(data);
      _firestore.collection('search_keys').doc('search_keys').update({
        'keys': FieldValue.arrayUnion([product.name])
      });
    } else {
      await _firestore.collection('products').doc(product.id).update(data);
      if (prevName != null) {
        _firestore.collection('search_keys').doc('search_keys').update({
          'keys': FieldValue.arrayUnion([product.name])
        });
        _firestore.collection('search_keys').doc('search_keys').update({
          'keys': FieldValue.arrayRemove([prevName])
        });
      }
    }
  }

  void deleteProduct(String id) {
    _firestore.collection("products").doc(id).delete();
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

  void removeCategory({required ProductCategory category}) {
    _firestore.collection('categories').doc('categories').update(
      {
        "categories": FieldValue.arrayRemove([category.toMap()]),
      },
    );
  }

  void removeBanner({required BannerModel category}) {
    _firestore.collection('banners').doc('banners').update(
      {
        "banners": FieldValue.arrayRemove([category.toMap()]),
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

  Future<void> addBanner({
    required BannerModel banner,
    required List<BannerModel> banners,
    File? file,
  }) async {
    String? image;
    if (file != null) {
      image = await _uploadImage(file);
    }
    banners.add(banner.copyWith(image: image));
    await _firestore.collection('banners').doc('banners').update(
      {"banners": banners.map((e) => e.toMap()).toList()},
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

  Stream<List<BannerModel>> get streamBanners {
    return _firestore
        .collection('banners')
        .doc('banners')
        .snapshots()
        .map((event) {
      final Iterable list = event.data()!['banners'];
      return list.map((e) => BannerModel.fromMap(e)).toList();
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

  Future<void> writeMilkMan({required MilkMan milkMan}) async {
    if (milkMan.id.isEmpty) {
      await _firestore.collection('milkMans').add(milkMan.toMap());
    } else {
      await _firestore
          .collection('milkMans')
          .doc(milkMan.id)
          .update(milkMan.toMap());
    }
  }

  Stream<List<MilkMan>> get streamMilkMans {
    return _firestore
        .collection('milkMans')
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => MilkMan.fromFirestore(e),
            )
            .toList());
  }

  void delete({required String id}) {
    _firestore.collection('milkMans').doc(id).delete();
  }

  Stream<List<Customer>> customersStream(Params params) {
    return _firestore
        .collection('users')
        .where('milkManId', isEqualTo: params.milkManId)
        .where('area', isEqualTo: params.area)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Customer.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Subscription>> subscriptionsStream(Params params) {
    return _firestore
        .collection('subscription')
        .where('milkManId', isEqualTo: params.milkManId)
        .where('address.area', isEqualTo: params.area)
        .where(
          'startDate',
          isGreaterThanOrEqualTo: Dates.today.subtract(
            Duration(days: 30),
          ),
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Subscription.fromFirestore(e),
              )
              .toList(),
        );
  }

  Stream<List<Order>> ordersStream(ParamsWithDate params) {
    final date = params.dateTime.subtract(Duration(days: 1));
    return _firestore
        .collection('orders')
        .where('milkManId', isEqualTo: params.milkManId)
        .where('address.area', isEqualTo: params.area)
        .where(
          'createdOn',
          isGreaterThanOrEqualTo: date,
          isLessThanOrEqualTo: date.add(
            Duration(hours: 23, minutes: 59),
          ),
        )
        .snapshots()
        .map(
      (event) {
        print(event.docs);
        return event.docs
            .map(
              (e) => Order.fromFirestore(e),
            )
            .toList();
      },
    );
  }

  void areaAcceptReject(
      {required String id, required String area, required bool accept}) {
    final batch = _firestore.batch();
    batch.update(_firestore.collection('milkMans').doc(id), {
      'pendingAreas': FieldValue.arrayRemove([area]),
    });
    if (accept) {
      batch.update(_firestore.collection('milkMans').doc(id), {
        'areas': FieldValue.arrayUnion([area]),
      });
    } else {
      batch.update(_firestore.collection('milkMans').doc(id), {
        'rejectedAreas': FieldValue.arrayUnion([area]),
      });
    }
    batch.commit();
  }

  void editWalletAmount(
      {required double amount, required String id, required bool isMilkMan}) {
    final batch = _firestore.batch();
    batch.update(
        _firestore.collection(isMilkMan ? "milkMans" : "users").doc(id), {
      "walletAmount": FieldValue.increment(amount),
    });
    batch.set(
      _firestore.collection('charges').doc(),
      Charge(
        amount: amount,
        from: null,
        to: id,
        ids: [id],
        type: ChargesType.byAdmin,
        createdAt: DateTime.now(),
      ).toMap(),
    );
    batch.commit();
  }

  Stream<Masterdata> get masterdataStream =>
      _firestore.collection('masterData').doc('masterData_v1').snapshots().map(
            (event) => Masterdata.fromMap(event),
          );

  void writeOffer(List<Offer> offers){
    _firestore.collection('masterData').doc('masterData_v1').update({
      "offers": offers.map((e) => e.toMap()).toList()
    });
  }

  void updateStatus(bool value){
    _firestore.collection('masterData').doc('masterData_v1').update({
      "active": value,
    });
  }
}
