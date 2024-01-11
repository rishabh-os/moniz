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
    final String proximity = locationData != null
        ? "${locationData!.latitude},${locationData!.longitude}"
        : "ip";
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
                userAgentPackageName: "com.example.app",
              ),
              const RichAttributionWidget(
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
                TextField(
                  autofocus: true,
                  controller: searchController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "Search for a nearby location"),
                  onSubmitted: (value) async {
                    suggestions = await fetchResponse(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: ListView(
                      shrinkWrap: true,
                      children: suggestions?.features
                              ?.map((e) => ListTile(
                                    splashColor: Colors.red,
                                    onTap: () {},
                                    title: Text(
                                      e.text ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      e.placeName ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList() ??
                          []),
                )
                    .animate(target: searchController.text.isNotEmpty ? 1 : 0)
                    .fadeIn(duration: 250.ms),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        spacing: 10,
        alignment: WrapAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              fetchResponse("central park");
            },
            child: const Icon(Icons.dashboard_customize_outlined),
          ),
          FloatingActionButton(
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
              }),
        ],
      ),
    );
  }
}
