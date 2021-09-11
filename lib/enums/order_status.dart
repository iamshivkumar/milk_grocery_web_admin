class OrderStatus {
  static const String pending = "Pending";
  static const String delivered = "Delivered";
  static const String cancelled = "Cancelled";
  static const String returned = "Returned";
  static const String requestedForRefund = "Requested for refund";
  
  static const List<String> values = [
    pending,
    delivered,
    cancelled,
    returned,
    requestedForRefund,
  ];
}
