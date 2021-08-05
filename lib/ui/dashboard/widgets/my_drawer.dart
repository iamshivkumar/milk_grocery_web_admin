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
  ];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final index = watch(indexProvider);

    return Drawer(
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
    );
  }
}
