import 'package:flutter/material.dart';

class AppSettings {
  final String language;
  final ThemeMode themeMode;
  final int calculationMethod;
  final bool notificationsEnabled;
  final String azanSound;
  final Map<String, bool> prayerNotifications;

  AppSettings({
    this.language = 'ar',
    this.themeMode = ThemeMode.system,
    this.calculationMethod = 4,
    this.notificationsEnabled = true,
    this.azanSound = 'Azhan1',
    this.prayerNotifications = const {
      'fajr': true,
      'dhuhr': true,
      'asr': true,
      'maghrib': true,
      'isha': true,
    },
  });

  AppSettings copyWith({
    String? language,
    ThemeMode? themeMode,
    int? calculationMethod,
    bool? notificationsEnabled,
    String? azanSound,
    Map<String, bool>? prayerNotifications,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      azanSound: azanSound ?? this.azanSound,
      prayerNotifications: prayerNotifications ?? this.prayerNotifications,
    );
  }

  bool isPrayerNotificationEnabled(String prayer) {
    return prayerNotifications[prayer] ?? true;
  }

  AppSettings togglePrayerNotification(String prayer) {
    final updated = Map<String, bool>.from(prayerNotifications);
    updated[prayer] = !(updated[prayer] ?? true);
    return copyWith(prayerNotifications: updated);
  }
}