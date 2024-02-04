// ignore_for_file: avoid_print

import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";
import "package:location/location.dart";
import "package:moniz/data/api/debouncer.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/env/env.dart";

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LocationMap();
          }));
        },
        label: const Text("Pick Location"),
        icon: const Icon(Icons.add_location_rounded));
  }
}

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({super.key});

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
    print(mapCenter);
    final String proximity = "${mapCenter.latitude},${mapCenter.longitude}";
    if (input == "") {
      return null;
    }
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeFull(input)}.json?&proximity=$proximity&access_token=${Env.mapboxApikey}"));
    if (response.statusCode == 200) {
      final responseObject = MapBoxGeocoding.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      responseObject.features?.forEach((element) {
        print(element.text);
      });
      return responseObject;
    } else {
      throw Exception(response.body);
    }
  }

  Features? selectedLocation;
  late final Future<MapBoxGeocoding?> Function(String) debouncedSearch;

  @override
  void initState() {
    super.initState();
    debouncedSearch = debounce(fetchResponse);
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
            options: const MapOptions(
              initialCenter: LatLng(46.0748, 11.1217),
              initialZoom: 12,
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
                              Features(
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
                      onTap: () => {Navigator.of(context).pop()},
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
            print(locationData);
            animatedMapController.animateTo(
                dest:
                    LatLng(locationData!.latitude!, locationData!.longitude!));
          }),
    );
  }

  ListTile resultTile(Features location, SearchController controller) {
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
