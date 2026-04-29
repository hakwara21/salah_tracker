class PrayerTime {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final DateTime date;
  final String? hijriDate;
  final String? hijriMonth;

  PrayerTime({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    this.hijriDate,
    this.hijriMonth,
  });

  DateTime get fajrTime => _parseTime(fajr);
  DateTime get sunriseTime => _parseTime(sunrise);
  DateTime get dhuhrTime => _parseTime(dhuhr);
  DateTime get asrTime => _parseTime(asr);
  DateTime get maghribTime => _parseTime(maghrib);
  DateTime get ishaTime => _parseTime(isha);

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    if (hours >= 24) hours -= 24;
    return DateTime(date.year, date.month, date.day, hours, minutes);
  }

  String getPrayerName(int index, {bool isArabic = true}) {
    if (isArabic) {
      const names = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
      return names[index];
    } else {
      const namesEn = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
      return namesEn[index];
    }
  }

  DateTime getPrayerTime(int index) {
    switch (index) {
      case 0: return fajrTime;
      case 1: return dhuhrTime;
      case 2: return asrTime;
      case 3: return maghribTime;
      case 4: return ishaTime;
      default: return fajrTime;
    }
  }

  List<Map<String, dynamic>> getAllPrayers({bool isArabic = true}) {
    return [
      {'name': 'الفجر', 'nameEn': 'Fajr', 'time': fajr, 'dateTime': fajrTime},
      {'name': 'الظهر', 'nameEn': 'Dhuhr', 'time': dhuhr, 'dateTime': dhuhrTime},
      {'name': 'العصر', 'nameEn': 'Asr', 'time': asr, 'dateTime': asrTime},
      {'name': 'المغرب', 'nameEn': 'Maghrib', 'time': maghrib, 'dateTime': maghribTime},
      {'name': 'العشاء', 'nameEn': 'Isha', 'time': isha, 'dateTime': ishaTime},
    ];
  }

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final dateJson = json['date'] as Map<String, dynamic>;
    final hijri = dateJson['hijri'] as Map<String, dynamic>?;

    return PrayerTime(
      fajr: timings['Fajr']?.toString().split(' ')[0] ?? '00:00',
      sunrise: timings['Sunrise']?.toString().split(' ')[0] ?? '00:00',
      dhuhr: timings['Dhuhr']?.toString().split(' ')[0] ?? '00:00',
      asr: timings['Asr']?.toString().split(' ')[0] ?? '00:00',
      maghrib: timings['Maghrib']?.toString().split(' ')[0] ?? '00:00',
      isha: timings['Isha']?.toString().split(' ')[0] ?? '00:00',
      date: DateTime.now(),
      hijriDate: hijri?['day']?.toString(),
      hijriMonth: hijri?['month']?['ar'] as String?,
    );
  }
}

class MonthlyPrayerTimes {
  final List<PrayerTime> prayers;
  final String month;
  final String year;

  MonthlyPrayerTimes({
    required this.prayers,
    required this.month,
    required this.year,
  });

  factory MonthlyPrayerTimes.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>? ?? {};
    final dateInfo = json['date'] as Map<String, dynamic>? ?? {};
    final hijri = dateInfo['hijri'] as Map<String, dynamic>? ?? {};
    final monthData = hijri['month'] as Map<String, dynamic>? ?? {};

    final List<PrayerTime> prayers = [];

    timings.forEach((key, value) {
      if (key == 'Date') return;
      final timeStr = value?.toString().split(' ')[0];
      if (timeStr != null) {
        prayers.add(PrayerTime(
          fajr: timeStr,
          sunrise: timeStr,
          dhuhr: timeStr,
          asr: timeStr,
          maghrib: timeStr,
          isha: timeStr,
          date: DateTime.now(),
        ));
      }
    });

    return MonthlyPrayerTimes(
      prayers: prayers,
      month: monthData['ar']?.toString() ?? '',
      year: hijri['year']?.toString() ?? '',
    );
  }
}