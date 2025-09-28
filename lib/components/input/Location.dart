import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_animations/flutter_map_animations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";
import "package:moniz/components/input/Map.dart";
import "package:moniz/data/SimpleStore/basicStore.dart";
import "package:moniz/data/api/debouncer.dart";
import "package:moniz/data/api/response.dart";
import "package:moniz/env/env.dart";
import "package:url_launcher/url_launcher.dart";

class LocationPickerButton extends ConsumerStatefulWidget {
  const LocationPickerButton({
    super.key,
    required this.initialLocation,
    required this.returnSelectedLocation,
  });
  final GMapsPlace? initialLocation;
  final void Function(GMapsPlace location) returnSelectedLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationPickerButtonState();
}

class _LocationPickerButtonState extends ConsumerState<LocationPickerButton> {
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
              return LocationPicker(initialLocation: widget.initialLocation);
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
      icon: const Icon(Icons.location_on, size: 16),
    );
  }
}

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({super.key, required this.initialLocation});
  final GMapsPlace? initialLocation;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker>
    with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(
    vsync: this,
    curve: Curves.easeInOutCubicEmphasized,
  );
  GMapsResponse? suggestions;

  Future<GMapsResponse?> fetchResponse(String input) async {
    final mapCenter = animatedMapController.mapController.camera.center;
    // ? Update stored mapCenter on search
    ref.read(initialCenterProvider.notifier).state = mapCenter;
    // ? Notice the order of lat and long smh
    final Map<String, dynamic> locationBias = {
      "circle": {
        "center": {
          "latitude": mapCenter.latitude,
          "longitude": mapCenter.longitude,
        },
        "radius": 200.0,
      },
    };
    final http.Response response;
    if (input.isEmpty) {
      response = await http.post(
        Uri.parse("https://places.googleapis.com/v1/places:searchNearby"),
        body: jsonEncode({
          "maxResultCount": 10,
          "locationRestriction": locationBias,
        }),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": Env.googleMapsApikey,
          // ? Requesting only the fields we need here
          "X-Goog-Fieldmask":
              "places.displayName,places.formattedAddress,places.location,places.googleMapsUri",
        },
      );
    } else {
      response = await http.post(
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
    }

    if (response.statusCode == 200) {
      final responseObject = GMapsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return responseObject;
    } else {
      throw Exception(response.body);
    }
  }

  GMapsPlace? selectedLocation;
  late final Future<GMapsResponse?> Function(String) debouncedSearch;
  final SearchController _searchController = SearchController();
  late LatLng initialCenter;

  @override
  void initState() {
    super.initState();
    debouncedSearch = debounce(fetchResponse);
    initialCenter = ref.read(initialCenterProvider);
    if (widget.initialLocation != null) {
      selectedLocation = widget.initialLocation;
      final Location selectedCenter = selectedLocation!.location!;
      initialCenter = LatLng(
        selectedCenter.latitude ?? 0,
        selectedCenter.longitude ?? 0,
      );
      Future.delayed(0.ms, () {
        ref.read(initialCenterProvider.notifier).state = initialCenter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Stack(
        children: [
          LocationMap(
            animatedMapController: animatedMapController,
            initialCenter: ref.read(initialCenterProvider),
            layers: [
              MarkerW(
                selectedLocation: selectedLocation,
                animatedMapController: animatedMapController,
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
                      await Future.delayed(50.ms, () {
                        if (!context.mounted) return;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  isFullScreen: false,
                  barHintText: "Search for a nearby location",
                  suggestionsBuilder: (context, controller) async {
                    final switchSearch = controller.text.isEmpty
                        ? fetchResponse
                        : debouncedSearch;
                    final results = await switchSearch(controller.text);
                    final List<Widget> resultList =
                        results?.places
                            ?.map(
                              (location) => resultTile(location, controller),
                            )
                            .toList() ??
                        [const LinearProgressIndicator()];

                    if (controller.text.isEmpty) {
                      resultList.insert(
                        0,
                        ListTile(
                          title: Center(
                            child: Text(
                              "Suggestions".toUpperCase(),
                              // ? It's never not mounted, just to remove the warning
                              style: context.mounted
                                  ? Theme.of(context).textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }
                    return resultList;
                  },
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child:
                      Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                            child: SelectedResult(
                              selectedLocation: selectedLocation,
                              ref: ref,
                            ),
                          )
                          .animate(target: selectedLocation != null ? 1 : 0)
                          .fadeIn(
                            duration: 250.ms,
                            curve: Curves.easeInOutCubic,
                          )
                          .slideY(),
                ),
              ],
            ),
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
        await Future.delayed(50.ms, () {
          if (!context.mounted) return;
          // ? Idk why the above check doesn't work here
          // ignore: use_build_context_synchronously
          FocusScope.of(context).unfocus();
        });
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

class MarkerW extends StatelessWidget {
  const MarkerW({
    super.key,
    required this.selectedLocation,
    required this.animatedMapController,
  });

  final GMapsPlace? selectedLocation;
  final AnimatedMapController animatedMapController;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: selectedLocation != null
          ? [
              Marker(
                point: LatLng(
                  selectedLocation!.location!.latitude ??
                      animatedMapController
                          .mapController
                          .camera
                          .center
                          .latitude,
                  selectedLocation!.location!.longitude ??
                      animatedMapController
                          .mapController
                          .camera
                          .center
                          .longitude,
                ),
                child: const MarkerIcon(),
              ),
            ]
          : [],
    );
  }
}

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.place,
      size: 36,
      color: color ?? Theme.of(context).colorScheme.primary,
      shadows: [
        Shadow(color: Theme.of(context).colorScheme.shadow, blurRadius: 1),
      ],
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
