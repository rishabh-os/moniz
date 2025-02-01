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
              child: const MarkerIcon(),
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
          const ListTile(
            title: Text("Cluster Map"),
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
                          color: Theme.of(context).colorScheme.primary,
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
