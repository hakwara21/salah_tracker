import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @calendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @qibla.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get qibla;

  /// No description provided for @adkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get adkar;

  /// No description provided for @fajr.
  ///
  /// In ar, this message translates to:
  /// **'الفجر'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In ar, this message translates to:
  /// **'شروق'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In ar, this message translates to:
  /// **'الظهر'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In ar, this message translates to:
  /// **'العصر'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In ar, this message translates to:
  /// **'المغرب'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In ar, this message translates to:
  /// **'العشاء'**
  String get isha;

  /// No description provided for @nextPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get nextPrayer;

  /// No description provided for @timeRemaining.
  ///
  /// In ar, this message translates to:
  /// **'الوقت المتبقي'**
  String get timeRemaining;

  /// No description provided for @currentLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الحالي'**
  String get currentLocation;

  /// No description provided for @autoLocation.
  ///
  /// In ar, this message translates to:
  /// **'تحديد تلقائي'**
  String get autoLocation;

  /// No description provided for @manualLocation.
  ///
  /// In ar, this message translates to:
  /// **'اختيار يدوي'**
  String get manualLocation;

  /// No description provided for @selectCountry.
  ///
  /// In ar, this message translates to:
  /// **'اختر الدولة'**
  String get selectCountry;

  /// No description provided for @selectCity.
  ///
  /// In ar, this message translates to:
  /// **'اختر المدينة'**
  String get selectCity;

  /// No description provided for @searchCity.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مدينة...'**
  String get searchCity;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @permissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الإذن'**
  String get permissionDenied;

  /// No description provided for @enableLocation.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الموقع'**
  String get enableLocation;

  /// No description provided for @qiblaDirection.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه القبلة'**
  String get qiblaDirection;

  /// No description provided for @qiblaAngle.
  ///
  /// In ar, this message translates to:
  /// **'زاوية القبلة'**
  String get qiblaAngle;

  /// No description provided for @compass.
  ///
  /// In ar, this message translates to:
  /// **'بوصلة'**
  String get compass;

  /// No description provided for @morningAdkar.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصباح'**
  String get morningAdkar;

  /// No description provided for @eveningAdkar.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المساء'**
  String get eveningAdkar;

  /// No description provided for @afterPrayerAdkar.
  ///
  /// In ar, this message translates to:
  /// **'أذكار بعد الصلاة'**
  String get afterPrayerAdkar;

  /// No description provided for @dhikr.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get dhikr;

  /// No description provided for @supplication.
  ///
  /// In ar, this message translates to:
  /// **'دعاء'**
  String get supplication;

  /// No description provided for @morningAdkarDesc.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصباح والمساء'**
  String get morningAdkarDesc;

  /// No description provided for @eveningAdkarDesc.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المساء'**
  String get eveningAdkarDesc;

  /// No description provided for @afterPrayerAdkarDesc.
  ///
  /// In ar, this message translates to:
  /// **'أذكار بعد كل صلاة'**
  String get afterPrayerAdkarDesc;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'الEnglish'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get systemTheme;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get enableNotifications;

  /// No description provided for @azanSound.
  ///
  /// In ar, this message translates to:
  /// **'صوت الأذان'**
  String get azanSound;

  /// No description provided for @calculationMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الحساب'**
  String get calculationMethod;

  /// No description provided for @notificationsBefore.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات قبل الصلاة'**
  String get notificationsBefore;

  /// No description provided for @minutes10.
  ///
  /// In ar, this message translates to:
  /// **'10 دقائق'**
  String get minutes10;

  /// No description provided for @minutes15.
  ///
  /// In ar, this message translates to:
  /// **'15 دقيقة'**
  String get minutes15;

  /// No description provided for @minutes30.
  ///
  /// In ar, this message translates to:
  /// **'30 دقيقة'**
  String get minutes30;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'حول'**
  String get about;

  /// No description provided for @version.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In ar, this message translates to:
  /// **'شروط الخدمة'**
  String get termsOfService;

  /// No description provided for @enabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعّل'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In ar, this message translates to:
  /// **'معطّل'**
  String get disabled;

  /// No description provided for @currentPrayer.
  ///
  /// In ar, this message translates to:
  /// **'صلاة الآن'**
  String get currentPrayer;

  /// No description provided for @setLocation.
  ///
  /// In ar, this message translates to:
  /// **'حدد موقعك أولاً'**
  String get setLocation;

  /// No description provided for @fetchingLocation.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحديد الموقع...'**
  String get fetchingLocation;

  /// No description provided for @locationError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديد الموقع'**
  String get locationError;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مجدداً'**
  String get tryAgain;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @prayerNotifications.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات الصلاة'**
  String get prayerNotifications;

  /// No description provided for @generalSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات العامة'**
  String get generalSettings;

  /// No description provided for @locationSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الموقع'**
  String get locationSettings;

  /// No description provided for @notificationSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الإشعارات'**
  String get notificationSettings;

  /// No description provided for @azanSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الأذان'**
  String get azanSettings;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get appearance;

  /// No description provided for @noInternet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت'**
  String get noInternet;

  /// No description provided for @cityNotFound.
  ///
  /// In ar, this message translates to:
  /// **'المدينة غير موجودة'**
  String get cityNotFound;

  /// No description provided for @invalidCoordinates.
  ///
  /// In ar, this message translates to:
  /// **'إحداثيات غير صالحة'**
  String get invalidCoordinates;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب إذن الموقع'**
  String get locationPermissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get openSettings;

  /// No description provided for @north.
  ///
  /// In ar, this message translates to:
  /// **'شمال'**
  String get north;

  /// No description provided for @east.
  ///
  /// In ar, this message translates to:
  /// **'شرق'**
  String get east;

  /// No description provided for @south.
  ///
  /// In ar, this message translates to:
  /// **'جنوب'**
  String get south;

  /// No description provided for @west.
  ///
  /// In ar, this message translates to:
  /// **'غرب'**
  String get west;

  /// No description provided for @northeast.
  ///
  /// In ar, this message translates to:
  /// **'شمال شرق'**
  String get northeast;

  /// No description provided for @northwest.
  ///
  /// In ar, this message translates to:
  /// **'شمال غرب'**
  String get northwest;

  /// No description provided for @southeast.
  ///
  /// In ar, this message translates to:
  /// **'جنوب شرق'**
  String get southeast;

  /// No description provided for @southwest.
  ///
  /// In ar, this message translates to:
  /// **'جنوب غرب'**
  String get southwest;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @month.
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get month;

  /// No description provided for @hijriDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ الهجري'**
  String get hijriDate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
