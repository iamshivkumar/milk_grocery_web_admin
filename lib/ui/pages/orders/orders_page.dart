import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_web_admin/core/models/merged_order.dart';
import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/models/params_with_date.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/milk_mans_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/orders_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/orders_view_model_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/subscriptions_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final milkMansStream = watch(milkMansProvider);
    final model = watch(ordersViewModelProvider);
    // final controller =
    //     useTextEditingController(text: Utils.formatedDate(model.dateTime));
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: milkMansStream.when(
        data: (milkMans) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 4,
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateField(
                          onSelect: (v) => model.dateTime = v,
                          initial: model.dateTime,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<MilkMan>(
                          onChanged: (v) => model.milkMan = v,
                          value: milkMans.contains(model.milkMan)
                              ? model.milkMan
                              : null,
                          items: milkMans
                              .map(
                                (e) => DropdownMenuItem<MilkMan>(
                                  child: Text(e.name),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          onChanged: (v) => model.area = v,
                          value: (model.areas ?? []).contains(model.area)
                              ? model.area
                              : null,
                          items: (model.areas ?? [])
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            model.milkMan != null && model.area != null
                ? Expanded(
                    child: Consumer(
                      builder: (context, watch, child) {
                        final subscriptions = watch(
                          subscriptionsProivder(
                            Params(
                              milkManId: model.milkMan!.mobile,
                              area: model.area!,
                            ),
                          ),
                        ).when(
                            data: (values) => values
                                .where((element) => element.deliveries
                                    .where((d) => d.date == model.dateTime)
                                    .isNotEmpty)
                                .toList(),
                            loading: () => [],
                            error: (e, s) {
                              print(e.toString());
                              return [];
                            });

                        final orders = watch(
                          ordersProvider(
                            ParamsWithDate(
                              milkManId: model.milkMan!.mobile,
                              area: model.area!,
                              dateTime: model.dateTime,
                            ),
                          ),
                        ).when(
                            data: (values) => values,
                            loading: () => [],
                            error: (e, s) {
                              print(e.toString());
                              return [];
                            });
                        final list = (subscriptions.cast<dynamic>() +
                                orders.cast<dynamic>())
                            .map(
                              (e) => e is Order
                                  ? MergedOrder.fromOrder(e)
                                  : MergedOrder.fromSubscription(
                                      subscription: e, date: model.dateTime),
                            )
                            .toList();
                        final List<DataRow> rows = [];
                        for (var order in list) {
                          final color = list.indexOf(order).isEven
                              ? theme.primaryColorLight
                              : Colors.white;
                          rows.add(
                            DataRow(cells: [
                              DataCell(
                                  Text((list.indexOf(order) + 1).toString())),
                              DataCell(Text(order.label)),
                              DataCell(Text(order.customerName)),
                              DataCell(Text(order.address)),
                              DataCell(Text(order.products.first.name)),
                              DataCell(Text(order.products.first.price)),
                              DataCell(Text(order.products.first.quantity)),
                              DataCell(Text(order.price)),
                              DataCell(Text(order.walletAmount)),
                              DataCell(Text(order.total)),
                              DataCell(Text(order.status)),
                            ], color: MaterialStateProperty.all(color)),
                          );
                          for (var product in order.products.skip(1)) {
                            rows.add(
                              DataRow(
                                cells: [
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell(Text(product.name)),
                                  DataCell(Text(product.price)),
                                  DataCell(Text(product.quantity)),
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                ],
                                color: MaterialStateProperty.all(color),
                              ),
                            );
                          }
                        }
                        print(rows.length);
                        return SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Card(
                              child: DataTable(
                                columns: [
                                  DataColumn(label: Text("Index")),
                                  DataColumn(label: Text("Type")),
                                  DataColumn(label: Text("Customer")),
                                  DataColumn(label: Text("Address")),
                                  DataColumn(label: Text("Product")),
                                  DataColumn(label: Text("Price")),
                                  DataColumn(label: Text("Quantity")),
                                  DataColumn(label: Text("Total Price")),
                                  DataColumn(label: Text("Wallet Amount Used")),
                                  DataColumn(label: Text("Further Paid")),
                                  DataColumn(label: Text("Status")),
                                ],
                                rows: rows,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => SizedBox(),
      ),
    );
  }
}

class DateField extends HookWidget {
  const DateField({
    Key? key,
    required this.initial,
    required this.onSelect,
  }) : super(key: key);

  final Function(DateTime) onSelect;
  final DateTime initial;
  @override
  Widget build(BuildContext context) {
    final controller =
        useTextEditingController(text: Utils.formatedDate(initial));
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (date != null) {
          controller.text = Utils.formatedDate(date);
          onSelect(date);
        }
      },
    );
  }
}
