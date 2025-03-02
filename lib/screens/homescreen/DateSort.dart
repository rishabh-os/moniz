import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/transactions.dart";
import "package:posthog_flutter/posthog_flutter.dart";

class DateSort extends ConsumerStatefulWidget {
  const DateSort({
    super.key,
  });

  @override
  ConsumerState<DateSort> createState() => _DateSortState();
}

class _DateSortState extends ConsumerState<DateSort> {
  List<PopupMenuItem<String>> items =
      ["Last 7 days", "This month", "Last month", "Everything", "Custom"]
          .map(
            (e) => PopupMenuItem(
              value: e,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(e),
              ),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final globalRange = ref.watch(globalDateRangeProvider.notifier);
    return PopupMenuButton(
      tooltip: "Select a range",
      icon: const Icon(Icons.calendar_today_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) async {
        Posthog().capture(
          eventName: "Date sort",
          properties: {
            "value": value,
          },
        );
        switch (value) {
          case "Last 7 days":
            globalRange.state = DateTimeRange(
              start: now.copyWith(
                day: now.day - 7,
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              ),
              // ? This allows entries on the selected day to be shown
              end: now.add(const Duration(days: 1)),
            );
          case "This month":
            globalRange.state = DateTimeRange(
              start: now.copyWith(
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              ),
              // ? This allows entries on the selected day to be shown
              end: now.add(const Duration(days: 1)),
            );
          case "Last month":
            globalRange.state = DateTimeRange(
              start: now.copyWith(
                month: now.month - 1,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              ),
              // ? This allows entries on the selected day to be shown
              end: now.copyWith(
                month: now.month - 1,
                // * Not sure how exactly this works
                day: DateTime(now.year, now.month, 0).day,
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              ),
            );
          case "Everything":
            // ! This throws an error on a completely empty app because there are no entries so no oldest date
            final DateTime oldestDate = (await ref
                    .read(transactionsProvider.notifier)
                    .loadAllTransationsFromDB())
                .map<DateTime>((e) => e.recorded)
                .reduce((min, e) => e.isBefore(min) ? e : min);
            globalRange.state = DateTimeRange(
              start: oldestDate.copyWith(
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              ),
              // ? This allows entries on the selected day to be shown
              end: now.add(const Duration(days: 1)),
            );
          case "Custom":
            if (!context.mounted) return;
            final DateTimeRange? selectedRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2040),
              currentDate: now,
              initialDateRange: ref.watch(globalDateRangeProvider),
              builder: (BuildContext context, Widget? child) {
                return child!;
              },
            );
            if (selectedRange != null) {
              globalRange.state = selectedRange;
            }
        }
        ref.read(transactionsProvider.notifier).filterTransactions();
      },
      itemBuilder: (context) => items,
    );
  }
}
