
import 'package:grocery_web_admin/utils/labels.dart';

class OrderProduct {
  final String id;
  final String name;
  final String image;
  final double price;
  final String amount;
  final int qt;
  final String unit;
  final bool isMilky;
  OrderProduct({
    required this.id,
    required this.qt,
    required this.image,
    required this.name,
    required this.price,
    required this.amount,
    required this.unit,
    required this.isMilky,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> data) {
    return OrderProduct(
      amount: data['amount'],
      id: data['id'],
      image: data['image'],
      name: data['name'],
      price: data['price'],
      qt: data['qt'],
      unit: data['unit'],
      isMilky: data['isMilky'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qt': qt,
      'image': image,
      'name': name,
      'price': price,
      'amount': amount,
      'unit': unit,
      'isMilky': isMilky,
    };
  }

  String get priceLabel => "${Labels.rupee}${price.toInt().toString()}";
  String get amountLabel => "$amount $unit";
}
