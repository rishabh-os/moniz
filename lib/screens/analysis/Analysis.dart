import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:moniz/data/SimpleStore/tutorialStore.dart";
import "package:moniz/screens/analysis/LineGraph.dart";
import "package:moniz/screens/analysis/PieChart.dart";
import "package:visibility_detector/visibility_detector.dart";

class Analysis extends ConsumerStatefulWidget {
  const Analysis({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisState();
}

class _AnalysisState extends ConsumerState<Analysis> {
  late Widget display;
  @override
  Widget build(BuildContext context) {
    List<GlobalKey> listOfKeys = ref.read(analysisGkListProvider);
    display = DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            tabs: [
              VisibilityDetector(
                key: listOfKeys[0],
                onVisibilityChanged: (info) {
                  if (!ref.watch(analysisTutorialCompletedProvider)) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (info.visibleFraction == 1) {
                        ref.read(tutorialProvider)(context, Screen.analysis);
                      }
                    });
                    ref
                        .watch(analysisTutorialCompletedProvider.notifier)
                        .update((state) => true);
                  }
                },
                child: const Tab(icon: Icon(Icons.pie_chart_rounded)),
              ),
              Tab(
                  key: listOfKeys[1],
                  icon: const Icon(Icons.bar_chart_rounded)),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                CategoryChart(),
                LineGraph(),
              ],
            ),
          ),
        ],
      ),
    );

    return display;
  }
}
