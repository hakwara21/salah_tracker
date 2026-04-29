import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildLanguageSection(context, provider),
              const SizedBox(height: 24),
              _buildThemeSection(context, provider),
              const SizedBox(height: 24),
              _buildNotificationSection(context, provider),
              const SizedBox(height: 24),
              _buildAzanSection(context, provider),
              const SizedBox(height: 24),
              _buildCalculationMethodSection(context, provider),
              const SizedBox(height: 24),
              _buildAboutSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('اللغة'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text(
                  'العربية',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                value: 'ar',
                groupValue: provider.settings.language,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setLanguage(value);
                  }
                },
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text(
                  'English',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                value: 'en',
                groupValue: provider.settings.language,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setLanguage(value);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('المظهر'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                title: const Text(
                  'تلقائي',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                subtitle: const Text(
                  'يتبع إعدادات النظام',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                value: ThemeMode.system,
                groupValue: provider.settings.themeMode,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setThemeMode(value);
                  }
                },
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                title: const Text(
                  'فاتح',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                value: ThemeMode.light,
                groupValue: provider.settings.themeMode,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setThemeMode(value);
                  }
                },
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                title: const Text(
                  'داكن',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                value: ThemeMode.dark,
                groupValue: provider.settings.themeMode,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setThemeMode(value);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الإشعارات'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SwitchListTile(
            title: const Text(
              'تفعيل الإشعارات',
              style: TextStyle(fontFamily: 'Almarai'),
            ),
            subtitle: Text(
              provider.settings.notificationsEnabled ? 'مفعّل' : 'معطّل',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            value: provider.settings.notificationsEnabled,
            activeThumbColor: AppColors.primary,
            onChanged: (value) {
              provider.setNotificationsEnabled(value);
            },
          ),
        ),
        const SizedBox(height: 12),
        ..._buildPrayerNotificationItems(context, provider),
      ],
    );
  }

  List<Widget> _buildPrayerNotificationItems(BuildContext context, AppProvider provider) {
    final prayers = [
      {'key': 'fajr', 'name': 'الفجر'},
      {'key': 'dhuhr', 'name': 'الظهر'},
      {'key': 'asr', 'name': 'العصر'},
      {'key': 'maghrib', 'name': 'المغرب'},
      {'key': 'isha', 'name': 'العشاء'},
    ];

    return prayers.map((prayer) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SwitchListTile(
          title: Text(
            'إشعار ${prayer['name']}',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 14,
            ),
          ),
          value: provider.settings.prayerNotifications[prayer['key']] ?? true,
           activeThumbColor: AppColors.primary,
           onChanged: provider.settings.notificationsEnabled
              ? (value) {
                  provider.togglePrayerNotification(prayer['key']!, value);
                }
              : null,
        ),
      );
    }).toList();
  }

  Widget _buildAzanSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('صوت الأذان'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: AppConstants.azanSounds.map((sound) {
              final soundName = sound.replaceAll('Azhan', 'مقارئ ');
              return RadioListTile<String>(
                title: Text(
                  soundName,
                  style: const TextStyle(fontFamily: 'Almarai'),
                ),
                value: sound,
                groupValue: provider.settings.azanSound,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    provider.setAzanSound(value);
                  }
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => provider.playAzan(),
            icon: const Icon(Icons.play_arrow, color: AppColors.primary),
            label: const Text(
              'تشغيل试听',
              style: TextStyle(
                fontFamily: 'Almarai',
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationMethodSection(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('طريقة الحساب'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButton<int>(
            value: provider.settings.calculationMethod,
            isExpanded: true,
            underline: const SizedBox(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(16),
            items: ApiConstants.calculationMethods.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.setCalculationMethod(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('حول'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'الإصدار',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text(
                  'مواقيت الصلاة',
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
                trailing: const Text(
                  'AlAdhan API',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}