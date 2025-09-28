import "dart:developer";

import "package:flutter/services.dart";
import "package:posthog_flutter/posthog_flutter.dart";

Future<void> postHogCapture({
  required String eventName,
  Map<String, Object>? properties,
}) async {
  try {
    await Posthog().capture(eventName: eventName, properties: properties);
  } on MissingPluginException {
    log("Not implemented for Linux");
  }
}
