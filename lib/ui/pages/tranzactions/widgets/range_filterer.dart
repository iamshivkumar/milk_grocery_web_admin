import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_web_admin/ui/pages/tranzactions/providers/date_provider.dart';
import 'package:grocery_web_admin/utils/dates.dart';
import 'package:grocery_web_admin/utils/utils.dart';

class RangleFilterer extends HookWidget {
  const RangleFilterer({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  final DateRange dateRange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller1 =
        useTextEditingController(text: Utils.formatedDate(dateRange.start));
    final controller2 =
        useTextEditingController(text: Utils.formatedDate(dateRange.end));
    return Material(
      elevation: 4,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Start Date",
                  ),
                  controller: controller1,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: dateRange.start,
                      firstDate: DateTime(2021),
                      lastDate: Dates.today,
                    );
                    if (dateTime != null) {
                      dateRange.start = dateTime;
                      controller1.text = Utils.formatedDate(dateRange.start);
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "End Date",
                  ),
                  controller: controller2,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: dateRange.end,
                      firstDate: DateTime(2021),
                      lastDate: Dates.today,
                    );
                    if (dateTime != null) {
                      dateRange.end = dateTime;
                      controller2.text = Utils.formatedDate(dateRange.end);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
