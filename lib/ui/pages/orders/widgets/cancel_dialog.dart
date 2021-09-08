import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/models/order.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CancelDialog extends StatelessWidget {
  final Order order;
  final _formKey = GlobalKey<FormState>();

  CancelDialog({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Cancel order and refund"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          onSaved: (v) {
            context.read(repositoryProvider).cancelOrder(
                price: order.total + order.walletAmount,
                orderId: order.id,
                orderProducts: order.products,
                id: order.customerId,
                reason: v!);
            Navigator.pop(context);
                
          },
          decoration: InputDecoration(
            labelText: "Reason",
          ),
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
          color: Theme.of(context).accentColor,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
            }
          },
          child: Text("REFUND"),
        ),
      ],
    );
  }
}
