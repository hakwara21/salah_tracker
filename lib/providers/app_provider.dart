import 'package:flutter/material.dart';
import '../data/models/prayer_time.dart';
import '../data/models/location_model.dart';
import '../data/models/app_settings.dart';
import '../services/storage_service.dart';
import '../services/prayer_api_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  final PrayerApiService _prayerApiService;
  final LocationService _locationService;
  final NotificationService _notificationService;
  final AudioService _audioService;

  AppProvider({
    required StorageService storageService,
    required PrayerApiService prayerApiService,
    required LocationService locationService,
    required NotificationService notificationService,
    required AudioService audioService,
  })  : _storageService = storageService,
        _prayerApiService = prayerApiService,
        _locationService = locationService,
        _notificationService = notificationService,
        _audioService = audioService;

  PrayerTime? _currentPrayerTimes;
  LocationModel? _currentLocation;
  AppSettings _settings = AppSettings();
  bool _isLoading = false;
  String? _error;
  int _currentTabIndex = 0;

  PrayerTime? get currentPrayerTimes => _currentPrayerTimes;
  LocationModel? get currentLocation => _currentLocation;
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentTabIndex => _currentTabIndex;

  Future<void> init() async {
    await _storageService.init();
    await _notificationService.init();
    await _audioService.init();

    _settings = AppSettings(
      language: _storageService.getLanguage(),
      themeMode: _storageService.getThemeMode(),
      calculationMethod: _storageService.getCalculationMethod(),
      notificationsEnabled: _storageService.getNotificationsEnabled(),
      azanSound: _storageService.getAzanSound(),
      prayerNotifications: {
        'fajr': _storageService.getPrayerNotification('fajr'),
        'dhuhr': _storageService.getPrayerNotification('dhuhr'),
        'asr': _storageService.getPrayerNotification('asr'),
        'maghrib': _storageService.getPrayerNotification('maghrib'),
        'isha': _storageService.getPrayerNotification('isha'),
      },
    );

    _currentLocation = _storageService.getLocation();

    if (_currentLocation != null && _currentLocation!.isValid) {
      await fetchPrayerTimes();
    }

    notifyListeners();
  }

  Future<void> fetchPrayerTimes() async {
    if (_currentLocation == null || !_currentLocation!.isValid) {
      _error = 'Location not set';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPrayerTimes = await _prayerApiService.getPrayerTimes(
        _currentLocation!,
        method: _settings.calculationMethod,
      );
      await _storageService.saveLastPrayerUpdate(DateTime.now());

      if (_settings.notificationsEnabled) {
        await _notificationService.scheduleAllPrayerNotifications(
          _currentPrayerTimes!,
          enabledPrayers: _settings.prayerNotifications,
        );
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocation(LocationModel location) async {
    _currentLocation = location;
    await _storageService.saveLocation(location);
    await fetchPrayerTimes();
    notifyListeners();
  }

  Future<void> detectLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final location = await _locationService.getCurrentLocationWithAddress();

    if (location != null) {
      _currentLocation = location;
      await _storageService.saveLocation(location);
      await fetchPrayerTimes();
    } else {
      _error = 'Could not detect location';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _settings = _settings.copyWith(language: language);
    await _storageService.saveLanguage(language);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _storageService.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> setCalculationMethod(int method) async {
    _settings = _settings.copyWith(calculationMethod: method);
    await _storageService.saveCalculationMethod(method);
    if (_currentLocation != null && _currentLocation!.isValid) {
      await fetchPrayerTimes();
    }
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await _storageService.saveNotificationsEnabled(enabled);
    if (enabled && _currentPrayerTimes != null) {
      await _notificationService.scheduleAllPrayerNotifications(
        _currentPrayerTimes!,
        enabledPrayers: _settings.prayerNotifications,
      );
    } else {
      await _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  Future<void> setAzanSound(String sound) async {
    _settings = _settings.copyWith(azanSound: sound);
    await _storageService.saveAzanSound(sound);
    notifyListeners();
  }

  Future<void> togglePrayerNotification(String prayer, bool enabled) async {
    final updated = Map<String, bool>.from(_settings.prayerNotifications);
    updated[prayer] = enabled;
    _settings = _settings.copyWith(prayerNotifications: updated);
    await _storageService.savePrayerNotification(prayer, enabled);

    if (_settings.notificationsEnabled && _currentPrayerTimes != null) {
      await _notificationService.scheduleAllPrayerNotifications(
        _currentPrayerTimes!,
        enabledPrayers: updated,
      );
    }
    notifyListeners();
  }

  Future<void> playAzan() async {
    await _audioService.playAzan(_settings.azanSound);
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  DateTime? getNextPrayerTime() {
    if (_currentPrayerTimes == null) return null;

    final now = DateTime.now();
    final prayers = _currentPrayerTimes!.getAllPrayers();

    for (final prayer in prayers) {
      final prayerTime = prayer['dateTime'] as DateTime;
      if (prayerTime.isAfter(now)) {
        return prayerTime;
      }
    }
    return null;
  }

  String? getCurrentPrayerName() {
    if (_currentPrayerTimes == null) return null;

    final now = DateTime.now();
    final prayers = _currentPrayerTimes!.getAllPrayers();

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayers[i]['dateTime'] as DateTime;
      final nextPrayer = i + 1 < prayers.length
          ? prayers[i + 1]['dateTime'] as DateTime
          : null;

      if (prayerTime.isBefore(now) &&
          (nextPrayer == null || nextPrayer.isAfter(now))) {
        return prayers[i]['name'] as String;
      }
    }
    return null;
  }

  int getCurrentPrayerIndex() {
    if (_currentPrayerTimes == null) return -1;

    final now = DateTime.now();
    final prayers = _currentPrayerTimes!.getAllPrayers();

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayers[i]['dateTime'] as DateTime;
      final nextPrayer = i + 1 < prayers.length
          ? prayers[i + 1]['dateTime'] as DateTime
          : null;

      if (prayerTime.isBefore(now) &&
          (nextPrayer == null || nextPrayer.isAfter(now))) {
        return i;
      }
    }
    return -1;
  }
}