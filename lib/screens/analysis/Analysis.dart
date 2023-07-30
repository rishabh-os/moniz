import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moniz/screens/analysis/LineGraph.dart';
import 'package:moniz/screens/analysis/PieChart.dart';
import 'package:moniz/data/SimpleStore/tutorialStore.dart';
import 'package:moniz/data/transactions.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Analysis extends ConsumerStatefulWidget {
  const Analysis({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisState();
}

class _AnalysisState extends ConsumerState<Analysis>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Widget display;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (ref.watch(transactionsProvider).isEmpty) {
      display = Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            "No entries found! Try adding a new transaction below or changing the date range above",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.85)),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      List<GlobalKey> listOfKeys = ref.read(analysisGkListProvider);
      display = DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                VisibilityDetector(
                  key: listOfKeys[0],
                  onVisibilityChanged: (info) {
                    if (ref.watch(analysisTutorialCompletedProvider)()) {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (info.visibleFraction == 1) {
                          ref.read(tutorialProvider)(context, Screen.analysis);
                        }
                      });
                    }
                  },
                  child: const Tab(icon: Icon(Icons.pie_chart_rounded)),
                ),
                Tab(
                    key: listOfKeys[1],
                    icon: const Icon(Icons.bar_chart_rounded)),
              ],
            ),
            const SizedBox(
              height: 500,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CategoryChart(),
                  SpendsByDay(),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return display;
  }
}
