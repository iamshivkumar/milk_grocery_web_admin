import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/ui/pages/banners/banners_page.dart';
import 'package:grocery_web_admin/ui/pages/categories/categories_page.dart';
import 'package:grocery_web_admin/ui/pages/charges/charges_page.dart';
import 'package:grocery_web_admin/ui/pages/customers/customers_page.dart';
import 'package:grocery_web_admin/ui/pages/low_stock_notice/low_stock_notice_page.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/milk_mans_page.dart';
import 'package:grocery_web_admin/ui/pages/offers/offers_page.dart';
import 'package:grocery_web_admin/ui/pages/orders/orders_page.dart';
import 'package:grocery_web_admin/ui/pages/orders/subscriptions_page.dart';
import 'package:grocery_web_admin/ui/pages/products/products_screen.dart';
import 'package:grocery_web_admin/ui/pages/sales_report/sales_report.dart';
import 'package:grocery_web_admin/ui/pages/settings/settings_page.dart';
import 'package:grocery_web_admin/ui/pages/tranzactions/tranzactions_page.dart';

import 'providers/index_provider.dart';
import 'widgets/my_drawer.dart';

class Dashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final index = watch(indexProvider);
    return Row(
      children: [
        MyDrawer(),
        Expanded(
          child: [
            ProductsScreen(),
            CategoriesPage(),
            BannersPage(),
            MilkMansPage(),
            CustomersPage(),
            OrdersPage(),
            SubscriptionsPage(),
            OffersPage(),
            SettingsPage(),
            LowStackNoticePage(),
            ChargesPage(),
            TranzactionsPage(),
            SalesReportPage()
          ][index.state],
        ),
      ],
    );
  }
}
