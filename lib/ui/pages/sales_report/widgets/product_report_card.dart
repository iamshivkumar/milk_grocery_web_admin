import 'package:flutter/material.dart';
import '../../../../core/models/report_product.dart';

class ProductReportCard extends StatelessWidget {
  final ReportProduct product;

  const ProductReportCard({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Image.network(product.image),
                    ),
                    SizedBox(width: 8),
                    Text(
                      product.name,
                      style: style.subtitle1,
                    ),
                  ],
                ),
                SizedBox(height: 8)
              ] +
              product.subproducts
                  .map(
                    (e) => Column(
                      children: [
                        Divider(height: 0.5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.amount),
                              Text("Pending: ${e.pendingCount}"),
                              Text("Delivered : ${e.deliveredCount}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
