import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/ui/pages/banners/banners_page.dart';
import 'package:grocery_web_admin/ui/pages/categories/categories_page.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/milk_mans_page.dart';
import 'package:grocery_web_admin/ui/pages/products/products_screen.dart';

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
          ][index.state],
        ),
      ],
    );
  }
}
