import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/write_option_param.dart';
import 'package:grocery_web_admin/ui/pages/products/providers/write_option_view_model_provider.dart';
import 'package:grocery_web_admin/utils/utils.dart';

class WritePurchaseSlabDialog extends ConsumerWidget {
  WritePurchaseSlabDialog({
    Key? key,
    required this.param,
  }) : super(key: key);
  final WriteOptionParam param;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(writeSlabViewModelProvider(param));
    return AlertDialog(
      title: Text("${param.prevOption != null ? "Edit" : "Add"} Option"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue: model.option.price.toString(),
                validator: (value) => value!.isEmpty ? "Enter Price" : null,
                onSaved: (v) => model.option =
                    model.option.copyWith(price: double.parse(v!)),
                onChanged: (v) => model.option =
                    model.option.copyWith(price: double.parse(v)),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Price"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue:  model.option.salePrice.toString(),
                validator: (value) =>
                    value!.isEmpty ? "Enter Sale Price" : null,
                onSaved: (v) => model.option =
                    model.option.copyWith(salePrice: double.parse(v!)),
                onChanged: (v) => model.option =
                    model.option.copyWith(salePrice: double.parse(v)),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Sale Price"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue: model.option.amount,
                validator: (value) => value!.isEmpty ? "Enter Amount" : null,
                onSaved: (v) =>
                    model.option = model.option.copyWith(amount: v!),
                onChanged: (v) =>
                    model.option = model.option.copyWith(amount: v),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  suffix: SizedBox(
                    height: 20,
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      value: model.option.unit,
                      elevation: 16,
                      onChanged: (v) {
                        model.option = model.option.copyWith(unit: v);
                      },
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
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue:  model.option.quantity.toString(),
                validator: (value) => value!.isEmpty ? "Enter Quantity" : null,
                onSaved: (v) => model.option =
                    model.option.copyWith(quantity: int.parse(v!)),
                onChanged: (v) => model.option =
                    model.option.copyWith(quantity: int.parse(v)),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Quantity"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue:  model.option.barcode,
                validator: (value) => value!.isEmpty ? "Enter Barcode" : null,
                onSaved: (v) =>
                    model.option = model.option.copyWith(barcode: v!),
                onChanged: (v) =>
                    model.option = model.option.copyWith(barcode: v),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Barcode"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                initialValue:  model.option.location,
                validator: (value) => value!.isEmpty ? "Enter Location" : null,
                onSaved: (v) =>
                    model.option = model.option.copyWith(location: v!),
                onChanged: (v) =>
                    model.option = model.option.copyWith(location: v),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Location"),
              ),
            ),
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
              Navigator.pop(context, true);
            }
          },
          child: Text("SUBMIT"),
        ),
      ],
    );
  }
}
