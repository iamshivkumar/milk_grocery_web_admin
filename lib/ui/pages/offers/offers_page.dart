import 'package:flutter/material.dart';
import 'package:grocery_web_admin/core/models/write_offer_option.dart';
import 'package:grocery_web_admin/ui/pages/offers/providers/master_data_provider.dart';
import 'package:grocery_web_admin/ui/pages/offers/widgets/write_offer_dialog.dart';
import 'package:grocery_web_admin/ui/widgets/loading.dart';
import 'package:grocery_web_admin/utils/labels.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OffersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final masterDataStream = watch(masterdataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Offers"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 400,
            child: masterDataStream.when(
              data: (data) => Card(
                child: ListView(
                  children: data.offers
                      .map(
                        (e) => ListTile(
                          onTap: (){
                            showDialog(
                                  context: context,
                                  builder: (context) => WriteOfferDialog(
                                    params: WriteOfferParam(
                                      offers: data.offers,
                                      prevOffer: e,
                                    ),
                                  ),
                                );
                          },
                          title: Text(Labels.rupee + e.amount.toString()),
                          trailing: Text(e.percentage.toString() + "\%"),
                        ),
                      )
                      .toList(),
                ),
              ),
              loading: () => Loading(),
              error: (e, s) => Text(
                e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
