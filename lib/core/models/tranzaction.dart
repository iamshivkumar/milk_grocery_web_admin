import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_web_admin/utils/labels.dart';

class Tranzaction {
  final String id;
  final double amount;
  final String name;
  final String uid;
  final DateTime createdAt;
  final String type;
  final String? paymentId;

  Tranzaction({
    required this.amount,
    required this.name,
    required this.uid,
    required this.createdAt,
    required this.id,
    required this.type,
    required this.paymentId,
  });

  String get amountLabel => "${Labels.rupee}$amount";

  Tranzaction copyWith({
    double? amount,
    String? name,
    String? uid,
    DateTime? createdAt,
    String? type,
    String? paymentId,
  }) {
    return Tranzaction(
      amount: amount ?? this.amount,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      id: this.id,
      paymentId: paymentId??this.paymentId,
      type: type??this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'name': name,
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentId':paymentId,
      'type':type,
    };
  }

  factory Tranzaction.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Tranzaction(
      amount: map['amount'],
      name: map['name'],
      uid: map['uid'],
      createdAt: map['createdAt'].toDate(),
      id: doc.id,
      paymentId: map['paymentId'],
      type: map['type'],
    );
  }
}

class TranzactionType {
  static String get whileOrdering => "While ordering";
  static String get whileWalletRecharge => "While wallet recharge";
}
