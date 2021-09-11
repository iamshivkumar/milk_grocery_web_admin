import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_web_admin/core/models/tranz_params.dart';
import 'package:grocery_web_admin/core/models/tranzaction.dart';
import 'package:grocery_web_admin/ui/pages/tranzactions/providers/tranzactions_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/dates.dart';
import 'package:grocery_web_admin/utils/labels.dart';
import 'package:grocery_web_admin/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers/date_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

import 'widgets/range_filterer.dart';

class TranzactionsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,ScopedReader watch) {
    final dateRange = watch(dateRangeProvider);

    final chargesFuture = watch(
      tranzactionsProvider(
        RangeParam(dateRange.start, dateRange.end),
      ),
    );
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tranzactions History"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RangleFilterer(dateRange: dateRange),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 400,
                  child: chargesFuture.when(
                    data: (charges) {
                      if (charges.isEmpty) {
                        return SizedBox();
                      }
                      final double total = charges
                          .map((e) => e.amount)
                          .reduce((value, element) => value + element);
                      return ListView(
                        children: <Widget>[
                              Card(
                                child: ListTile(
                                  selected: true,
                                  title: Text("Total: ${Labels.rupee}$total"),
                                ),
                              ),
                            ] +
                            charges
                                .map(
                                  (e) => Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  Labels.rupee +
                                                      e.amount.toString(),
                                                  style:
                                                      style.headline6!.copyWith(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  Utils.formatedDateTime(
                                                      e.createdAt),
                                                  style: style.overline,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  e.name,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  e.type,
                                                  style: style.caption,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      );
                    },
                    loading: () => Loading(),
                    error: (e, s) => Text(
                      e.toString(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      AspectRatio(
                        aspectRatio: 3,
                        child: Card(
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              visibleMaximum: DateTime.now(),
                              dateFormat: DateFormat("dd-MM-yyyy hh:mm a"),
                            ),
                            series: <ChartSeries>[
                              LineSeries<Tranzactions, DateTime>(
                                color: Colors.green,
                                dataSource: chargesFuture.data?.value ?? [],
                                xValueMapper: (v, _) => v.createdAt,
                                yValueMapper: (v, _) => v.amount,
                              )
                            ],
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 3,
                        child: Card(
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              visibleMaximum: DateTime.now(),
                              dateFormat: DateFormat("dd-MM-yyyy hh:mm a"),
                            ),
                            series: <ChartSeries>[
                              LineSeries<Tranzactions, DateTime>(
                                color: Colors.green,
                                dataSource: chargesFuture.data?.value ?? [],
                                xValueMapper: (v, _) => v.createdAt,
                                yValueMapper: (v, _) {
                                  final list =
                                      (chargesFuture.data?.value ?? []);
                                  final sub = list
                                      .sublist(list.indexOf(v))
                                      .map((e) => e.amount);
                                  if (sub.isEmpty) {
                                    return 0;
                                  }
                                  return sub.reduce(
                                      (value, element) => value + element);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
