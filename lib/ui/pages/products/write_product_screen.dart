import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/ui/pages/categories/providers/categories_provider.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/selected_product_provider.dart';
import 'package:grocery_web_admin/utils/utils.dart';

import 'providers/write_mode_state_provider.dart';
import 'providers/write_product_view_model_provider.dart';

class WriteProductScreen extends ConsumerWidget {
  WriteProductScreen({
    Key? key,
  }) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final writeMode = context.read(writeModeStateProvider);
    final model = watch(writeProductViewModelProivider);
    final categoriesAsync = watch(categoriesProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return SizedBox(
      width: 400,
      child: Drawer(
        child: Material(
          color: theme.cardColor,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 8,
                  ),
                  title: Text(
                    model.forEdit ? "UPDATE PRODUCT" : "ADD PRODUCT",
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      writeMode.state = false;
                      context.read(selectedProductProvider).state = null;
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: model.category,
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
                    validator: (v)=>v==null?"Select Category":null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: model.name,
                    onChanged: (v) => model.name = v,
                    onSaved: (v) => model.name = v!,
                    validator: (value) => value!.isEmpty ? "Enter Name" : null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Images',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: model.pickImage,
                        child: Text("ADD IMAGE"),
                      ),
                    ],
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  children: model.images
                      .map(
                        (e) => Material(
                          color: Colors.white,
                          child: Stack(
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(e),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    model.removeImage(e);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: model.amount,
                    validator: (value) =>
                        value!.isEmpty ? "Enter Amount" : null,
                    onSaved: (v) => model.amount = v!,
                    onChanged: (v) => model.amount = v,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      suffix: SizedBox(
                        height: 20,
                        child: DropdownButton<String>(
                          underline: SizedBox(),
                          value: model.unit,
                          elevation: 16,
                          onChanged: (v) => model.unit = v!,
                          items: Utils.units
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: model.price.toInt().toString(),
                    validator: (value) => value!.isEmpty ? "Enter Price" : null,
                    onSaved: (v) => model.price = double.parse(v!),
                    onChanged: (v) => model.price = double.parse(v),
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: "Price", prefixText: " ₹ "),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: model.description,
                    validator: (value) =>
                        value!.isEmpty ? "Enter about product" : null,
                    onSaved: (v) => model.description = v!,
                    onChanged: (v) => model.description = v,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 10,
                    decoration: InputDecoration(labelText: "About Product"),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: model.active,
                        onChanged: (v) => model.active = v!),
                    Text("Active"),
                    SizedBox(
                      width: 16,
                    ),
                    Checkbox(
                        value: model.popular,
                        onChanged: (v) => model.popular = v!),
                    Text("Popular"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: model.loading
                      ? Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          color: theme.accentColor,
                          child: Text(model.forEdit ? "SAVE" : "ADD PRODUCT"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await model.writeProduct();
                              writeMode.state = false;
                              context.read(selectedProductProvider).state =
                                  null;
                            }
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
