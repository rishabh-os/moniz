import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/data/transactions.dart';

class QuickFilters extends ConsumerStatefulWidget {
  const QuickFilters({
    super.key,
    required this.listOfKeys,
    required this.y,
  });

  final List<GlobalKey<State<StatefulWidget>>> listOfKeys;
  final DateTimeRange Function(DateTimeRange Function(DateTimeRange state) cb)
      y;

  @override
  ConsumerState<QuickFilters> createState() => _QuickFiltersState();
}

class _QuickFiltersState extends ConsumerState<QuickFilters> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: widget.listOfKeys[2],
      tooltip: "Quick filters",
      icon: const Icon(Icons.filter_alt_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) async {
        if (value == "week") {
          widget.y((state) => DateTimeRange(
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
          widget.y((state) => DateTimeRange(
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
          widget.y((state) => DateTimeRange(
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
          widget.y((state) => DateTimeRange(
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
