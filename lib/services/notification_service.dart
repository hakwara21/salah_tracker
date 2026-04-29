import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../data/models/prayer_time.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
  }

  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'salah_tracker_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await cancelNotification(id);
      return;
    }

    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'salah_tracker_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      'حان وقت الصلاة',
      'حان وقت صلاة $prayerName',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleAllPrayerNotifications(
    PrayerTime prayerTimes, {
    Map<String, bool> enabledPrayers = const {
      'fajr': true,
      'dhuhr': true,
      'asr': true,
      'maghrib': true,
      'isha': true,
    },
  }) async {
    await cancelAllNotifications();

    final prayers = [
      {'name': 'الفجر', 'nameEn': 'Fajr', 'time': prayerTimes.fajrTime, 'key': 'fajr'},
      {'name': 'الظهر', 'nameEn': 'Dhuhr', 'time': prayerTimes.dhuhrTime, 'key': 'dhuhr'},
      {'name': 'العصر', 'nameEn': 'Asr', 'time': prayerTimes.asrTime, 'key': 'asr'},
      {'name': 'المغرب', 'nameEn': 'Maghrib', 'time': prayerTimes.maghribTime, 'key': 'maghrib'},
      {'name': 'العشاء', 'nameEn': 'Isha', 'time': prayerTimes.ishaTime, 'key': 'isha'},
    ];

    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      final isEnabled = enabledPrayers[prayer['key']] ?? true;
      await schedulePrayerNotification(
        id: i,
        prayerName: prayer['name'] as String,
        prayerTime: prayer['time'] as DateTime,
        enabled: isEnabled,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: 'اختبار',
      body: 'إشعار اختبار',
    );
  }
}