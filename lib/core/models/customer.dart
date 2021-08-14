import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String mobile;
  final String? area;
  final String? number;
  final String? landMark;
  final String? milkManId;
  final double walletAmount;

  Customer({
    required this.id,
    required this.name,
    required this.mobile,
    this.area,
    this.number,
    this.milkManId,
    required this.walletAmount,
    this.landMark,
  });

  bool get ready => area != null && number != null && milkManId != null;

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Customer(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      milkManId: map['milkManId'],
      area: map['area'],
      number: map['number'],
      walletAmount: map['walletAmount'],
      landMark: map['landMark'],
    );
  }
}
