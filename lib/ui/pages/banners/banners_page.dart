import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/banner.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/banners/providers/banners_provider.dart';

import 'widgets/write_category_dialog.dart';

class BannersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final bannersStream = watch(bannersProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => WriteBannerDialog(
                    param: WriteBannerParam(
                      list: bannersStream.data!.value,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
      appBar: AppBar(
        title: Text("Categories"),
        actions: [],
      ),
      body: bannersStream.when(
        data: (categories) => SingleChildScrollView(
          child: Card(
            child: DataTable(
              checkboxHorizontalMargin: 0,
              columns: [
                DataColumn(label: Text("Index")),
                DataColumn(label: Text("Category")),
                DataColumn(label: Text("Image")),
                DataColumn(label: Text("Edit")),
                DataColumn(label: Text("Delete")),
              ],
              rows: categories
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text((categories.indexOf(e) + 1).toString())),
                        DataCell(Text(e.category)),
                        DataCell(SizedBox(
                          height: 56,
                          width: 56,
                          child: Image(image: NetworkImage(e.image)),
                        )),
                        DataCell(Icon(Icons.edit), onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => WriteBannerDialog(param: WriteBannerParam(list: categories,prev: e),),
                          );
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Are you sure you want delete ${e.category} banner?"),
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
                                    context.read(repositoryProvider).removeBanner(category: e);
                                    Navigator.pop(context);
                                  },
                                  child: Text("YES"),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
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
