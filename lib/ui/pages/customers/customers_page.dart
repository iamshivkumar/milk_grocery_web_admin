import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/ui/pages/customers/providers/customers_provider.dart';
import 'package:grocery_web_admin/ui/pages/customers/providers/customers_view_model_provider.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/milk_mans_provider.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/widgets/add_wallet_amount_dialog.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/labels.dart';

class CustomersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final milkMansStream = watch(milkMansProvider);
    final model = watch(customersViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
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
                    child: Builder(
                      builder: (context) {
                        final customersStream = watch(
                          customersProivder(
                            Params(
                              milkManId: model.milkMan!.mobile,
                              area: model.area!,
                            ),
                          ),
                        );
                        return customersStream.when(
                          data: (customers) => SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Card(
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text("Index")),
                                    DataColumn(label: Text("Name")),
                                    DataColumn(label: Text("Area")),
                                    DataColumn(
                                        label: Text("House /Flat/ Block No")),
                                    DataColumn(label: Text("Landmark")),
                                    DataColumn(label: Text("Wallet Amount")),
                                    DataColumn(label: Text("Mobile")),
                                  ],
                                  rows: customers
                                      .where((element) => element.ready)
                                      .map(
                                        (e) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                customers.indexOf(e).toString(),
                                              ),
                                            ),
                                            DataCell(Text(e.name)),
                                            DataCell(Text(e.area!)),
                                            DataCell(Text(e.number!)),
                                            DataCell(Text(e.landMark!)),
                                            DataCell(
                                                Text(
                                                  "${Labels.rupee}${e.walletAmount}",
                                                ),
                                                showEditIcon: true, onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AddWalletAmountDialog(
                                                  amount: e.walletAmount,
                                                  id: e.id,
                                                  isMilkMan: false,
                                                ),
                                              );
                                            }),
                                            DataCell(
                                              Text(e.mobile),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          loading: () => Loading(),
                          error: (e, s) => Text(
                            e.toString(),
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
