class LocationModel {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final String? countryCode;
  final bool isGps;

  LocationModel({
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.countryCode,
    this.isGps = false,
  });

  bool get isValid => latitude != null && longitude != null;

  bool get hasCityName => city != null && city!.isNotEmpty;

  String get displayName {
    if (city != null && city!.isNotEmpty && country != null && country!.isNotEmpty) {
      return '$city، $country';
    } else if (city != null && city!.isNotEmpty) {
      return city!;
    } else if (latitude != null && longitude != null) {
      return '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
    }
    return '';
  }

  String get displayNameEn {
    if (city != null && city!.isNotEmpty && country != null && country!.isNotEmpty) {
      return '$city, $country';
    } else if (city != null && city!.isNotEmpty) {
      return city!;
    } else if (latitude != null && longitude != null) {
      return '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
    }
    return '';
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? countryCode,
    bool? isGps,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      isGps: isGps ?? this.isGps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'countryCode': countryCode,
      'isGps': isGps,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      isGps: json['isGps'] as bool? ?? false,
    );
  }
}