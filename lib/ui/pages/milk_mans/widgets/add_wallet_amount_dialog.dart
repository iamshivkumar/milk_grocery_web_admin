import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/utils/labels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWalletAmountDialog extends StatelessWidget {
  final double amount;
  final String id;
  final bool isMilkMan;
  AddWalletAmountDialog(
      {Key? key,
      required this.amount,
      required this.id,
      required this.isMilkMan})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double _amount = 0;
    return AlertDialog(
      title: Text("Add Wallet Amount"),
      content: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: Text("${Labels.rupee}$amount"),
            ),
            Expanded(
              child: Icon(Icons.add),
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                onSaved: (v) => _amount = double.parse(v!),
                validator: (v) {
                  if (v!.isEmpty) {
                    return "Enter Amount";
                  } else if (double.tryParse(v) == null) {
                    return "Enter Valid Amount";
                  } else if((double.parse(v) + amount).isNegative){
                    return "total should not be negative";
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("CANCEL"),
        ),
        MaterialButton(
          color: theme.accentColor,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              context.read(repositoryProvider).editWalletAmount(
                    amount: _amount,
                    id: id,
                    isMilkMan: isMilkMan,
                  );
              Navigator.pop(context);
            }
          },
          child: Text("ADD"),
        ),
      ],
    );
  }
}
