import 'package:cloud_firestore/cloud_firestore.dart';

class Charge {
  final double amount;
  final String? from;
  final String? to;
  final List<String> ids;
  final String type;
  final DateTime createdAt;

  Charge({
    required this.amount,
    required this.from,
    required this.to,
    required this.ids,
    required this.type,
    required this.createdAt,
  });

  Charge copyWith({
    double? amount,
    String? from,
    String? to,
    List<String>? ids,
    String? type,
    DateTime? createdAt,
  }) {
    return Charge(
      amount: amount ?? this.amount,
      from: from ?? this.from,
      to: to ?? this.to,
      ids: ids ?? this.ids,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'from': from,
      'to': to,
      'ids': ids,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Charge.fromFirestore( DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Charge(
      amount: map['amount'],
      from: map['from'],
      to: map['to'],
      ids: List<String>.from(map['ids']),
      type: map['type'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}

class ChargesType {
  static String get byAdmin => "By admin"; 
  static String get whileDeliverSubscriptionOrder => "While deliver subscription order";
  static String get whileDeliverOrder => "While deliver subscription order";
  static String get whileReturnSubscriptionOrder => "While return order";
  static String get whileReturnOrder => "While return order";
  static String get whileCancelOrder => "While cancel order";
  static String get whileAddWalletAmount => "While add wallet amount";
}
