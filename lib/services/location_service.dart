import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../data/models/location_model.dart';

class LocationService {
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        isGps: true,
      );
    } catch (e) {
      return null;
    }
  }

  Future<LocationModel?> getLocationWithAddress(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return LocationModel(
          latitude: lat,
          longitude: lon,
          city: place.locality ?? place.subAdministrativeArea ?? place.administrativeArea,
          country: place.country,
          countryCode: place.isoCountryCode,
          isGps: true,
        );
      }
    } catch (e) {
      // Geocoding failed, return location without address
    }

    return LocationModel(
      latitude: lat,
      longitude: lon,
      isGps: true,
    );
  }

  Future<LocationModel?> getCurrentLocationWithAddress() async {
    final location = await getCurrentLocation();
    if (location == null) return null;

    return getLocationWithAddress(location.latitude!, location.longitude!);
  }

  Future<String?> getCityFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> getCountryFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks.first.country;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Map<String, String>?> getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return {
          'city': place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? '',
          'country': place.country ?? '',
          'countryCode': place.isoCountryCode ?? '',
        };
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationModel?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        return getLocationWithAddress(position.latitude, position.longitude);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}