import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index_provider.dart';

class Menu {
  final IconData icon;
  final String name;

  Menu(this.icon, this.name);
}

class MyDrawer extends ConsumerWidget {
  final List<Menu> menus = [
    Menu(Icons.apps, "Products"),
    Menu(Icons.category, "Categories"),
    Menu(Icons.label, "Banners"),
    Menu(Icons.delivery_dining, "Milk Mans"),
    Menu(Icons.group, "Customers"),
    Menu(Icons.shopping_bag, "Orders"),
    Menu(Icons.subscriptions, "Subscriptions"),
    Menu(Icons.local_offer, "Offers"),
    Menu(Icons.settings, "Settings"),
    Menu(Icons.warning, "Low Stock Notice"),
    Menu(Icons.account_balance_wallet, "Charges History"),
    Menu(Icons.attach_money, "Tranzactions History"),
  ];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final index = watch(indexProvider);

    return SizedBox(
      width: 250,
      child: Drawer(
        child: Material(
          color: theme.primaryColor,
          child: Column(
            children: [
              AppBar(),
              Expanded(
                child: Theme(
                  data: ThemeData.dark(),
                  child: ListView.builder(
                    itemCount: menus.length,
                    itemBuilder: (context, i) => ListTile(
                      selected: index.state == i,
                      selectedTileColor: theme.primaryColorLight,
                      onTap: () {
                        index.state = i;
                      },
                      leading: Icon(menus[i].icon),
                      title: Text(
                        menus[i].name,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
