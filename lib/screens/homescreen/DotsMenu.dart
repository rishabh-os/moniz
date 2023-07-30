import 'package:flutter/material.dart';
import 'package:moniz/components/ThemePicker.dart';
import 'package:moniz/screens/Categories.dart';

class DotsMenu extends StatelessWidget {
  const DotsMenu({
    super.key,
    required this.listOfKeys,
    required this.scaffoldKey,
  });

  final List<GlobalKey<State<StatefulWidget>>> listOfKeys;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: listOfKeys[3],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) {
        if (value == "theme") {
          scaffoldKey.currentState!
              .showBottomSheet((context) => const ThemePicker());
        } else if (value == "cat") {
          showModalBottomSheet(
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => const Categories());
        } else if (value == "settings") {
          Navigator.of(context).pushNamed("/settings");
        }
      },
      itemBuilder: (context) => {
        "theme": "Change Theme",
        "cat": "Manage categories",
        "settings": "Settings",
      }
          .entries
          .map(
            (e) => PopupMenuItem(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
    );
  }
}
