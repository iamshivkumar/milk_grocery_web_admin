import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/abc_value_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/selected_product_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/widgets/abc_view.dart';
import 'package:grocery_web_admin/ui/pages/products/widgets/product_view.dart';
import 'providers/products_provider.dart';
import 'providers/write_mode_state_provider.dart';
import 'write_product_screen.dart';

class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final writeMode = watch(writeModeStateProvider);
    final model = watch(abcValueProvider);
    final productsAsync = watch(productsProvider(model.state));
    final selectedProduct = watch(selectedProductProvider);
    final repository = watch(repositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      floatingActionButton: writeMode.state || selectedProduct.state != null
          ? SizedBox()
          : FloatingActionButton.extended(
              onPressed: () {
                writeMode.state = true;
              },
              label: Text('ADD PRODUCT'),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: productsAsync.when(
              data: (products) => SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AbcView(
                        selected: model.state,
                        onSelect: (e) => model.state = e,
                      ),
                      Card(
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: [
                            DataColumn(label: Text('Index')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Images')),
                            DataColumn(label: Text('Popular')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('Active')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: products
                              .map(
                                (e) => DataRow(
                                  selected: e == selectedProduct.state,
                                  onSelectChanged: (v) {
                                    if (v!) {
                                      selectedProduct.state = e;
                                    } else {
                                      selectedProduct.state = null;
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(
                                        (products.indexOf(e) + 1).toString())),
                                    DataCell(Text(e.name)),
                                    DataCell(Text(e.category!)),
                                    DataCell(
                                      SizedBox(
                                        width: e.images.length * 56,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: e.images
                                              .map((i) => Image.network(i))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Switch(
                                        value: e.popular,
                                        onChanged: (v) =>
                                            repository.updatedPopular(e.id, v),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        e.quantity.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Switch(
                                        value: e.active,
                                        onChanged: (v) =>
                                            repository.updatedActive(e.id, v),
                                      ),
                                    ),
                                    DataCell(
                                      Icon(Icons.delete),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, s) => Text(e.toString()),
            ),
          ),
          writeMode.state
              ? WriteProductScreen()
              : selectedProduct.state != null
                  ? ProductView()
                  : SizedBox()
        ],
      ),
    );
  }
}
