class ApiConstants {
  static const String baseUrl = 'https://api.aladhan.com/v1';

  static const String timingsByCoordinates = '/timings';
  static const String timingsByCity = '/timingsByCity';

  static const int defaultCalculationMethod = 4;

  static const Map<int, String> calculationMethods = {
    1: 'University of Islamic Sciences, Karachi',
    2: 'Islamic Society of North America (ISNA)',
    3: 'Muslim World League',
    4: 'Islamic University of Al-Madinah',
    5: 'Egyptian General Authority of Survey',
  };
}

class AppConstants {
  static const String appName = 'Salah Tracker';

  static const String prefLanguage = 'language';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLocationMode = 'location_mode';
  static const String prefLatitude = 'latitude';
  static const String prefLongitude = 'longitude';
  static const String prefCity = 'city';
  static const String prefCountry = 'country';
  static const String prefCountryCode = 'country_code';
  static const String prefCalculationMethod = 'calculation_method';
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefAzanSound = 'azan_sound';
  static const String prefFajrNotification = 'fajr_notification';
  static const String prefDhuhrNotification = 'dhuhr_notification';
  static const String prefAsrNotification = 'asr_notification';
  static const String prefMaghribNotification = 'maghrib_notification';
  static const String prefIshaNotification = 'isha_notification';
  static const String prefLastPrayerUpdate = 'last_prayer_update';

  static const List<String> azanSounds = [
    'Azhan1',
    'Azhan2',
    'Azhan3',
    'Azhan4',
  ];

  static const List<Map<String, String>> supportedCountries = [
    {'code': 'SA', 'name': 'السعودية', 'nameEn': 'Saudi Arabia'},
    {'code': 'AE', 'name': 'الإمارات', 'nameEn': 'United Arab Emirates'},
    {'code': 'EG', 'name': 'مصر', 'nameEn': 'Egypt'},
    {'code': 'MA', 'name': 'المغرب', 'nameEn': 'Morocco'},
    {'code': 'JO', 'name': 'الأردن', 'nameEn': 'Jordan'},
    {'code': 'KW', 'name': 'الكويت', 'nameEn': 'Kuwait'},
    {'code': 'QA', 'name': 'قطر', 'nameEn': 'Qatar'},
    {'code': 'BH', 'name': 'البحرين', 'nameEn': 'Bahrain'},
    {'code': 'OM', 'name': 'عمان', 'nameEn': 'Oman'},
    {'code': 'YE', 'name': 'اليمن', 'nameEn': 'Yemen'},
    {'code': 'IQ', 'name': 'العراق', 'nameEn': 'Iraq'},
    {'code': 'SY', 'name': 'سوريا', 'nameEn': 'Syria'},
    {'code': 'LB', 'name': 'لبنان', 'nameEn': 'Lebanon'},
    {'code': 'PS', 'name': 'فلسطين', 'nameEn': 'Palestine'},
    {'code': 'TN', 'name': 'تونس', 'nameEn': 'Tunisia'},
    {'code': 'DZ', 'name': 'الجزائر', 'nameEn': 'Algeria'},
    {'code': 'LY', 'name': 'ليبيا', 'nameEn': 'Libya'},
    {'code': 'SD', 'name': 'السودان', 'nameEn': 'Sudan'},
    {'code': 'MY', 'name': 'ماليزيا', 'nameEn': 'Malaysia'},
    {'code': 'ID', 'name': 'إندونيسيا', 'nameEn': 'Indonesia'},
    {'code': 'PK', 'name': 'باكستان', 'nameEn': 'Pakistan'},
    {'code': 'IN', 'name': 'الهند', 'nameEn': 'India'},
    {'code': 'TR', 'name': 'تركيا', 'nameEn': 'Turkey'},
    {'code': 'GB', 'name': 'المملكة المتحدة', 'nameEn': 'United Kingdom'},
    {'code': 'US', 'name': 'الولايات المتحدة', 'nameEn': 'United States'},
    {'code': 'CA', 'name': 'كندا', 'nameEn': 'Canada'},
    {'code': 'AU', 'name': 'أستراليا', 'nameEn': 'Australia'},
    {'code': 'FR', 'name': 'فرنسا', 'nameEn': 'France'},
    {'code': 'DE', 'name': 'ألمانيا', 'nameEn': 'Germany'},
  ];
}