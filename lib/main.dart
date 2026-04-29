import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/prayer_api_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/audio_service.dart';
import 'providers/app_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storageService = StorageService();
  final prayerApiService = PrayerApiService();
  final locationService = LocationService();
  final notificationService = NotificationService();
  final audioService = AudioService();

  runApp(
    SalahTrackerApp(
      storageService: storageService,
      prayerApiService: prayerApiService,
      locationService: locationService,
      notificationService: notificationService,
      audioService: audioService,
    ),
  );

  // Ensure disposal on app exit
  await audioService.dispose();
}

class SalahTrackerApp extends StatelessWidget {
  final StorageService storageService;
  final PrayerApiService prayerApiService;
  final LocationService locationService;
  final NotificationService notificationService;
  final AudioService audioService;

  const SalahTrackerApp({
    super.key,
    required this.storageService,
    required this.prayerApiService,
    required this.locationService,
    required this.notificationService,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(
        storageService: storageService,
        prayerApiService: prayerApiService,
        locationService: locationService,
        notificationService: notificationService,
        audioService: audioService,
      )..init(),
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'مواقيت الصلاة',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.settings.themeMode,
            locale: Locale(provider.settings.language),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
