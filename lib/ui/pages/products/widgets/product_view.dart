import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/product.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/abc_value_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/products_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/selected_product_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/write_mode_state_provider.dart';
import 'package:grocery_web_admin/utils/labels.dart';

class ProductView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = watch(abcValueProvider);

    final selectedProduct = watch(selectedProductProvider);
    final productsAsync = watch(productsProvider(model.state));
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
            children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text(product.name),
                    trailing: IconButton(
                      onPressed: () {
                        context.read(writeModeStateProvider).state = true;
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: product.images
                        .map(
                          (e) => Image(
                            image: NetworkImage(e),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(product.description),
                  ),
                ] +
                product.options
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  Labels.rupee + e.price.toString(),
                                  style: style.headline6!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  Labels.rupee + e.salePrice.toString(),
                                  style: style.headline6,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  e.amount + " " + e.unit,
                                  style: style.headline6,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
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
