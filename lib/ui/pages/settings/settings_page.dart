import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';
import 'package:grocery_web_admin/ui/pages/offers/providers/master_data_provider.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(masterdataProvider);
    final repository = context.read(repositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 400,
            child: ListView(
              children: [
                stream.when(
                  data: (data) => Card(
                    child: ListTile(
                      title: Text("App status"),
                      trailing: Switch(
                        value: data.active,
                        onChanged: repository.updateStatus,
                      ),
                      subtitle:
                          Text(data.active ? "Active" : "Has been blocked"),
                    ),
                  ),
                  loading: () => Loading(),
                  error: (e, s) => Text(
                    e.toString(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
