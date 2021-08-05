import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/category.dart';
import 'package:grocery_web_admin/ui/pages/categories/providers/write_category_view_model.dart';

class WritePurchaseSlabDialog extends ConsumerWidget {
  WritePurchaseSlabDialog({
    Key? key,
    required this.param,
  }) : super(key: key);
  final WriteCategoryParam param;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(writeCategoryViewModelProvider(param));
    return AlertDialog(
      title: Text("${param.prev != null ? "Edit" : "Add"} Category"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: model.name,
              onSaved: (v) => model.name = v!,
              onChanged: (v) => model.name = v,
              validator: (v) => v!.isEmpty ? "Enter Category Name" : null,
              decoration: InputDecoration(labelText: "Category Name"),
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
