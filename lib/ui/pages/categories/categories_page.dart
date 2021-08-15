import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/categories/providers/categories_provider.dart';

import 'widgets/write_category_dialog.dart';

class CategoriesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final categoriesStream = watch(categoriesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => WriteCategoryDialog(
                    param: WriteCategoryParam(
                      list: categoriesStream.data!.value,
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
      body: categoriesStream.when(
        data: (categories) => SingleChildScrollView(
          child: Card(
            child: DataTable(
              checkboxHorizontalMargin: 0,
              columns: [
                DataColumn(label: Text("Index")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Image")),
                DataColumn(label: Text("Edit")),
                DataColumn(label: Text("Delete")),
              ],
              rows: categories
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text((categories.indexOf(e) + 1).toString())),
                        DataCell(Text(e.name)),
                        DataCell(SizedBox(
                          height: 56,
                          width: 56,
                          child: Image(image: NetworkImage(e.image)),
                        )),
                        DataCell(Icon(Icons.edit), onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => WriteCategoryDialog(
                              param: WriteCategoryParam(
                                list: categories,
                                prev: e,
                              ),
                            ),
                          );
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          if(e.name=="Milky"){
                            return ;
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Are you sure you want delete ${e.name} category?"),
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

                                    context.read(repositoryProvider).removeCategory(category: e);
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
