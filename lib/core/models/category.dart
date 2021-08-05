import 'package:equatable/equatable.dart';

class ProductCategory {
  final String name;
  final String image;
  ProductCategory({
    required this.name,
    required this.image,
  });

  ProductCategory copyWith({
    String? name,
    String? image,
  }) {
    return ProductCategory(
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      name: map['name'],
      image: map['image'],
    );
  }
}




class WriteCategoryParam extends Equatable {
  final ProductCategory? prev;
  final List<ProductCategory> list;

  WriteCategoryParam({ this.prev, required this.list});

  @override
  List<Object?> get props => [prev,list];
}