import "package:envied/envied.dart";

part "env.g.dart";

@Envied()
abstract class Env {
  @EnviedField(varName: "MAPBOX_APIKEY")
  static const String mapboxApikey = _Env.mapboxApikey;
}
