import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/low_stock_notice/providers/notices_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LowStackNoticePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(noticesProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: 300,
        child: stream.when(
          data: (list) => ListView(
            children: list
                .map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(
                        e.toString(),
                      ),
                      trailing: CloseButton(
                        onPressed: () {
                          context.read(repositoryProvider).removeLowCostNotice(e);
                        },
                      ),
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
    );
  }
}
