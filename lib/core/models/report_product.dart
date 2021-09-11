class ReportProduct {
  final String name;
  final String image;
  final List<ReportSubProduct> subproducts;

  ReportProduct({
    required this.name,
    required this.image,
    required this.subproducts,
  });
}

class ReportSubProduct {
  final String amount;
  int deliveredCount;
  int pendingCount;

  ReportSubProduct({
    required this.amount,
    required this.deliveredCount,
    required this.pendingCount,
  });

  void pendingIncrement(int count) {
    pendingCount = pendingCount + count;
  }

  void deliveredIncrement(int count) {
    deliveredCount = deliveredCount + count;
  }
}
