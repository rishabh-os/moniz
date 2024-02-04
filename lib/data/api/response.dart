class MapBoxGeocoding {
  String? type;
  List<String>? query;
  List<Features>? features;
  String? attribution;

  MapBoxGeocoding({this.type, this.query, this.features, this.attribution});

  MapBoxGeocoding.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    query = json["query"].cast<String>();
    if (json["features"] != null) {
      features = <Features>[];
      json["features"].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    attribution = json["attribution"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["query"] = query;
    if (features != null) {
      data["features"] = features!.map((v) => v.toJson()).toList();
    }
    data["attribution"] = attribution;
    return data;
  }
}

class Features {
  String? id;
  String? type;
  List<String>? placeType;
  num? relevance;
  Properties? properties;
  String? text;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;
  List<double>? bbox;

  Features(
      {this.id,
      this.type,
      this.placeType,
      this.relevance,
      this.properties,
      this.text,
      this.placeName,
      this.center,
      this.geometry,
      this.context,
      this.bbox});

  Features.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    placeType = json["place_type"].cast<String>();
    relevance = json["relevance"];
    properties = json["properties"] != null
        ? Properties.fromJson(json["properties"])
        : null;
    text = json["text"];
    placeName = json["place_name"];
    center = json["center"].cast<double>();
    geometry =
        json["geometry"] != null ? Geometry.fromJson(json["geometry"]) : null;
    if (json["context"] != null) {
      context = <Context>[];
      json["context"].forEach((v) {
        context!.add(Context.fromJson(v));
      });
    }
    if (json["bbox"] != null) {
      bbox = json["bbox"].cast<double>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["type"] = type;
    data["place_type"] = placeType;
    data["relevance"] = relevance;
    if (properties != null) {
      data["properties"] = properties!.toJson();
    }
    data["text"] = text;
    data["place_name"] = placeName;
    data["center"] = center;
    if (geometry != null) {
      data["geometry"] = geometry!.toJson();
    }
    if (context != null) {
      data["context"] = context!.map((v) => v.toJson()).toList();
    }
    data["bbox"] = bbox;
    return data;
  }
}

class Properties {
  String? foursquare;
  bool? landmark;
  String? address;
  String? category;
  String? maki;
  String? mapboxId;
  String? wikidata;

  Properties(
      {this.foursquare,
      this.landmark,
      this.address,
      this.category,
      this.maki,
      this.mapboxId,
      this.wikidata});

  Properties.fromJson(Map<String, dynamic> json) {
    foursquare = json["foursquare"];
    landmark = json["landmark"];
    address = json["address"];
    category = json["category"];
    maki = json["maki"];
    mapboxId = json["mapbox_id"];
    wikidata = json["wikidata"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["foursquare"] = foursquare;
    data["landmark"] = landmark;
    data["address"] = address;
    data["category"] = category;
    data["maki"] = maki;
    data["mapbox_id"] = mapboxId;
    data["wikidata"] = wikidata;
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json["coordinates"].cast<double>();
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["coordinates"] = coordinates;
    data["type"] = type;
    return data;
  }
}

class Context {
  String? id;
  String? mapboxId;
  String? text;
  String? wikidata;
  String? shortCode;

  Context({this.id, this.mapboxId, this.text, this.wikidata, this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    mapboxId = json["mapbox_id"];
    text = json["text"];
    wikidata = json["wikidata"];
    shortCode = json["short_code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["mapbox_id"] = mapboxId;
    data["text"] = text;
    data["wikidata"] = wikidata;
    data["short_code"] = shortCode;
    return data;
  }
}
