import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/models/tranz_params.dart';
import 'package:grocery_web_admin/ui/pages/sales_report/providers/range_orders_provider.dart';
import 'package:grocery_web_admin/ui/pages/tranzactions/providers/date_provider.dart';
import 'package:grocery_web_admin/ui/pages/tranzactions/widgets/range_filterer.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/generator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/product_report_card.dart';

class SalesReportPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dateRange = watch(dateRangeProvider);
    final ordersStream = watch(
      rangeOrdersProvider(
        RangeParam(dateRange.start, dateRange.end),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RangleFilterer(dateRange: dateRange),
          Expanded(
            child: SizedBox(
              width: 400,
              child: ordersStream.when(
                data: (orders) => ListView(
                  children: Generator.reportProducts(orders: orders)
                      .map(
                        (e) => ProductReportCard(product: e),
                      )
                      .toList(),
                ),
                loading: () => Loading(),
                error: (e, s) => Text(
                  e.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
