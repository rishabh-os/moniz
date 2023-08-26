import "package:flutter/material.dart";
import "package:moniz/components/ThemePicker.dart";
// import "package:moniz/screens/Budget.dart";

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
        switch (value) {
          case "Theme":
            scaffoldKey.currentState!
                .showBottomSheet((context) => const ThemePicker());
            break;
          case "Settings":
            Navigator.of(context).pushNamed("/settings");
            break;
        }
      },
      itemBuilder: (context) => {
        "Theme": Icons.palette_rounded,
        "Settings": Icons.settings_rounded,
      }
          .entries
          .map(
            (e) => PopupMenuItem(
              value: e.key,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Icon(e.value),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(e.key),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
