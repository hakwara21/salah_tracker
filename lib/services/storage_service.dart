import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/location_model.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveLocation(LocationModel location) async {
    if (location.latitude != null) {
      await _prefs.setDouble(AppConstants.prefLatitude, location.latitude!);
    }
    if (location.longitude != null) {
      await _prefs.setDouble(AppConstants.prefLongitude, location.longitude!);
    }
    if (location.city != null) {
      await _prefs.setString(AppConstants.prefCity, location.city!);
    }
    if (location.country != null) {
      await _prefs.setString(AppConstants.prefCountry, location.country!);
    }
    if (location.countryCode != null) {
      await _prefs.setString(AppConstants.prefCountryCode, location.countryCode!);
    }
    await _prefs.setBool(AppConstants.prefLocationMode, location.isGps);
  }

  LocationModel? getLocation() {
    final lat = _prefs.getDouble(AppConstants.prefLatitude);
    final lon = _prefs.getDouble(AppConstants.prefLongitude);
    if (lat == null || lon == null) return null;

    return LocationModel(
      latitude: lat,
      longitude: lon,
      city: _prefs.getString(AppConstants.prefCity),
      country: _prefs.getString(AppConstants.prefCountry),
      countryCode: _prefs.getString(AppConstants.prefCountryCode),
      isGps: _prefs.getBool(AppConstants.prefLocationMode) ?? false,
    );
  }

  Future<void> saveLanguage(String language) async {
    await _prefs.setString(AppConstants.prefLanguage, language);
  }

  String getLanguage() {
    return _prefs.getString(AppConstants.prefLanguage) ?? 'ar';
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    String modeStr;
    switch (mode) {
      case ThemeMode.light:
        modeStr = 'light';
        break;
      case ThemeMode.dark:
        modeStr = 'dark';
        break;
      default:
        modeStr = 'system';
    }
    await _prefs.setString(AppConstants.prefThemeMode, modeStr);
  }

  ThemeMode getThemeMode() {
    final modeStr = _prefs.getString(AppConstants.prefThemeMode) ?? 'system';
    switch (modeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveCalculationMethod(int method) async {
    await _prefs.setInt(AppConstants.prefCalculationMethod, method);
  }

  int getCalculationMethod() {
    return _prefs.getInt(AppConstants.prefCalculationMethod) ?? ApiConstants.defaultCalculationMethod;
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.prefNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppConstants.prefNotificationsEnabled) ?? true;
  }

  Future<void> saveAzanSound(String sound) async {
    await _prefs.setString(AppConstants.prefAzanSound, sound);
  }

  String getAzanSound() {
    return _prefs.getString(AppConstants.prefAzanSound) ?? 'Azhan1';
  }

  Future<void> savePrayerNotification(String prayer, bool enabled) async {
    final key = _getPrayerNotificationKey(prayer);
    await _prefs.setBool(key, enabled);
  }

  bool getPrayerNotification(String prayer) {
    final key = _getPrayerNotificationKey(prayer);
    return _prefs.getBool(key) ?? true;
  }

  String _getPrayerNotificationKey(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return AppConstants.prefFajrNotification;
      case 'dhuhr':
        return AppConstants.prefDhuhrNotification;
      case 'asr':
        return AppConstants.prefAsrNotification;
      case 'maghrib':
        return AppConstants.prefMaghribNotification;
      case 'isha':
        return AppConstants.prefIshaNotification;
      default:
        return AppConstants.prefFajrNotification;
    }
  }

  Future<void> saveLastPrayerUpdate(DateTime dateTime) async {
    await _prefs.setString(
      AppConstants.prefLastPrayerUpdate,
      dateTime.toIso8601String(),
    );
  }

  DateTime? getLastPrayerUpdate() {
    final str = _prefs.getString(AppConstants.prefLastPrayerUpdate);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  bool shouldUpdatePrayers() {
    final lastUpdate = getLastPrayerUpdate();
    if (lastUpdate == null) return true;
    final now = DateTime.now();
    return now.difference(lastUpdate).inHours >= 24;
  }
}