import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moniz/components/ThemePicker.dart';
import 'package:moniz/accounts/Accounts.dart';
import 'package:moniz/components/EntryEditor.dart';
import 'package:moniz/Analysis/Analysis.dart';
import 'package:moniz/data/SimpleStore/basicStore.dart';
import 'package:moniz/data/SimpleStore/tutorialStore.dart';
import 'package:moniz/data/transactions.dart';
import 'package:moniz/small_components/DateTimePickers.dart';
import 'package:moniz/screens/Categories.dart';
import 'package:moniz/screens/Entries.dart';

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
          QuickFilters(listOfKeys: listOfKeys, y: y, ref: ref),
          PopupMenuButton(
            key: listOfKeys[3],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          ),
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

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    super.key,
    required this.listOfKeys,
    required this.y,
    required this.ref,
  });

  final List<GlobalKey<State<StatefulWidget>>> listOfKeys;
  final DateTimeRange Function(DateTimeRange Function(DateTimeRange state) cb)
      y;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: listOfKeys[2],
      tooltip: "Quick filters",
      icon: const Icon(Icons.filter_alt_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) async {
        if (value == "week") {
          y((state) => DateTimeRange(
              start: DateTime.now().copyWith(
                  day: DateTime.now().day - 7,
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0),
              // ? This allows entries on the selected day to be shown
              end: DateTime.now().add(const Duration(days: 1))));
          await ref.read(transactionsProvider.notifier).loadTransactions();
        } else if (value == "week2") {
          y((state) => DateTimeRange(
              start: DateTime.now().copyWith(
                  day: DateTime.now().day - 14,
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0),
              // ? This allows entries on the selected day to be shown
              end: DateTime.now().add(const Duration(days: 1))));
          await ref.read(transactionsProvider.notifier).loadTransactions();
        } else if (value == "month") {
          y((state) => DateTimeRange(
              start: DateTime.now().copyWith(
                  month: DateTime.now().month - 1,
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0),
              // ? This allows entries on the selected day to be shown
              end: DateTime.now().add(const Duration(days: 1))));
          await ref.read(transactionsProvider.notifier).loadTransactions();
        } else if (value == "month2") {
          y((state) => DateTimeRange(
              start: DateTime.now().copyWith(
                  month: DateTime.now().month - 2,
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0),
              // ? This allows entries on the selected day to be shown
              end: DateTime.now().add(const Duration(days: 1))));
          await ref.read(transactionsProvider.notifier).loadTransactions();
        }
      },
      itemBuilder: (context) => {
        "week": "Last week",
        "week2": "Last 2 weeks",
        "month": "Last month",
        "month2": "Last 2 months"
      }
          .entries
          .map(
            (e) => PopupMenuItem(
              value: e.key,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.value,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
