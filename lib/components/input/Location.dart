import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";
import "package:location/location.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/debouncer.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/env/env.dart";

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker(
      {super.key,
      required this.initialLocation,
      required this.returnSelectedLocation});
  final LocationFeature? initialLocation;
  final Function(LocationFeature location) returnSelectedLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  LocationFeature? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: () async {
          LocationFeature? result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            // ? This is prop drilling and bad I know
            return LocationMap(
              initialLocation: widget.initialLocation,
            );
          }));
          if (result != null) {
            setState(() {
              selectedLocation = result;
              widget.returnSelectedLocation(selectedLocation!);
            });
          }
        },
        label: selectedLocation == null
            ? const Text("Add Location")
            : Text(selectedLocation!.text ?? ""),
        icon: const Icon(
          Icons.location_on,
          size: 16,
        ));
  }
}

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({
    super.key,
    required this.initialLocation,
  });
  final LocationFeature? initialLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationMapState();
}

class _LocationMapState extends ConsumerState<LocationMap>
    with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
  LocationData? locationData;
  MapBoxGeocoding? suggestions;

  final TextEditingController searchController = TextEditingController();

  Future<MapBoxGeocoding?> fetchResponse(String input) async {
    final mapCenter = animatedMapController.mapController.camera.center;
    // ? Update stored mapCenter on search
    ref.read(initialCenterProvider.notifier).state = mapCenter;
    // ? Notice the order of lat and long smh
    final String proximity = "${mapCenter.longitude},${mapCenter.latitude}";
    if (input == "") {
      return null;
    }
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeFull(input)}.json?&proximity=$proximity&access_token=${Env.mapboxApikey}"));

    if (response.statusCode == 200) {
      final responseObject = MapBoxGeocoding.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      responseObject.features?.forEach((element) {});
      return responseObject;
    } else {
      throw Exception(response.body);
    }
  }

  LocationFeature? selectedLocation;
  late final Future<MapBoxGeocoding?> Function(String) debouncedSearch;
  late LatLng initialCenter;

  @override
  void initState() {
    super.initState();
    debouncedSearch = debounce(fetchResponse);
    initialCenter = ref.read(initialCenterProvider);
    if (widget.initialLocation != null) {
      selectedLocation = widget.initialLocation;
      List<double> selectedCenter = selectedLocation!.center!;
      Future.delayed(0.ms, () {
        ref.read(initialCenterProvider.notifier).state =
            LatLng(selectedCenter.last, selectedCenter.first);
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
              initialZoom: 15,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.moniz",
              ),
              MarkerLayer(
                  markers: selectedLocation != null
                      ? [
                          Marker(
                              point: LatLng(
                                  selectedLocation!.center?.last ??
                                      animatedMapController
                                          .mapController.camera.center.latitude,
                                  selectedLocation!.center?.first ??
                                      animatedMapController.mapController.camera
                                          .center.longitude),
                              child: Icon(
                                Icons.place,
                                size: 36,
                                color: Theme.of(context).colorScheme.primary,
                                shadows: [
                                  Shadow(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      blurRadius: 10)
                                ],
                              ))
                        ]
                      : []),
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
                    barHintText: "Search for a nearby location",
                    suggestionsBuilder: (context, controller) async {
                      final results = await debouncedSearch(controller.text);
                      List<ListTile> resultList = results?.features
                              ?.map((location) =>
                                  resultTile(location, controller))
                              .toList() ??
                          [];
                      controller.text.isNotEmpty
                          ? resultList.add(resultTile(
                              LocationFeature(
                                text: controller.text,
                                placeName: "Custom Location",
                              ),
                              controller))
                          : null;
                      return resultList;
                    }),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: ListTile(
                      onTap: () {
                        final mapCenter =
                            animatedMapController.mapController.camera.center;
                        // ? Update stored mapCenter on location select
                        ref.read(initialCenterProvider.notifier).state =
                            mapCenter;

                        Navigator.of(context).pop(selectedLocation);
                      },
                      title: Text(
                        selectedLocation?.text ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        selectedLocation?.placeName ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.check_circle_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.my_location),
          onPressed: () async {
            Location location = Location();

            bool serviceEnabled;
            PermissionStatus permissionGranted;

            serviceEnabled = await location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await location.requestService();
              if (!serviceEnabled) {
                return;
              }
            }

            permissionGranted = await location.hasPermission();
            if (permissionGranted == PermissionStatus.denied) {
              permissionGranted = await location.requestPermission();
              if (permissionGranted != PermissionStatus.granted) {
                return;
              }
            }

            locationData = await location.getLocation();
            animatedMapController.animateTo(
                dest:
                    LatLng(locationData!.latitude!, locationData!.longitude!));
          }),
    );
  }

  ListTile resultTile(LocationFeature location, SearchController controller) {
    return ListTile(
      onTap: () {
        animatedMapController.animateTo(
            dest: LatLng(
                location.center?.last ??
                    animatedMapController.mapController.camera.center.latitude,
                location.center?.first ??
                    animatedMapController
                        .mapController.camera.center.longitude),
            zoom: 16,
            curve: const Cubic(0, 0, 0, 1.0));
        controller.closeView(null);
        setState(() {
          selectedLocation = location;
        });
      },
      title: Text(
        location.text ?? "",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        location.placeName ?? "",
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
