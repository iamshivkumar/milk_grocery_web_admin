import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/banner.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/ui/pages/banners/providers/write_banner_view_model.dart';
import 'package:grocery_web_admin/ui/pages/categories/providers/categories_provider.dart';
import 'package:grocery_web_admin/ui/pages/categories/providers/write_category_view_model.dart';

class WriteBannerDialog extends ConsumerWidget {
  WriteBannerDialog({
    Key? key,
    required this.param,
  }) : super(key: key);
  final WriteBannerParam param;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(writeBannerViewModelProvider(param));
    final categoriesAsync = watch(categoriesProvider);

    return AlertDialog(
      title: Text("${param.prev != null ? "Edit" : "Add"} Category"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value:
                  categoriesAsync.data?.value.where((element) => element.name==model.category).isNotEmpty?? false
                      ? model.category
                      : null,
              elevation: 16,
              onChanged: (v) => model.category = v!,
              items: categoriesAsync.data != null
                  ? categoriesAsync.data!.value
                      .map((e) => e.name)
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              decoration: InputDecoration(
                labelText: "Category",
              ),
              validator: (v) => v == null ? "Select Category" : null,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  model.image != null
                      ? Image.network(model.image!)
                      : SizedBox(),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: model.pickImage,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actionsPadding: EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("CANCEL"),
        ),
        MaterialButton(
          color: theme.accentColor,
          onPressed: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              model.write();
              Navigator.pop(context);
            }
          },
          child: Text("SUBMIT"),
        ),
      ],
    );
  }
}
