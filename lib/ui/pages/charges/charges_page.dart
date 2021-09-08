import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_web_admin/ui/pages/charges/providers/charges_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/dates.dart';
import 'package:grocery_web_admin/utils/labels.dart';
import 'package:grocery_web_admin/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/date_provider.dart';

class ChargesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final date = useProvider(dateProvider);
    final controller =
        useTextEditingController(text: Utils.formatedDate(date.state));
    final chargesFuture = useProvider(chargesProvider(date.state));
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Charges History"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 4,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Date",
                        ),
                        controller: controller,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: date.state,
                            firstDate: DateTime(2021),
                            lastDate: Dates.today,
                          );
                          if (dateTime != null) {
                            date.state = dateTime;
                            controller.text = Utils.formatedDate(date.state);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 300,
              child: chargesFuture.when(
                data: (charges) => ListView(
                  children: charges
                      .where((element) =>
                          element.from == null || element.to == null)
                      .map(
                        (e) => Card(
                          child: ListTile(
                            title: Text(
                              Labels.rupee + e.amount.toString(),
                              style: TextStyle(
                                color: e.to == null ? Colors.green : Colors.red,
                              ),
                            ),
                            subtitle: Text(e.type),
                            trailing: Text(Utils.formatedTime(e.createdAt)),
                          ),
                        ),
                      )
                      .toList(),
                ),
                loading: () => Loading(),
                error: (e, s) => Text(
                  e.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
