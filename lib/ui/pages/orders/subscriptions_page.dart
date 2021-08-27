import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/subscription.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/milk_mans_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/selected_subscription_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/subscriptions_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/subscriptions_view_model_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/labels.dart';
import 'package:grocery_web_admin/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubscriptionsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final selected = watch(selectedSubscriptionProvider);
    final model = watch(subscriptionsViewModelProvider);
    final milkMansStream = watch(milkMansProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Subsriptions"),
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
                        child: DropdownButtonFormField<MilkMan>(
                          onChanged: (v) => model.milkMan = v,
                          value: model.milkMan,
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
                          value: model.area,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final subscriptionsStream = watch(
                                subscriptionsProivder(
                                  Params(
                                      milkManId: model.milkMan!.mobile,
                                      area: model.area!),
                                ),
                              );
                              return subscriptionsStream.when(
                                data: (subscriptions) => SingleChildScrollView(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Card(
                                      child: DataTable(
                                        showCheckboxColumn: false,
                                        checkboxHorizontalMargin: 0,
                                        columns: [
                                          DataColumn(label: Text("Index")),
                                          DataColumn(label: Text("Customer")),
                                          DataColumn(label: Text("Address")),
                                          DataColumn(label: Text("Product")),
                                          DataColumn(label: Text("Price")),
                                          DataColumn(
                                              label: Text("Daily Quantity")),
                                          DataColumn(label: Text("Start Date")),
                                          DataColumn(label: Text("End Date")),
                                        ],
                                        rows: subscriptions
                                            .map(
                                              (e) => DataRow(
                                                selected: e == selected.state,
                                                onSelectChanged: (v) {
                                                  if (v!) {
                                                    selected.state = e;
                                                  } else {
                                                    selected.state = null;
                                                  }
                                                },
                                                cells: [
                                                  DataCell(Text(subscriptions
                                                      .indexOf(e)
                                                      .toString())),
                                                  DataCell(
                                                      Text(e.customerName)),
                                                  DataCell(Text(
                                                      e.address.number +
                                                          ", " +
                                                          e.address.landMark)),
                                                  DataCell(Text(
                                                      "${e.productName} (${e.option.amountLabel})")),
                                                  DataCell(Text(
                                                      e.option.salePriceLabel)),
                                                  DataCell(Text(e
                                                      .deliveries.last.quantity
                                                      .toString())),
                                                  DataCell(Text(
                                                      Utils.formatedDate(
                                                          e.startDate))),
                                                  DataCell(Text(
                                                      Utils.formatedDate(
                                                          e.endDate))),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                loading: () => Loading(),
                                error: (e, s) {
                                  print(e);
                                  return Text(
                                    e.toString(),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        selected.state != null
                            ? ScheduleView(subscription: selected.state!)
                            : SizedBox()
                      ],
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

class ScheduleView extends StatelessWidget {
  const ScheduleView({
    Key? key,
    required this.subscription,
  }) : super(key: key);
  final Subscription subscription;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 2,
      color: theme.cardColor,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Status')),
          ],
          rows: subscription.deliveries
              .map(
                (e) => DataRow(
                  cells: [
                    DataCell(Text(Utils.formatedDate(e.date))),
                    DataCell(Text(e.quantity.toString())),
                    DataCell(Text(
                        "${Labels.rupee}${e.quantity * subscription.option.salePrice}")),
                    DataCell(Text(e.status)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
