
import 'package:equatable/equatable.dart';

class BannerModel {
  final String category;
  final String image;
  BannerModel({
    required this.category,
    required this.image,
  });

  BannerModel copyWith({
    String? category,
    String? image,
  }) {
    return BannerModel(
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'image': image,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      category: map['category'],
      image: map['image'],
    );
  }
}

class WriteBannerParam extends Equatable {
  final BannerModel? prev;
  final List<BannerModel> list;

  WriteBannerParam({ this.prev, required this.list});

  @override
  List<Object?> get props => [prev,list];
}