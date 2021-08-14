import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_web_admin/core/models/params.dart';
import 'package:grocery_web_admin/core/models/milk_man.dart';
import 'package:grocery_web_admin/core/models/params_with_date.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/milk_mans_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/orders_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/orders_view_model_provider.dart';
import 'package:grocery_web_admin/ui/pages/orders/providers/subscriptions_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final milkMansStream = useProvider(milkMansProvider);
    final model = useProvider(ordersViewModelProvider);
    final controller = useTextEditingController(text: Utils.formatedDate(model.dateTime));
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: milkMansStream.when(
        data: (milkMans) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 4,
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: model.dateTime,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );
                            if(date!=null){
                              controller.text = Utils.formatedDate(date);
                              model.dateTime = date;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<MilkMan>(
                          onChanged: (v) => model.milkMan = v,
                          value: milkMans.contains(model.milkMan)
                              ? model.milkMan
                              : null,
                          items: milkMans
                              .map(
                                (e) => DropdownMenuItem<MilkMan>(
                                  child: Text(e.name),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          onChanged: (v) => model.area = v,
                          value: (model.areas ?? []).contains(model.area)
                              ? model.area
                              : null,
                          items: (model.areas ?? [])
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            model.milkMan != null && model.area != null
                ? Expanded(
                    child: Builder(
                      builder: (context) {
                        final subscriptions = useProvider(
                              subscriptionsProivder(
                                Params(
                                  milkManId: model.milkMan!.mobile,
                                  area: model.area!,
                                ),
                              ),
                            )
                                .data
                                ?.value
                                .where((element) => element.deliveries
                                    .where((d) => d.date == model.dateTime)
                                    .isNotEmpty)
                                .toList() ??
                            [];
                        final orders = useProvider(
                              ordersProvider(
                                ParamsWithDate(
                                  milkManId: model.milkMan!.mobile,
                                  area: model.area!,
                                  dateTime: model.dateTime,
                                ),
                              ),
                            ).data?.value ??
                            [];
                        final list = subscriptions.cast<dynamic>() +
                            orders.cast<dynamic>();
                        return SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Card(
                              child: DataTable(
                                columns: [],
                                rows: [],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
        loading: () => Loading(),
        error: (e, s) => SizedBox(),
      ),
    );
  }
}
