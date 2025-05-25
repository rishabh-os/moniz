import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({
    super.key,
    required this.animatedMapController,
    required this.initialCenter,
    required this.layers,
  });
  final AnimatedMapController animatedMapController;
  final LatLng initialCenter;
  final List<Widget> layers;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationMapState();
}

class _LocationMapState extends ConsumerState<LocationMap>
    with TickerProviderStateMixin {
  AlignOnUpdate _alignPositionOnUpdate = AlignOnUpdate.once;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: widget.animatedMapController.mapController,
        options: MapOptions(
          initialCenter: widget.initialCenter,
          initialZoom: 16,
          maxZoom: 22,
          onPositionChanged: (position, hasGesture) {
            ref.read(initialCenterProvider.notifier).state = position.center;
            // ? Stop following the location on any gesture
            if (hasGesture && _alignPositionOnUpdate != AlignOnUpdate.never) {
              setState(
                () => _alignPositionOnUpdate = AlignOnUpdate.never,
              );
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}@2x.png?key=iVYN0Z0Hxh10yhJtDCbk",
            userAgentPackageName: "com.rishabhos.moniz",
          ),
          ...widget.layers,
          // ? The underlying geolocation package doesn't support Linux
          if (!Platform.isLinux)
            CurrentLocationLayer(
              alignPositionOnUpdate: _alignPositionOnUpdate,
            ),
          const RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            attributions: [
              TextSourceAttribution(
                "Mapbox",
              ),
              TextSourceAttribution(
                "OpenStreetMap contributors",
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          ...[
            (Icons.add, widget.animatedMapController.animatedZoomIn),
            (Icons.remove, widget.animatedMapController.animatedZoomOut),
            (
              Icons.restart_alt_rounded,
              widget.animatedMapController.animatedRotateReset,
            ),
          ].map(
            (e) => PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              elevation: 4,
              child: IconButton.filled(
                icon: Icon(e.$1),
                visualDensity: VisualDensity.compact,
                onPressed: () => e.$2(),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.my_location),
            onPressed: () {
              // ? Follow location on tap
              setState(
                () => _alignPositionOnUpdate = AlignOnUpdate.always,
              );
            },
          ),
        ],
      ),
    );
  }
}
