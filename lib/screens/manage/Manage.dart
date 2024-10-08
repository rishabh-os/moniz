import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/components/input/Header.dart";
import "package:moniz/data/SimpleStore/tutorialStore.dart";
import "package:moniz/screens/manage/Accounts.dart";
import "package:moniz/screens/manage/Categories.dart";
import "package:visibility_detector/visibility_detector.dart";

class Manage extends ConsumerStatefulWidget {
  const Manage({super.key});

  @override
  ConsumerState<Manage> createState() => _ManageState();
}

class _ManageState extends ConsumerState<Manage>
    with AutomaticKeepAliveClientMixin {
  late final List<GlobalKey> listOfKeys;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    listOfKeys = ref.read(manageGkListProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VisibilityDetector(
            key: listOfKeys[0],
            onVisibilityChanged: (info) {
              if (!ref.watch(manageTutorialCompletedProvider)) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (info.visibleFraction == 1) {
                    if (!context.mounted) return;
                    ref.read(tutorialProvider)(context, Screen.manage);
                    ref
                        .watch(manageTutorialCompletedProvider.notifier)
                        .update((state) => true);
                  }
                });
              }
            },
            child: const Header(text: "Accounts"),
          ),
          const SizedBox(height: 10),
          const Accounts(),
          const Divider(
            height: 40,
            indent: 20,
            endIndent: 20,
          ),
          Header(
            text: "Categories",
            key: listOfKeys[1],
          ),
          const SizedBox(height: 20),
          const Categories(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
