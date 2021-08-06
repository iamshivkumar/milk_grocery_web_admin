
import 'package:grocery_web_admin/utils/utils.dart';

class Option {
  final String amount;
  final double price;
  final double salePrice;
  final String unit;
  Option({
    required this.amount,
    required this.price,
    required this.salePrice,
    required this.unit,
  });

  Option copyWith({
    String? amount,
    double? price,
    double? salePrice,
    String? unit,
  }) {
    return Option(
      amount: amount ?? this.amount,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'price': price,
      'salePrice': salePrice,
      'unit': unit,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      amount: map['amount'],
      price: map['price'],
      salePrice: map['salePrice'],
      unit: map['unit'],
    );
  }
    factory Option.empty() {
    return Option(
      amount: '',
      price: 0,
      salePrice: 0,
      unit: Utils.units.first,
    );
  }
}
