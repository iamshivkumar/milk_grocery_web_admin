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

  Product({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.active,
    required this.category,
    required this.popular,
    required this.options,
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
      'options': options.map((e) => e.toMap()).toList()
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
      );
}
