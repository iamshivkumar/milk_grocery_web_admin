import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_web_admin/utils/utils.dart';

class Product {
  final String id;
  final String name;
  final String amount;
  final String unit;
  final double price;
  final List<String> images;
  final String description;
  final String? category;
  final bool active;
  final bool popular;

  Product({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.price,
    required this.images,
    required this.description,
    required this.active,
    required this.category,
    required this.popular,
  });

  Product copyWith({
    String? id,
    String? name,
    String? amount,
    String? unit,
    double? price,
    List<String>? images,
    String? description,
    String? category,
    bool? active,
    bool? popular,
  }) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        price: price ?? this.price,
        images: images ?? this.images,
        description: description ?? this.description,
        active: active ?? this.active,
        category: category ?? this.category,
        popular: popular ?? this.popular);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'images': images,
      'description': description,
      'amount': amount,
      'unit': unit,
      'category': category,
      'active': active,
      'popular': popular,
    };
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: map['name'],
      price: map['price'],
      images: List<String>.from(map['images']),
      description: map['description'],
      amount: map['amount'],
      unit: map['unit'],
      active: map['active'],
      category: map['category'],
      popular: map['popular'],
    );
  }

  factory Product.empty() => Product(
      id: '',
      name: '',
      price: 0.0,
      images: [],
      description: '',
      amount: '',
      unit: Utils.units.first,
      active: true,
      category: null,
      popular: false);
}
