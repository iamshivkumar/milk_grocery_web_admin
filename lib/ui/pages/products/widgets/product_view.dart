import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/product.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/products_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/selected_product_provider.dart';

class ProductView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final selectedProduct = watch(selectedProductProvider);
    final productsAsync = watch(productsProvider);
    return Container(
      width: 400,
      color: theme.cardColor,
      child: productsAsync.when(
        data: (products) {
          final Product product = products
              .where((element) => element.id == selectedProduct.state!.id)
              .first;
          return ListView(
            padding: EdgeInsets.all(8),
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8
                ),
                title: Text(product.name),
              ),
              
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, s) => Text(
          e.toString(),
        ),
      ),
    );
  }
}
