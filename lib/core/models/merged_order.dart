import 'package:grocery_web_admin/utils/labels.dart';

import 'order.dart';
import 'subscription.dart';

class MergedOrder {
  final String customerName;
  final String area;
  final String address;
  final String total;
  final List<PdfProduct> products;
  final String status;
  final String walletAmount;
  final String price;
  final String label;

  MergedOrder({
    required this.customerName,
    required this.area,
    required this.address,
    required this.total,
    required this.products,
    required this.status,
    required this.walletAmount,
    required this.label,
    required this.price,
  });

  factory MergedOrder.fromOrder(Order order) => MergedOrder(
      address: "${order.address.number} ${order.address.landMark}",
      area: order.address.area,
      customerName: order.customerName,
      products: order.products
          .map(
            (e) => PdfProduct(
              name: "${e.name} (${e.amountLabel})",
              price: e.priceLabel,
              quantity: e.qt.toString(),
            ),
          )
          .toList(),
      price: "${Labels.rupee}${order.price.toInt()}",
      total: "${Labels.rupee}${order.total.toInt()}",
      status: order.status,
      label: "Order",
      walletAmount: "${Labels.rupee}${order.walletAmount.toInt()}");

  factory MergedOrder.fromSubscription(
      {required Subscription subscription, required DateTime date}) {
    final delivery =
        subscription.deliveries.where((element) => element.date == date).first;

    return MergedOrder(
      address:
          "${subscription.address.number} ${subscription.address.landMark}",
      area: subscription.address.area,
      customerName: subscription.customerName,
      products: [
        PdfProduct(
          name:
              "${subscription.productName} (${subscription.option.amountLabel})",
          price: subscription.option.salePriceLabel,
          quantity: delivery.quantity.toString(),
        ),
      ],
      total: "---",
      status: delivery.status,
      label: "Subscription",
      price: "${(subscription.option.salePrice * delivery.quantity).toInt()}",
      walletAmount:
          "${(subscription.option.salePrice * delivery.quantity).toInt()}",
    );
  }
}

class PdfProduct {
  final String name;
  final String price;
  final String quantity;

  PdfProduct({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
