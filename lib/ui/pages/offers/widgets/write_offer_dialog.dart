import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/models/write_offer_option.dart';
import 'package:grocery_web_admin/ui/pages/offers/providers/write_offer_view_model_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WriteOfferDialog extends ConsumerWidget {
  final WriteOfferParam params;

  WriteOfferDialog({Key? key, required this.params}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(writeOfferViewModelProvider(params));
    return AlertDialog(
      title: Text(params.prevOffer != null ? "Edit Offer" : "Add Offer"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: model.offer.amount.toString(),
              validator: (value) => value!.isEmpty ? "Enter Amount" : null,
              onSaved: (v) =>
                  model.offer = model.offer.copyWith(amount: double.parse(v!)),
              onChanged: (v) =>
                  model.offer = model.offer.copyWith(amount: double.parse(v)),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: model.offer.percentage.toString(),
              validator: (value) =>
                  value!.isEmpty ? "Enter Discount Percentage" : null,
              onSaved: (v) => model.offer =
                  model.offer.copyWith(percentage: double.parse(v!)),
              onChanged: (v) => model.offer =
                  model.offer.copyWith(percentage: double.parse(v)),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Discount Percentage",
              ),
            ),
          ],
        ),
      ),
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
