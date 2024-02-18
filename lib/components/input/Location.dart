import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";
import "package:location/location.dart" as location_service;
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/debouncer.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/env/env.dart";
import "package:url_launcher/url_launcher.dart";

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker(
      {super.key,
      required this.initialLocation,
      required this.returnSelectedLocation});
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
          GMapsPlace? result = await Navigator.push(context,
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
            : Text(selectedLocation!.displayName!.text ?? ""),
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
  final GMapsPlace? initialLocation;

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
  location_service.LocationData? locationData;
  GMapsResponse? suggestions;

  final TextEditingController searchController = TextEditingController();

  Future<GMapsResponse?> fetchResponse(String input) async {
    final mapCenter = animatedMapController.mapController.camera.center;
    // ? Update stored mapCenter on search
    ref.read(initialCenterProvider.notifier).state = mapCenter;
    // ? Notice the order of lat and long smh
    final Map locationBias = {
      "circle": {
        "center": {
          "latitude": mapCenter.latitude,
          "longitude": mapCenter.longitude
        },
        "radius": 500.0
      }
    };
    if (input == "") {
      return null;
    }
    final response = await http.post(
        Uri.parse("https://places.googleapis.com/v1/places:searchText"),
        body: jsonEncode({
          "textQuery": input,
          "maxResultCount": 5,
          "locationBias": locationBias
        }),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": Env.googleMapsApikey,
          // ? Requesting only the fields we need here
          "X-Goog-Fieldmask":
              "places.displayName,places.formattedAddress,places.location,places.googleMapsUri"
        });

    if (response.statusCode == 200) {
      final responseObject = GMapsResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      responseObject.places?.forEach((element) {});
      return responseObject;
    } else {
      throw Exception(response.body);
    }
  }

  GMapsPlace? selectedLocation;
  late final Future<GMapsResponse?> Function(String) debouncedSearch;
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
      Location selectedCenter = selectedLocation!.location!;
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
              initialZoom: 15,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.rishabhos.moniz",
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
                    isFullScreen: false,
                    barHintText: "Search for a nearby location",
                    suggestionsBuilder: (context, controller) async {
                      final results = await debouncedSearch(controller.text);
                      List<ListTile> resultList = results?.places
                              ?.map((location) =>
                                  resultTile(location, controller))
                              .toList() ??
                          [];
                      return resultList;
                    }),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: ListTile(
                      onTap: () {
                        final mapCenter = LatLng(
                            selectedLocation!.location!.latitude ?? 0,
                            selectedLocation!.location!.longitude ?? 0);
                        // ? Update stored mapCenter on location select
                        ref.read(initialCenterProvider.notifier).state =
                            mapCenter;
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
                              launchUrl(
                                  Uri.parse(selectedLocation!.googleMapsUri!));
                            },
                            icon: const Icon(Icons.open_in_new_rounded),
                          ),
                          Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
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
            location_service.Location location = location_service.Location();

            bool serviceEnabled;
            location_service.PermissionStatus permissionGranted;

            serviceEnabled = await location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await location.requestService();
              if (!serviceEnabled) {
                return;
              }
            }

            permissionGranted = await location.hasPermission();
            if (permissionGranted == location_service.PermissionStatus.denied) {
              permissionGranted = await location.requestPermission();
              if (permissionGranted !=
                  location_service.PermissionStatus.granted) {
                Widget errorToast = Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    // ignore: use_build_context_synchronously
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                  child: const Text(
                    "Location permission denied.\n Please change it in settings.",
                    softWrap: true,
                  ),
                );
                fToast.showToast(
                  child: errorToast,
                  gravity: ToastGravity.BOTTOM,
                  // toastDuration: 5.seconds,
                );
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

  ListTile resultTile(GMapsPlace location, SearchController controller) {
    return ListTile(
      onTap: () async {
        animatedMapController.animateTo(
            dest: LatLng(
                location.location!.latitude ??
                    animatedMapController.mapController.camera.center.latitude,
                location.location!.longitude ??
                    animatedMapController
                        .mapController.camera.center.longitude),
            curve: Curves.easeInOutCubicEmphasized);
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
