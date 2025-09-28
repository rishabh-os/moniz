// ? Because most of this file was generated
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: invalid_assignment
// ignore_for_file: inference_failure_on_untyped_parameter
import "dart:convert";
import "package:drift/drift.dart";
import "package:json_annotation/json_annotation.dart" as j;

class GMapsResponse {
  List<GMapsPlace>? places;

  GMapsResponse({this.places});

  GMapsResponse.fromJson(Map<String, dynamic> json) {
    if (json["places"] != null) {
      places = <GMapsPlace>[];
      json["places"].forEach((v) {
        places!.add(GMapsPlace.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (places != null) {
      data["places"] = places!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationFeatureConverter extends TypeConverter<GMapsPlace, String> {
  const LocationFeatureConverter();

  @override
  GMapsPlace fromSql(String fromDb) {
    return GMapsPlace.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(GMapsPlace value) {
    return json.encode(value.toJson());
  }
}

@j.JsonSerializable()
class GMapsPlace {
  String? name;
  String? id;
  List<String>? types;
  String? nationalPhoneNumber;
  String? internationalPhoneNumber;
  String? formattedAddress;
  List<AddressComponents>? addressComponents;
  PlusCode? plusCode;
  Location? location;
  Viewport? viewport;
  double? rating;
  String? googleMapsUri;
  String? websiteUri;
  RegularOpeningHours? regularOpeningHours;
  int? utcOffsetMinutes;
  String? adrFormatAddress;
  String? businessStatus;
  int? userRatingCount;
  String? iconMaskBaseUri;
  String? iconBackgroundColor;
  DisplayName? displayName;
  DisplayName? primaryTypeDisplayName;
  bool? takeout;
  bool? delivery;
  bool? dineIn;
  bool? curbsidePickup;
  bool? reservable;
  bool? servesLunch;
  bool? servesDinner;
  bool? servesBeer;
  RegularOpeningHours? currentOpeningHours;
  String? primaryType;
  String? shortFormattedAddress;
  List<Reviews>? reviews;
  List<Photos>? photos;
  bool? liveMusic;
  bool? servesCocktails;
  bool? servesDessert;
  bool? servesCoffee;
  bool? goodForChildren;
  bool? restroom;
  bool? goodForGroups;
  bool? goodForWatchingSports;
  PaymentOptions? paymentOptions;
  ParkingOptions? parkingOptions;
  AccessibilityOptions? accessibilityOptions;

  GMapsPlace({
    this.name,
    this.id,
    this.types,
    this.nationalPhoneNumber,
    this.internationalPhoneNumber,
    this.formattedAddress,
    this.addressComponents,
    this.plusCode,
    this.location,
    this.viewport,
    this.rating,
    this.googleMapsUri,
    this.websiteUri,
    this.regularOpeningHours,
    this.utcOffsetMinutes,
    this.adrFormatAddress,
    this.businessStatus,
    this.userRatingCount,
    this.iconMaskBaseUri,
    this.iconBackgroundColor,
    this.displayName,
    this.primaryTypeDisplayName,
    this.takeout,
    this.delivery,
    this.dineIn,
    this.curbsidePickup,
    this.reservable,
    this.servesLunch,
    this.servesDinner,
    this.servesBeer,
    this.currentOpeningHours,
    this.primaryType,
    this.shortFormattedAddress,
    this.reviews,
    this.photos,
    this.liveMusic,
    this.servesCocktails,
    this.servesDessert,
    this.servesCoffee,
    this.goodForChildren,
    this.restroom,
    this.goodForGroups,
    this.goodForWatchingSports,
    this.paymentOptions,
    this.parkingOptions,
    this.accessibilityOptions,
  });

  GMapsPlace.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    types = json["types"]?.cast<String>();
    nationalPhoneNumber = json["nationalPhoneNumber"];
    internationalPhoneNumber = json["internationalPhoneNumber"];
    formattedAddress = json["formattedAddress"];
    if (json["addressComponents"] != null) {
      addressComponents = <AddressComponents>[];
      json["addressComponents"].forEach((v) {
        addressComponents!.add(AddressComponents.fromJson(v));
      });
    }
    plusCode = json["plusCode"] != null
        ? PlusCode.fromJson(json["plusCode"])
        : null;
    location = json["location"] != null
        ? Location.fromJson(json["location"])
        : null;
    viewport = json["viewport"] != null
        ? Viewport.fromJson(json["viewport"])
        : null;
    rating = json["rating"];
    googleMapsUri = json["googleMapsUri"];
    websiteUri = json["websiteUri"];
    regularOpeningHours = json["regularOpeningHours"] != null
        ? RegularOpeningHours.fromJson(json["regularOpeningHours"])
        : null;
    utcOffsetMinutes = json["utcOffsetMinutes"];
    adrFormatAddress = json["adrFormatAddress"];
    businessStatus = json["businessStatus"];
    userRatingCount = json["userRatingCount"];
    iconMaskBaseUri = json["iconMaskBaseUri"];
    iconBackgroundColor = json["iconBackgroundColor"];
    displayName = json["displayName"] != null
        ? DisplayName.fromJson(json["displayName"])
        : null;
    primaryTypeDisplayName = json["primaryTypeDisplayName"] != null
        ? DisplayName.fromJson(json["primaryTypeDisplayName"])
        : null;
    takeout = json["takeout"];
    delivery = json["delivery"];
    dineIn = json["dineIn"];
    curbsidePickup = json["curbsidePickup"];
    reservable = json["reservable"];
    servesLunch = json["servesLunch"];
    servesDinner = json["servesDinner"];
    servesBeer = json["servesBeer"];
    currentOpeningHours = json["currentOpeningHours"] != null
        ? RegularOpeningHours.fromJson(json["currentOpeningHours"])
        : null;
    primaryType = json["primaryType"];
    shortFormattedAddress = json["shortFormattedAddress"];
    if (json["reviews"] != null) {
      reviews = <Reviews>[];
      json["reviews"].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json["photos"] != null) {
      photos = <Photos>[];
      json["photos"].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    liveMusic = json["liveMusic"];
    servesCocktails = json["servesCocktails"];
    servesDessert = json["servesDessert"];
    servesCoffee = json["servesCoffee"];
    goodForChildren = json["goodForChildren"];
    restroom = json["restroom"];
    goodForGroups = json["goodForGroups"];
    goodForWatchingSports = json["goodForWatchingSports"];
    paymentOptions = json["paymentOptions"] != null
        ? PaymentOptions.fromJson(json["paymentOptions"])
        : null;
    parkingOptions = json["parkingOptions"] != null
        ? ParkingOptions.fromJson(json["parkingOptions"])
        : null;
    accessibilityOptions = json["accessibilityOptions"] != null
        ? AccessibilityOptions.fromJson(json["accessibilityOptions"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["id"] = id;
    data["types"] = types;
    data["nationalPhoneNumber"] = nationalPhoneNumber;
    data["internationalPhoneNumber"] = internationalPhoneNumber;
    data["formattedAddress"] = formattedAddress;
    if (addressComponents != null) {
      data["addressComponents"] = addressComponents!
          .map((v) => v.toJson())
          .toList();
    }
    if (plusCode != null) {
      data["plusCode"] = plusCode!.toJson();
    }
    if (location != null) {
      data["location"] = location!.toJson();
    }
    if (viewport != null) {
      data["viewport"] = viewport!.toJson();
    }
    data["rating"] = rating;
    data["googleMapsUri"] = googleMapsUri;
    data["websiteUri"] = websiteUri;
    if (regularOpeningHours != null) {
      data["regularOpeningHours"] = regularOpeningHours!.toJson();
    }
    data["utcOffsetMinutes"] = utcOffsetMinutes;
    data["adrFormatAddress"] = adrFormatAddress;
    data["businessStatus"] = businessStatus;
    data["userRatingCount"] = userRatingCount;
    data["iconMaskBaseUri"] = iconMaskBaseUri;
    data["iconBackgroundColor"] = iconBackgroundColor;
    if (displayName != null) {
      data["displayName"] = displayName!.toJson();
    }
    if (primaryTypeDisplayName != null) {
      data["primaryTypeDisplayName"] = primaryTypeDisplayName!.toJson();
    }
    data["takeout"] = takeout;
    data["delivery"] = delivery;
    data["dineIn"] = dineIn;
    data["curbsidePickup"] = curbsidePickup;
    data["reservable"] = reservable;
    data["servesLunch"] = servesLunch;
    data["servesDinner"] = servesDinner;
    data["servesBeer"] = servesBeer;
    if (currentOpeningHours != null) {
      data["currentOpeningHours"] = currentOpeningHours!.toJson();
    }
    data["primaryType"] = primaryType;
    data["shortFormattedAddress"] = shortFormattedAddress;
    if (reviews != null) {
      data["reviews"] = reviews!.map((v) => v.toJson()).toList();
    }
    if (photos != null) {
      data["photos"] = photos!.map((v) => v.toJson()).toList();
    }
    data["liveMusic"] = liveMusic;
    data["servesCocktails"] = servesCocktails;
    data["servesDessert"] = servesDessert;
    data["servesCoffee"] = servesCoffee;
    data["goodForChildren"] = goodForChildren;
    data["restroom"] = restroom;
    data["goodForGroups"] = goodForGroups;
    data["goodForWatchingSports"] = goodForWatchingSports;
    if (paymentOptions != null) {
      data["paymentOptions"] = paymentOptions!.toJson();
    }
    if (parkingOptions != null) {
      data["parkingOptions"] = parkingOptions!.toJson();
    }
    if (accessibilityOptions != null) {
      data["accessibilityOptions"] = accessibilityOptions!.toJson();
    }
    return data;
  }
}

class AddressComponents {
  String? longText;
  String? shortText;
  List<String>? types;
  String? languageCode;

  AddressComponents({
    this.longText,
    this.shortText,
    this.types,
    this.languageCode,
  });

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longText = json["longText"];
    shortText = json["shortText"];
    types = json["types"].cast<String>();
    languageCode = json["languageCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["longText"] = longText;
    data["shortText"] = shortText;
    data["types"] = types;
    data["languageCode"] = languageCode;
    return data;
  }
}

class PlusCode {
  String? globalCode;
  String? compoundCode;

  PlusCode({this.globalCode, this.compoundCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    globalCode = json["globalCode"];
    compoundCode = json["compoundCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["globalCode"] = globalCode;
    data["compoundCode"] = compoundCode;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json["latitude"];
    longitude = json["longitude"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    return data;
  }
}

class Viewport {
  Location? low;
  Location? high;

  Viewport({this.low, this.high});

  Viewport.fromJson(Map<String, dynamic> json) {
    low = json["low"] != null ? Location.fromJson(json["low"]) : null;
    high = json["high"] != null ? Location.fromJson(json["high"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (low != null) {
      data["low"] = low!.toJson();
    }
    if (high != null) {
      data["high"] = high!.toJson();
    }
    return data;
  }
}

class RegularOpeningHours {
  bool? openNow;
  List<Periods>? periods;
  List<String>? weekdayDescriptions;

  RegularOpeningHours({this.openNow, this.periods, this.weekdayDescriptions});

  RegularOpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json["openNow"];
    if (json["periods"] != null) {
      periods = <Periods>[];
      json["periods"].forEach((v) {
        periods!.add(Periods.fromJson(v));
      });
    }
    weekdayDescriptions = json["weekdayDescriptions"].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["openNow"] = openNow;
    if (periods != null) {
      data["periods"] = periods!.map((v) => v.toJson()).toList();
    }
    data["weekdayDescriptions"] = weekdayDescriptions;
    return data;
  }
}

class Periods {
  Open? open;
  Open? close;

  Periods({this.open, this.close});

  Periods.fromJson(Map<String, dynamic> json) {
    open = json["open"] != null ? Open.fromJson(json["open"]) : null;
    close = json["close"] != null ? Open.fromJson(json["close"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (open != null) {
      data["open"] = open!.toJson();
    }
    if (close != null) {
      data["close"] = close!.toJson();
    }
    return data;
  }
}

class DisplayName {
  String? text;
  String? languageCode;

  DisplayName({this.text, this.languageCode});

  DisplayName.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    languageCode = json["languageCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["languageCode"] = languageCode;
    return data;
  }
}

class Open {
  int? day;
  int? hour;
  int? minute;
  Date? date;
  bool? truncated;

  Open({this.day, this.hour, this.minute, this.date, this.truncated});

  Open.fromJson(Map<String, dynamic> json) {
    day = json["day"];
    hour = json["hour"];
    minute = json["minute"];
    date = json["date"] != null ? Date.fromJson(json["date"]) : null;
    truncated = json["truncated"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["day"] = day;
    data["hour"] = hour;
    data["minute"] = minute;
    if (date != null) {
      data["date"] = date!.toJson();
    }
    data["truncated"] = truncated;
    return data;
  }
}

class Date {
  int? year;
  int? month;
  int? day;

  Date({this.year, this.month, this.day});

  Date.fromJson(Map<String, dynamic> json) {
    year = json["year"];
    month = json["month"];
    day = json["day"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["year"] = year;
    data["month"] = month;
    data["day"] = day;
    return data;
  }
}

class Reviews {
  String? name;
  String? relativePublishTimeDescription;
  int? rating;
  DisplayName? text;
  DisplayName? originalText;
  AuthorAttribution? authorAttribution;
  String? publishTime;

  Reviews({
    this.name,
    this.relativePublishTimeDescription,
    this.rating,
    this.text,
    this.originalText,
    this.authorAttribution,
    this.publishTime,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    relativePublishTimeDescription = json["relativePublishTimeDescription"];
    rating = json["rating"];
    text = json["text"] != null ? DisplayName.fromJson(json["text"]) : null;
    originalText = json["originalText"] != null
        ? DisplayName.fromJson(json["originalText"])
        : null;
    authorAttribution = json["authorAttribution"] != null
        ? AuthorAttribution.fromJson(json["authorAttribution"])
        : null;
    publishTime = json["publishTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["relativePublishTimeDescription"] = relativePublishTimeDescription;
    data["rating"] = rating;
    if (text != null) {
      data["text"] = text!.toJson();
    }
    if (originalText != null) {
      data["originalText"] = originalText!.toJson();
    }
    if (authorAttribution != null) {
      data["authorAttribution"] = authorAttribution!.toJson();
    }
    data["publishTime"] = publishTime;
    return data;
  }
}

class AuthorAttribution {
  String? displayName;
  String? uri;
  String? photoUri;

  AuthorAttribution({this.displayName, this.uri, this.photoUri});

  AuthorAttribution.fromJson(Map<String, dynamic> json) {
    displayName = json["displayName"];
    uri = json["uri"];
    photoUri = json["photoUri"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["displayName"] = displayName;
    data["uri"] = uri;
    data["photoUri"] = photoUri;
    return data;
  }
}

class Photos {
  String? name;
  int? widthPx;
  int? heightPx;
  // ? Ignore AuthorAttributions, not like I need them right now anyways
  // List<AuthorAttributions>? authorAttributions;

  Photos({
    this.name,
    this.widthPx,
    this.heightPx,
    // this.authorAttributions,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    widthPx = json["widthPx"];
    heightPx = json["heightPx"];
    // if (json["authorAttributions"] != null) {
    //   authorAttributions = <AuthorAttributions>[];
    //   json["authorAttributions"].forEach((v) {
    //     authorAttributions!.add(AuthorAttributions.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["widthPx"] = widthPx;
    data["heightPx"] = heightPx;
    // if (authorAttributions != null) {
    //   data["authorAttributions"] =
    //       authorAttributions!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class PaymentOptions {
  bool? acceptsCreditCards;
  bool? acceptsDebitCards;
  bool? acceptsCashOnly;

  PaymentOptions({
    this.acceptsCreditCards,
    this.acceptsDebitCards,
    this.acceptsCashOnly,
  });

  PaymentOptions.fromJson(Map<String, dynamic> json) {
    acceptsCreditCards = json["acceptsCreditCards"];
    acceptsDebitCards = json["acceptsDebitCards"];
    acceptsCashOnly = json["acceptsCashOnly"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["acceptsCreditCards"] = acceptsCreditCards;
    data["acceptsDebitCards"] = acceptsDebitCards;
    data["acceptsCashOnly"] = acceptsCashOnly;
    return data;
  }
}

class ParkingOptions {
  bool? freeParkingLot;
  bool? paidParkingLot;

  ParkingOptions({this.freeParkingLot, this.paidParkingLot});

  ParkingOptions.fromJson(Map<String, dynamic> json) {
    freeParkingLot = json["freeParkingLot"];
    paidParkingLot = json["paidParkingLot"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["freeParkingLot"] = freeParkingLot;
    data["paidParkingLot"] = paidParkingLot;
    return data;
  }
}

class AccessibilityOptions {
  bool? wheelchairAccessibleParking;
  bool? wheelchairAccessibleEntrance;
  bool? wheelchairAccessibleRestroom;
  bool? wheelchairAccessibleSeating;

  AccessibilityOptions({
    this.wheelchairAccessibleParking,
    this.wheelchairAccessibleEntrance,
    this.wheelchairAccessibleRestroom,
    this.wheelchairAccessibleSeating,
  });

  AccessibilityOptions.fromJson(Map<String, dynamic> json) {
    wheelchairAccessibleParking = json["wheelchairAccessibleParking"];
    wheelchairAccessibleEntrance = json["wheelchairAccessibleEntrance"];
    wheelchairAccessibleRestroom = json["wheelchairAccessibleRestroom"];
    wheelchairAccessibleSeating = json["wheelchairAccessibleSeating"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["wheelchairAccessibleParking"] = wheelchairAccessibleParking;
    data["wheelchairAccessibleEntrance"] = wheelchairAccessibleEntrance;
    data["wheelchairAccessibleRestroom"] = wheelchairAccessibleRestroom;
    data["wheelchairAccessibleSeating"] = wheelchairAccessibleSeating;
    return data;
  }
}
