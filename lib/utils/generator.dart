import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/models/report_product.dart';
import 'package:grocery_web_admin/core/models/subscription.dart';
import 'package:grocery_web_admin/enums/order_status.dart';

class Generator {
  static List<ReportProduct> reportProducts({
    // required List<Subscription> subscriptions,
    required List<Order> orders,
  }) {
    final List<ReportProduct> list = [];
    for (var order in orders) {
      for (var product in order.products.where((element) => !element.isMilky)) {
        final bool isPending = order.status == OrderStatus.pending;
        final bool isDelivered = order.status == OrderStatus.delivered;
        final sublist = list.where((element) => element.name == product.name);
        if (sublist.isNotEmpty) {
          var subSubList = sublist.first.subproducts
              .where((element) => element.amount == product.amountLabel);
          if (subSubList.isNotEmpty) {
            if (isPending) {
              list
                  .where((element) => element.name == product.name)
                  .first
                  .subproducts
                  .where((element) => element.amount == product.amountLabel)
                  .first
                  .pendingIncrement(product.qt);
            } else {
              list
                  .where((element) => element.name == product.name)
                  .first
                  .subproducts
                  .where((element) => element.amount == product.amountLabel)
                  .first
                  .deliveredIncrement(product.qt);
            }
          } else {
            list
                .where((element) => element.name == product.name)
                .first
                .subproducts
                .add(
                  ReportSubProduct(
                      amount: product.amountLabel,
                      deliveredCount: isDelivered ? product.qt : 0,
                      pendingCount: isPending ? product.qt : 0),
                );
          }
        } else {
          list.add(
            ReportProduct(
              name: product.name,
              image: product.image,
              subproducts: [
                ReportSubProduct(
                  amount: product.amountLabel,
                  deliveredCount: isDelivered ? product.qt : 0,
                  pendingCount: isPending ? product.qt : 0,
                ),
              ],
            ),
          );
        }
      }
    }
    // for (var subscription in subscriptions) {
    //   final delivery = subscription.deliveries
    //       .where((element) => element.date == dateTime)
    //       .first;
    //   final bool isPending = delivery.status == OrderStatus.pending;
    //   final bool isDelivered = delivery.status == OrderStatus.delivered;
    //   final sublist =
    //       list.where((element) => element.name == subscription.productName);
    //   if (sublist.isNotEmpty) {
    //     var subSubList = sublist.first.subproducts.where(
    //         (element) => element.amount == subscription.option.amountLabel);
    //     if (subSubList.isNotEmpty) {
    //       if (isPending) {
    //         list
    //             .where((element) => element.name == subscription.productName)
    //             .first
    //             .subproducts
    //             .where((element) =>
    //                 element.amount == subscription.option.amountLabel)
    //             .first
    //             .pendingIncrement(delivery.quantity);
    //       } else {
    //         list
    //             .where((element) => element.name == subscription.productName)
    //             .first
    //             .subproducts
    //             .where((element) =>
    //                 element.amount == subscription.option.amountLabel)
    //             .first
    //             .deliveredIncrement(delivery.quantity);
    //       }
    //     } else {
    //       list
    //           .where((element) => element.name == subscription.productName)
    //           .first
    //           .subproducts
    //           .add(
    //             ReportSubProduct(
    //               amount: subscription.option.amountLabel,
    //               deliveredCount: isDelivered ? delivery.quantity : 0,
    //               pendingCount: isPending ? delivery.quantity : 0,
    //             ),
    //           );
    //     }
    //   } else {
    //     list.add(
    //       ReportProduct(
    //         name: subscription.productName,
    //         image: subscription.image,
    //         subproducts: [
    //           ReportSubProduct(
    //             amount: subscription.option.amountLabel,
    //             deliveredCount: isDelivered ? delivery.quantity : 0,
    //             pendingCount: isPending ? delivery.quantity : 0,
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // }
    return list;
  }
}