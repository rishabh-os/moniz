import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/components/input/Location.dart";
import "package:moniz/components/input/Map.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/SimpleStore/settingsStore.dart";
import "package:moniz/data/category.dart";
import "package:moniz/data/transactions.dart";
import "package:moniz/screens/entries/TransactionList.dart";

class ClusterMap extends ConsumerStatefulWidget {
  const ClusterMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClusterMapState();
}

class _ClusterMapState extends ConsumerState<ClusterMap>
    with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    curve: Curves.easeInOutCubicEmphasized,
  );
  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions = ref.watch(searchedTransProvider);
    final List<TransactionCategory> categories = ref.read(categoriesProvider);
    final bool colorMapIcons = ref.watch(colorMapIconsProvider);
    final List<Marker> markers = [];
    for (final trans in transactions) {
      if (trans.location != null) {
        final lat = trans.location!.location!.latitude;
        final lon = trans.location!.location!.longitude;

        if (lat != null && lon != null) {
          markers.add(
            Marker(
              key: ValueKey(trans.id),
              point: LatLng(lat, lon),
              child: MarkerIcon(
                color: colorMapIcons
                    ? Color(categories
                        .firstWhere(
                          (element) => element.id == trans.categoryID,
                        )
                        .color)
                    : null,
              ),
            ),
          );
        }
      }
    }
    final PopupController popupController = PopupController();
    return PopupScope(
      popupController: popupController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              "Location available data for",
            ),
            trailing: FilterChip(
              label: Text("${markers.length}/${transactions.length} "),
              onSelected: (value) {},
              selected: true,
              showCheckmark: false,
            ),
          ),
          Expanded(
            child: LocationMap(
              animatedMapController: animatedMapController,
              initialCenter: ref.read(initialCenterProvider),
              layers: [
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    markers: markers,
                    builder: (context, markers) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorMapIcons
                              ? averageColors(markers
                                  // ? Can't be null because I always assign it above
                                  .map((e) => (e.child as MarkerIcon).color!)
                                  .toList())
                              : Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      );
                    },
                    popupOptions: PopupOptions(
                      popupController: popupController,
                      markerTapBehavior:
                          MarkerTapBehavior.togglePopupAndHideRest(),
                      popupBuilder: (context, marker) {
                        final String transID =
                            (marker.key! as ValueKey).value as String;
                        final trans = transactions.firstWhereOrNull(
                          (element) => element.id == transID,
                        );
                        // ? Needed when you delete a transaction from this view
                        if (trans == null) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: TransactionListTile(transaction: trans),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Take the average of the colors in RGB by returning the square root of average of the squares
Color averageColors(List<Color> colors) {
  double totalA = 0;
  double totalR = 0;
  double totalG = 0;
  double totalB = 0;

  for (final color in colors) {
    totalA += pow(color.a, 2);
    totalR += pow(color.r, 2);
    totalG += pow(color.g, 2);
    totalB += pow(color.b, 2);
  }
  final count = colors.length;
  return Color.from(
    alpha: pow(totalA / count, 0.5).toDouble(),
    red: pow(totalR / count, 0.5).toDouble(),
    green: pow(totalG / count, 0.5).toDouble(),
    blue: pow(totalB / count, 0.5).toDouble(),
  );
}
