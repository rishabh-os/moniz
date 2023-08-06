import 'package:flutter/material.dart';
import 'package:moniz/data/category.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChipSelector extends StatefulWidget {
  const ChipSelector(
      {super.key,
      required this.items,
      required this.selection,
      required this.returnSelected});
  final List<Classifier> items;
  final int selection;
  final Function(int selected) returnSelected;
  @override
  State<ChipSelector> createState() => _ChipSelectorState();
}

class _ChipSelectorState extends State<ChipSelector> {
  final ItemScrollController itemScrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();
    // ? Scrolls to the selected chip on render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.selection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ScrollablePositionedList.builder(
        key: const Key("chips"),
        scrollDirection: Axis.horizontal,
        itemScrollController: itemScrollController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          Classifier clas = widget.items[index];
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              label: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Icon(
                    IconData(clas.iconCodepoint, fontFamily: 'MaterialIcons'),
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
        },
      ),
    );
  }
}
