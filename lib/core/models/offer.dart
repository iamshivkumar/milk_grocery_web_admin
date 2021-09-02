
class Offer {
  final double amount;
  final double percentage;

  Offer({
    required this.amount,
    required this.percentage,
  });

  Offer copyWith({
    double? amount,
    double? percentage,
  }) {
    return Offer(
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'percentage': percentage,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      amount: map['amount'],
      percentage: map['percentage'],
    );
  }

    factory Offer.empty() {
    return Offer(
      amount: 0,
      percentage: 0,
    );
  }
}
