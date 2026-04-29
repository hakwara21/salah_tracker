import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/prayer_time.dart';
import '../data/models/location_model.dart';
import '../../core/constants/app_constants.dart';

class PrayerApiService {
  final http.Client _client;

  PrayerApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<PrayerTime> getTimingsByCoordinates(
    double latitude,
    double longitude, {
    int method = ApiConstants.defaultCalculationMethod,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.timingsByCoordinates}'
      '?latitude=$latitude&longitude=$longitude&method=$method',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null) {
          return PrayerTime.fromJson(json['data']);
        }
      }
      throw Exception('Failed to fetch prayer times: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  Future<PrayerTime> getTimingsByCity(
    String city,
    String country, {
    int method = ApiConstants.defaultCalculationMethod,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.timingsByCity}'
      '?city=$city&country=$country&method=$method',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null) {
          return PrayerTime.fromJson(json['data']);
        }
      }
      throw Exception('Failed to fetch prayer times: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  Future<List<PrayerTime>> getMonthlyTimingsByCoordinates(
    double latitude,
    double longitude,
    int month,
    int year, {
    int method = ApiConstants.defaultCalculationMethod,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.timingsByCoordinates}'
      '?latitude=$latitude&longitude=$longitude&method=$method'
      '&month=$month&year=$year',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null) {
          final timings = json['data']['timings'] as Map<String, dynamic>;
          final List<PrayerTime> prayers = [];

          timings.forEach((key, value) {
            if (key == 'Date' || key == 'Sunset' || key == 'Sunrise') return;
            final timeStr = value?.toString().split(' ')[0];
            if (timeStr != null) {
              final day = int.tryParse(key);
              if (day != null) {
                prayers.add(PrayerTime(
                  fajr: timeStr,
                  sunrise: timeStr,
                  dhuhr: timeStr,
                  asr: timeStr,
                  maghrib: timeStr,
                  isha: timeStr,
                  date: DateTime(year, month, day),
                ));
              }
            }
          });

          prayers.sort((a, b) => a.date.compareTo(b.date));
          return prayers;
        }
      }
      throw Exception('Failed to fetch monthly prayer times: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching monthly prayer times: $e');
    }
  }

  Future<List<Map<String, String>>> getCitiesByCountry(String countryCode) async {
    final country = countryCode.toLowerCase();
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/citiesByCountry?country=$country',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null) {
          final cities = json['data'] as List;
          return cities.map((city) {
            return {
              'name': city['city']?.toString() ?? '',
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<PrayerTime> getPrayerTimes(LocationModel location, {int? method}) async {
    if (location.isGps && location.latitude != null && location.longitude != null) {
      return getTimingsByCoordinates(
        location.latitude!,
        location.longitude!,
        method: method ?? ApiConstants.defaultCalculationMethod,
      );
    } else if (location.city != null && location.countryCode != null) {
      return getTimingsByCity(
        location.city!,
        location.countryCode!,
        method: method ?? ApiConstants.defaultCalculationMethod,
      );
    }
    throw Exception('Invalid location data');
  }

  void dispose() {
    _client.close();
  }
}