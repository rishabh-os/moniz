import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/debouncer.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/env/env.dart";
import "package:url_launcher/url_launcher.dart";

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({
    super.key,
    required this.initialLocation,
    required this.returnSelectedLocation,
  });
  final GMapsPlace? initialLocation;
  final Function(GMapsPlace location) returnSelectedLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  GMapsPlace? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final GMapsPlace? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              // ? This is prop drilling and bad I know
              return LocationMap(
                initialLocation: widget.initialLocation,
              );
            },
          ),
        );
        if (result != null) {
          setState(() {
            selectedLocation = result;
            widget.returnSelectedLocation(selectedLocation!);
          });
        }
      },
      label: selectedLocation == null
          ? const Text("Add Location")
          : Text(selectedLocation!.displayName!.text ?? ""),
      icon: const Icon(
        Icons.location_on,
        size: 16,
      ),
    );
  }
}

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({
    super.key,
    required this.initialLocation,
  });
  final GMapsPlace? initialLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationMapState();
}

class _LocationMapState extends ConsumerState<LocationMap>
    with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    curve: Curves.easeInOutCubicEmphasized,
  );
  AlignOnUpdate _alignPositionOnUpdate = AlignOnUpdate.once;
  GMapsResponse? suggestions;

  Future<GMapsResponse?> fetchResponse(String input) async {
    final mapCenter = animatedMapController.mapController.camera.center;
    // ? Update stored mapCenter on search
    ref.read(initialCenterProvider.notifier).state = mapCenter;
    // ? Notice the order of lat and long smh
    final Map locationBias = {
      "circle": {
        "center": {
          "latitude": mapCenter.latitude,
          "longitude": mapCenter.longitude,
        },
        "radius": 500.0,
      },
    };
    if (input == "") {
      return null;
    }
    final response = await http.post(
      Uri.parse("https://places.googleapis.com/v1/places:searchText"),
      body: jsonEncode({
        "textQuery": input,
        "maxResultCount": 5,
        "locationBias": locationBias,
      }),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": Env.googleMapsApikey,
        // ? Requesting only the fields we need here
        "X-Goog-Fieldmask":
            "places.displayName,places.formattedAddress,places.location,places.googleMapsUri",
      },
    );

    if (response.statusCode == 200) {
      final responseObject = GMapsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      responseObject.places?.forEach((element) {});
      return responseObject;
    } else {
      throw Exception(response.body);
    }
  }

  GMapsPlace? selectedLocation;
  late final Future<GMapsResponse?> Function(String) debouncedSearch;
  final SearchController _searchController = SearchController();
  late LatLng initialCenter;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    debouncedSearch = debounce(fetchResponse);
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
      appBar: AppBar(
        title: const Text("Pick Location"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: animatedMapController.mapController,
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
                tileProvider:
                    CancellableNetworkTileProvider(silenceExceptions: true),
              ),
              MarkerLayer(
                markers: selectedLocation != null
                    ? [
                        Marker(
                          point: LatLng(
                            selectedLocation!.location!.latitude ??
                                animatedMapController
                                    .mapController.camera.center.latitude,
                            selectedLocation!.location!.longitude ??
                                animatedMapController
                                    .mapController.camera.center.longitude,
                          ),
                          child: Icon(
                            Icons.place,
                            size: 36,
                            color: Theme.of(context).colorScheme.primary,
                            shadows: [
                              Shadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 30,
                              ),
                            ],
                          ),
                        ),
                      ]
                    : [],
              ),
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                SearchAnchor.bar(
                  searchController: _searchController,
                  viewLeading: IconButton(
                    onPressed: () async {
                      _searchController.closeView(_searchController.text);
                      await Future.delayed(
                        50.ms,
                        () => FocusScope.of(context).unfocus(),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  isFullScreen: false,
                  barHintText: "Search for a nearby location",
                  suggestionsBuilder: (context, controller) async {
                    final results = await debouncedSearch(controller.text);
                    final List<ListTile> resultList = results?.places
                            ?.map(
                              (location) => resultTile(location, controller),
                            )
                            .toList() ??
                        [];
                    return resultList;
                  },
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: SelectedResult(
                      selectedLocation: selectedLocation,
                      ref: ref,
                    ),
                  )
                      .animate(
                        target: selectedLocation != null ? 1 : 0,
                      )
                      .fadeIn(duration: 250.ms, curve: Curves.easeInOutCubic)
                      .slideY(),
                ),
              ],
            ),
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
            (Icons.add, animatedMapController.animatedZoomIn),
            (Icons.remove, animatedMapController.animatedZoomOut),
            (
              Icons.restart_alt_rounded,
              animatedMapController.animatedRotateReset,
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

  ListTile resultTile(GMapsPlace location, SearchController controller) {
    return ListTile(
      onTap: () async {
        animatedMapController.animateTo(
          rotation: 0,
          dest: LatLng(
            location.location!.latitude ??
                animatedMapController.mapController.camera.center.latitude,
            location.location!.longitude ??
                animatedMapController.mapController.camera.center.longitude,
          ),
        );
        controller.closeView(null);

        setState(() {
          selectedLocation = location;
        });
        // ? This is very hacky but none of the other solutions work so
        await Future.delayed(
          50.ms,
          () => FocusScope.of(context).unfocus(),
        );
      },
      title: Text(
        location.displayName!.text ?? "",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        location.formattedAddress ?? "",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          launchUrl(Uri.parse(location.googleMapsUri!));
        },
        icon: const Icon(Icons.open_in_new_rounded),
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
