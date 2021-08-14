import 'package:cloud_firestore/cloud_firestore.dart';


import 'delivery.dart';
import 'delivery_address.dart';
import 'option.dart';

class Subscription {
  final String id;
  final String customerId;
  final String customerName;
  final String customerMobile;

  final String productId;
  final String productName;
  final String image;
  final Option option;
  final DateTime startDate;
  final DateTime endDate;
  final String deliveryDay;
  final String milkManId;
  final DeliveryAddress address;
  final List<Delivery> deliveries;

  Subscription({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.productId,
    required this.productName,
    required this.option,
    required this.startDate,
    required this.endDate,
    required this.deliveryDay,
    // required this.dates,
    required this.deliveries,
    required this.milkManId,
    required this.image,
    required this.address,
  });

  Subscription copyWith({
    String? customerId,
    String? productId,
    String? productName,
    Option? option,
    DateTime? startDate,
    DateTime? endDate,
    String? deliveryDay,
    String? milkManId,
    List<DateTime>? dates,
    List<Delivery>? deliveries,
    String? customerName,
    String? customerMobile,
    String? image,
    DeliveryAddress? address,
  }) {
    return Subscription(
      id: this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      option: option ?? this.option,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deliveryDay: deliveryDay ?? this.deliveryDay,
      // dates: dates ?? this.dates,
      deliveries: deliveries ?? this.deliveries,
      milkManId: milkManId ?? this.milkManId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      image: image ?? this.image,
      address: address??this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerMobile': customerMobile,
      'productId': productId,
      'productName': productName,
      'option': option.toMap(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'deliveryDay': deliveryDay,
      // 'dates': dates.map((e) => Timestamp.fromDate(e)).toList(),
      'deliveries': deliveries.map((e) => e.toMap()).toList(),
      'image': image,
      'milkManId': milkManId,
      'address':address.toMap()
    };
  }

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final Iterable deliveriesData = map['deliveries'];
    return Subscription(
      customerName: map['customerName'],
      customerMobile: map['customerMobile'],
      id: doc.id,
      customerId: map['customerId'],
      productId: map['productId'],
      productName: map['productName'],
      option: Option.fromMap(map['option']),
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      deliveryDay: map['deliveryDay'],
      // dates: datesData.map((e) => e.toDate()).toList(),
      deliveries: deliveriesData
          .map((e) => Delivery.fromMap(e as Map<String, dynamic>))
          .toList(),
      milkManId: map['milkManId'],
      image: map['image'],
      address: DeliveryAddress.fromMap(map['address'])
    );
  }


}

class DeliveryDay {
  static const String everyday = "Everyday";
  static const String alternateDay = "Alternate Day";
  static const String every3Day = "Every 3 Day";
  static const String every7Day = "Every 7 Day";

  static const List<String> values = [
    everyday,
    alternateDay,
    every3Day,
    every7Day
  ];

  static int interval(String day) {
    switch (day) {
      case everyday:
        return 1;
      case alternateDay:
        return 2;
      case every3Day:
        return 3;
      case every7Day:
        return 7;
      default:
        return 1;
    }
  }
}
