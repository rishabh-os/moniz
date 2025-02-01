import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/components/input/Location.dart";
import "package:moniz/components/input/Map.dart";
import "package:moniz/data/transactions.dart";

class Heatmap extends ConsumerStatefulWidget {
  const Heatmap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeatmapState();
}

class _HeatmapState extends ConsumerState<Heatmap>
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
      child: LocationMap(
        animatedMapController: animatedMapController,
        initialLocation: null,
        layers: [
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: markers,
              builder: (context, markers) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                );
              },
              popupOptions: PopupOptions(
                popupController: popupController,
                buildPopupOnHover: true,
                markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                popupBuilder: (context, marker) {
                  final String transID =
                      (marker.key! as ValueKey).value as String;
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 40,
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          transactions
                                  .firstWhereOrNull(
                                    (element) => element.id == transID,
                                  )
                                  ?.title ??
                              "No title",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
