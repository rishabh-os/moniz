import "package:envied/envied.dart";

part "env.g.dart";

@Envied()
abstract class Env {
  @EnviedField(varName: "MAPBOX_APIKEY")
  static const String mapboxApikey = _Env.mapboxApikey;
  @EnviedField(varName: "GOOGLE_MAPS_APIKEY")
  static const String googleMapsApikey = _Env.googleMapsApikey;
  @EnviedField(varName: "POSTHOG_APIKEY")
  static const String posthogApikey = _Env.posthogApikey;
}
