import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/response.dart";
import "package:url_launcher/url_launcher.dart";

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({
    super.key,
    required this.animatedMapController,
    required this.initialLocation,
    required this.layers,
  });
  final AnimatedMapController animatedMapController;
  final GMapsPlace? initialLocation;
  final List<Widget> layers;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationMapState();
}

class _LocationMapState extends ConsumerState<LocationMap>
    with TickerProviderStateMixin {
  AlignOnUpdate _alignPositionOnUpdate = AlignOnUpdate.once;

  GMapsPlace? selectedLocation;
  late LatLng initialCenter;

  @override
  void initState() {
    super.initState();
    initialCenter = ref.read(initialCenterProvider);
    if (widget.initialLocation != null) {
      selectedLocation = widget.initialLocation;
      final Location selectedCenter = selectedLocation!.location!;
      Future.delayed(0.ms, () {
        ref.read(initialCenterProvider.notifier).state =
            LatLng(selectedCenter.latitude ?? 0, selectedCenter.longitude ?? 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: widget.animatedMapController.mapController,
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 16,
          maxZoom: 22,
          onPositionChanged: (position, hasGesture) => {
            // ? Stop following the location on any gesture
            if (hasGesture && _alignPositionOnUpdate != AlignOnUpdate.never)
              {
                setState(
                  () => _alignPositionOnUpdate = AlignOnUpdate.never,
                ),
              },
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
            onPressed: () async {
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

class SelectedResult extends StatelessWidget {
  const SelectedResult({
    super.key,
    required this.selectedLocation,
    required this.ref,
  });

  final GMapsPlace? selectedLocation;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final mapCenter = LatLng(
          selectedLocation!.location!.latitude ?? 0,
          selectedLocation!.location!.longitude ?? 0,
        );
        // ? Update stored mapCenter on location select
        ref.read(initialCenterProvider.notifier).state = mapCenter;
        Navigator.of(context).pop(selectedLocation);
      },
      title: Text(
        selectedLocation?.displayName!.text ?? "",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        selectedLocation?.formattedAddress ?? "",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              launchUrl(Uri.parse(selectedLocation!.googleMapsUri!));
            },
            icon: const Icon(Icons.open_in_new_rounded),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
