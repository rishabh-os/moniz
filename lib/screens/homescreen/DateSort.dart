import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/transactions.dart";

class DateSort extends ConsumerStatefulWidget {
  const DateSort({
    super.key,
    required this.listOfKeys,
    required this.globalRangeUpdater,
  });

  final List<GlobalKey<State<StatefulWidget>>> listOfKeys;
  final DateTimeRange Function(DateTimeRange Function(DateTimeRange state) cb)
      globalRangeUpdater;

  @override
  ConsumerState<DateSort> createState() => _DateSortState();
}

class _DateSortState extends ConsumerState<DateSort> {
  List<PopupMenuItem<String>> items =
      ["Last week", "Last 2 weeks", "Last month", "Everything", "Custom"]
          .map((e) => PopupMenuItem(
              value: e,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(e),
              )))
          .toList();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: widget.listOfKeys[2],
      tooltip: "Select a range",
      icon: const Icon(Icons.calendar_today_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) async {
        switch (value) {
          case "Last week":
            widget.globalRangeUpdater((state) => DateTimeRange(
                start: DateTime.now().copyWith(
                    day: DateTime.now().day - 7,
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0),
                // ? This allows entries on the selected day to be shown
                end: DateTime.now().add(const Duration(days: 1))));
            break;
          case "Last 2 weeks":
            widget.globalRangeUpdater((state) => DateTimeRange(
                start: DateTime.now().copyWith(
                    day: DateTime.now().day - 14,
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0),
                // ? This allows entries on the selected day to be shown
                end: DateTime.now().add(const Duration(days: 1))));
            break;
          case "Last month":
            widget.globalRangeUpdater((state) => DateTimeRange(
                start: DateTime.now().copyWith(
                    month: DateTime.now().month - 1,
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0),
                // ? This allows entries on the selected day to be shown
                end: DateTime.now().add(const Duration(days: 1))));
            break;
          case "Everything":
            DateTime oldestDate = ref
                .read(allTransProvider)
                .map<DateTime>((e) => e.recorded)
                .reduce((min, e) => e.isBefore(min) ? e : min);
            widget.globalRangeUpdater((state) => DateTimeRange(
                start: oldestDate.copyWith(
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0),
                // ? This allows entries on the selected day to be shown
                end: DateTime.now().add(const Duration(days: 1))));
            break;
          case "Custom":
            final DateTimeRange? selectedRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2040),
              currentDate: DateTime.now(),
              initialDateRange: ref.watch(globalDateRangeProvider),
              builder: (BuildContext context, Widget? child) {
                return child!;
              },
            );
            if (selectedRange != null) {
              widget.globalRangeUpdater((state) => selectedRange);
            }
            break;
        }
        ref.read(transactionsProvider.notifier).filterTransactions();
      },
      itemBuilder: (context) => items,
    );
  }
}