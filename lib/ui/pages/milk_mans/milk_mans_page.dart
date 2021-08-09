import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/milk_mans_provider.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/selected_product_provider.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/write_milk_man_view_model_provider.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/widgets/write_milk_man_view.dart';

class MilkMansPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final milkMansStream = watch(milkMansProvider);
    final selectedMilkMan = watch(selectedMilkManProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Mans"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: milkMansStream.when(
                  data: (categories) => Card(
                    child: DataTable(
                      showCheckboxColumn: false,
                      checkboxHorizontalMargin: 0,
                      columns: [
                        DataColumn(label: Text("Index")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Mobile Number")),
                        DataColumn(label: Text("Areas")),
                        DataColumn(label: Text("Delete")),
                      ],
                      rows: categories
                          .map(
                            (e) => DataRow(
                              selected: e == selectedMilkMan.state,
                            onSelectChanged: (v) {
                              if (v!) {
                                context.read(writeMilkManViewModelProvider).clear();
                                selectedMilkMan.state = e;
                              } else {
                                selectedMilkMan.state = null;
                              }
                            },
                              cells: [
                                DataCell(Text(
                                    (categories.indexOf(e) + 1).toString())),
                                DataCell(Text(e.name)),
                                DataCell(Text(e.mobile)),
                                DataCell(
                                  Row(
                                    children: e.areas
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Material(
                                              color: theme.primaryColorLight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(e),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                DataCell(
                                  Icon(Icons.delete),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            "Are you sure you want delete this milk man?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("NO"),
                                          ),
                                          MaterialButton(
                                            color: theme.accentColor,
                                            onPressed: () {
                                              context
                                                  .read(repositoryProvider)
                                                  .delete(id: e.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text("YES"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, s) => Text(
                    e.toString(),
                  ),
                ),
              ),
            ),
          ),
          WriteMilkManView(),
        ],
      ),
    );
  }
}
