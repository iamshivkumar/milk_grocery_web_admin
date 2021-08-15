import 'package:flutter/material.dart';

class AbcView extends StatelessWidget {
  final List<String> abcs = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  final String selected;

  final Function(String) onSelect;

   AbcView({Key? key, required this.selected, required this.onSelect}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Wrap(
      children: abcs
          .map(
            (e) => IconButton(
              onPressed: () {
                onSelect(e);
              },
              icon: Text(
                e,
                style: style.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selected==e?theme.primaryColor:Colors.black,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
