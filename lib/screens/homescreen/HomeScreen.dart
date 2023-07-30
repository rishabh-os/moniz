import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moniz/screens/accounts/Accounts.dart';
import 'package:moniz/screens/entries/EntryEditor.dart';
import 'package:moniz/screens/analysis/Analysis.dart';
import 'package:moniz/data/SimpleStore/basicStore.dart';
import 'package:moniz/data/SimpleStore/tutorialStore.dart';
import 'package:moniz/screens/homescreen/DotsMenu.dart';
import 'package:moniz/screens/homescreen/QuickFilters.dart';
import 'package:moniz/components/DateTimePickers.dart';
import 'package:moniz/screens/entries/Entries.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController(
    initialPage: 0,
  );
  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  List<NavigationDestination> navDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.my_library_books_outlined),
      selectedIcon: Icon(Icons.my_library_books_rounded),
      label: 'Entries',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet_rounded),
      label: 'Accounts',
    ),
    NavigationDestination(
      icon: Icon(Icons.pie_chart_outline_rounded),
      selectedIcon: Icon(Icons.pie_chart_rounded),
      label: 'Analysis',
    ),
  ];

  List<Widget> widgetOptions = <Widget>[
    const Overview(),
    const Accounts(),
    const Analysis(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<GlobalKey> listOfKeys;

  @override
  void initState() {
    super.initState();
    // ? It's read here and watch elsewhere because this code is executed only once while the others are part of build
    listOfKeys = ref.read(entriesGkListProvider);
    if (ref.read(entriesTutorialCompletedProvider)()) {
      Future.delayed(const Duration(milliseconds: 100),
          () => ref.read(tutorialProvider)(context, Screen.entries));
    }
  }

  @override
  Widget build(BuildContext context) {
    var x = ref.watch(globalDateRangeProvider);
    var y = ref.watch(globalDateRangeProvider.notifier).update;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // ? Hides the back button when the bottom sheet pops up
        automaticallyImplyLeading: false,
        title: Text(
          "${DateFormat("d MMM yy").format(x.start)} - ${DateFormat("d MMM yy").format(x.end)}",
          key: listOfKeys[0],
        ),

        actions: [
          Container(key: listOfKeys[1], child: const DateRangePicker()),
          QuickFilters(listOfKeys: listOfKeys, y: y),
          DotsMenu(listOfKeys: listOfKeys, scaffoldKey: scaffoldKey),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
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
            _selectedIndex = index;
            _onItemTapped(index);
          });
        },
        selectedIndex: _selectedIndex,
        destinations: navDestinations,
      ),
      body: PageView(
        controller: _pageController,
        // physics: const NeverScrollableScrollPhysics(),
        // TODO Solve the middle nav icon getting selected on transition
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: widgetOptions,
      ),
    );
  }
}
