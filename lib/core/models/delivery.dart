import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  final DateTime date;
  int quantity;
  String status;
  Delivery({
    required this.date,
    required this.quantity,
    required this.status,
  });

  Delivery copyWith({
    DateTime? date,
    int? quantity,
    String? status,
  }) {
    return Delivery(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'quantity': quantity,
      'status': status,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      date: map['date'].toDate(),
      quantity: map['quantity'],
      status: map['status'],
    );
  }
}



