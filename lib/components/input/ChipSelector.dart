import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/category.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";

class ChipSelector extends ConsumerStatefulWidget {
  const ChipSelector(
      {super.key,
      required this.items,
      required this.selection,
      required this.returnSelected});
  final List<Classifier> items;
  final int selection;
  final Function(int selected) returnSelected;
  @override
  ConsumerState<ChipSelector> createState() => _ChipSelectorState();
}

class _ChipSelectorState extends ConsumerState<ChipSelector> {
  final ItemScrollController itemScrollController = ItemScrollController();
  late bool chipsMultiLine;
  @override
  void initState() {
    super.initState();
    chipsMultiLine = ref.read(chipsMultiLineProvider);
    if (!chipsMultiLine) {
      // ? Scrolls to the selected chip on render
      WidgetsBinding.instance.addPostFrameCallback((_) {
        itemScrollController.jumpTo(index: widget.selection);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chipsMultiLine) {
      return Wrap(alignment: WrapAlignment.center, children: [
        for (var i = 0; i < widget.items.length; i += 1) newMethod(i)
      ]);
    } else {
      // ? SizedBox needed so that it doens't cause render overflow errors
      return SizedBox(
        height: 44,
        child: ScrollablePositionedList.builder(
          key: const Key("chips"),
          scrollDirection: Axis.horizontal,
          itemScrollController: itemScrollController,
          itemCount: widget.items.length,
          itemBuilder: (context, index) => newMethod(index),
        ),
      );
    }
  }

  Widget newMethod(index) {
    Classifier clas = widget.items[index];
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FilterChip(
        showCheckmark: false,
        label: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Icon(
              IconData(clas.iconCodepoint, fontFamily: "MaterialIcons"),
              color: Color(clas.color),
            ),
            Text(widget.items[index].name),
          ],
        ),
        selected: widget.selection == index,
        onSelected: (bool selected) {
          widget.returnSelected(index);
        },
      ),
    );
  }
}
