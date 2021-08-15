import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product.dart';

final productsProvider = StreamProvider.family<List<Product>,String>((ref,key) {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore.collection('products').where('keys',arrayContains: key.toLowerCase()).snapshots().map(
        (event) => event.docs.map((e) => Product.fromFirestore(e)).toList(),
      );
});
