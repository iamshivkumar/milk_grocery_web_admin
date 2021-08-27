import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_web_admin/core/models/option.dart';

class Product {
  final String id;
  final String name;
  final List<Option> options;
  final List<String> images;
  final String description;
  final String? category;
  final bool active;
  final bool popular;
  final int quantity;
  final String location;
  final String barcode;

  Product({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.active,
    required this.category,
    required this.popular,
    required this.options,
    required this.quantity,
    required this.location,
    required this.barcode,
  });

  Product copyWith({
    String? id,
    String? name,
    List<String>? images,
    String? description,
    String? category,
    bool? active,
    bool? popular,
    List<Option>? options,
    int? quantity,
    String? barcode,
    String? location,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      images: images ?? this.images,
      description: description ?? this.description,
      active: active ?? this.active,
      category: category ?? this.category,
      popular: popular ?? this.popular,
      options: options ?? this.options,
      quantity: quantity ?? this.quantity,
      location: location?? this.location,
      barcode: barcode??this.barcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'images': images,
      'description': description,
      'category': category,
      'active': active,
      'popular': popular,
      'options': options.map((e) => e.toMap()).toList(),
      'quantity': quantity,
      'location':location,
      'barcode':barcode
    };
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final Iterable list = map['options'];
    return Product(
      id: doc.id,
      name: map['name'],
      images: List<String>.from(map['images']),
      description: map['description'],
      active: map['active'],
      category: map['category'],
      popular: map['popular'],
      options: list.map((e) => Option.fromMap(e)).toList(),
      quantity: map['quantity'],
      location: map['location'],
      barcode: map['barcode'],
    );
  }

  factory Product.empty() => Product(
        id: '',
        name: '',
        images: [],
        description: '',
        active: true,
        category: null,
        popular: false,
        options: [],
        quantity: 0,
        location: '',
        barcode: '',
      );
}
