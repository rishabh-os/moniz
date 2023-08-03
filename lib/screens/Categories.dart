import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/components/deleteRoute.dart';
import 'package:moniz/data/category.dart';
import 'package:moniz/screens/accounts/AccountEditor.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  @override
  Widget build(BuildContext context) {
    List<TransactionCategory> categories = ref.watch(categoriesProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO: Make it reorderable later
        ListView.builder(
          // buildDefaultDragHandles: false,
          itemCount: categories.length,
          shrinkWrap: true,
          // onReorder: (oldIndex, newIndex) => {},
          itemBuilder: (context, index) {
            var e = categories[index];
            final key = GlobalObjectKey(index);
            return ListTile(
              key: key,
              title: Text(e.name),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ReorderableDragStartListener(
                  //     index: index,
                  //     child: const Icon(Icons.drag_indicator_rounded)),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  Icon(
                    IconData(
                      e.iconCodepoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: Color(e.color),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => handleTap(key, context, e),
                tooltip: "Edit category",
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        OpenContainer(
            closedColor: Theme.of(context).colorScheme.secondaryContainer,
            middleColor: Theme.of(context).colorScheme.secondaryContainer,
            openColor: Theme.of(context).colorScheme.background,
            transitionType: ContainerTransitionType.fadeThrough,
            closedElevation: 0,
            openShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, action) => TextButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: const Text("Add Category")),
            openBuilder: (context, action) => const AccountEditor(
                  type: "Category",
                )),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
