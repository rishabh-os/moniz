import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/SimpleStore/tutorialStore.dart";
import "package:moniz/screens/analysis/Analysis.dart";
import "package:moniz/screens/entries/Entries.dart";
import "package:moniz/screens/entries/EntryEditor.dart";
import "package:moniz/screens/homescreen/DateSort.dart";
import "package:moniz/screens/homescreen/DotsMenu.dart";
import "package:moniz/screens/homescreen/Filters.dart";
import "package:moniz/screens/manage/Manage.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;

  late PageController _pageController;
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }
    _pageController.jumpToPage(
      index,
    );
    _controller.reset();
    _controller.forward();
  }

  List<NavigationDestination> navDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.my_library_books_outlined),
      selectedIcon: Icon(Icons.my_library_books_rounded),
      label: "Entries",
    ),
    NavigationDestination(
      icon: Icon(Icons.pie_chart_outline_rounded),
      selectedIcon: Icon(Icons.pie_chart_rounded),
      label: "Analysis",
    ),
    NavigationDestination(
      icon: Icon(Icons.category_outlined),
      selectedIcon: Icon(Icons.category_rounded),
      label: "Manage",
    ),
  ];

  List<Widget> widgetOptions = <Widget>[
    const Overview(),
    const Analysis(),
    const Manage(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<GlobalKey> listOfKeys;
  late Animation<double> fadeAnimation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();
    _selectedIndex = ref.read(initialPageProvider);
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    // ? It's read here and watch elsewhere because this code is executed only once while the others are part of build
    listOfKeys = ref.read(entriesGkListProvider);
    if (!ref.read(entriesTutorialCompletedProvider)) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(tutorialProvider)(context, Screen.entries);
        ref
            .read(entriesTutorialCompletedProvider.notifier)
            .update((state) => true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var globalRange = ref.watch(globalDateRangeProvider);
    var globalRangeUpdater = ref.watch(globalDateRangeProvider.notifier).update;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // ? Hides the back button when the bottom sheet pops up
        automaticallyImplyLeading: false,
        title: Text(
          "${DateFormat("d MMM yy").format(globalRange.start)} - ${DateFormat("d MMM yy").format(globalRange.end)}",
          key: listOfKeys[0],
        ),

        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
            child: _selectedIndex == 0
                ? IconButton.filledTonal(
                    key: listOfKeys[3],
                    tooltip: "Filters",
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () {
                      scaffoldKey.currentState!
                          .showBottomSheet((context) => const Filters());
                    },
                  )
                : const SizedBox(
                    key: Key("1"),
                  ),
          ),
          DateSort(key: listOfKeys[1], globalRangeUpdater: globalRangeUpdater),
          DotsMenu(key: listOfKeys[2], scaffoldKey: scaffoldKey),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: true,
      floatingActionButton: OpenContainer(
          // transitionDuration: Duration(seconds: 2),
          closedColor: Theme.of(context).colorScheme.primaryContainer,
          middleColor: Theme.of(context).colorScheme.primaryContainer,
          openColor: Theme.of(context).colorScheme.background,
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 5.0,
          openShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          closedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          closedBuilder: (_, openContainer) {
            return FloatingActionButton.extended(
              heroTag: null,
              key: listOfKeys[4],
              // ? OpenContainer has its own elevation
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              onPressed: openContainer,
              label: const Text("New Entry"),
              icon: const Icon(Icons.add),
            );
          },
          openBuilder: (_, closeContainer) {
            return const EntryEditor();
          }),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _onItemTapped(index);
          });
        },
        selectedIndex: _selectedIndex,
        destinations: navDestinations,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: widgetOptions
            .map((e) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                        .animate(
                  CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOutCubicEmphasized),
                ),
                child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeInOutCubicEmphasized)),
                    child: e)))
            .toList(),
      ),
    );
  }
}
