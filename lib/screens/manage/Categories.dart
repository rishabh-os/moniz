import "dart:ui";
import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/deleteRoute.dart";
import "package:moniz/data/category.dart";
import "package:moniz/screens/manage/AccountEditor.dart";

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
        ReorderableListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: categories.length,
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) => {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = categories.removeAt(oldIndex);
              categories.insert(newIndex, item);
              for (int i = 0; i < categories.length; i++) {
                ref
                    .read(categoriesProvider.notifier)
                    .edit(categories[i].copyWith(order: i));
              }
            })
          },
          proxyDecorator: proxyDecorator,
          itemBuilder: (context, index) {
            var cat = categories[index];
            // ? Not a regular key so that I can use the edit animation
            final key = GlobalObjectKey(cat.id);
            return ListTile(
              key: key,
              title: Text(cat.name),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_indicator_rounded)),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    IconData(
                      cat.iconCodepoint,
                      fontFamily: "MaterialIcons",
                    ),
                    color: Color(cat.color),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => handleTap(key, context, cat),
                tooltip: "Edit category",
              ),
            );
          },
        ),
        const SizedBox(height: 10),
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
      ],
    );
  }
}

Widget proxyDecorator(child, index, animation) => AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        return Material(
          borderRadius: BorderRadius.circular(10),
          elevation: elevation,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: child,
        );
      },
      child: child,
    );
