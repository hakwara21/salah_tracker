import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PrayerCard extends StatelessWidget {
  final String name;
  final String nameEn;
  final String time;
  final bool isActive;
  final bool isCurrent;
  final IconData icon;
  final bool showNotification;

  const PrayerCard({
    super.key,
    required this.name,
    required this.nameEn,
    required this.time,
    this.isActive = false,
    this.isCurrent = false,
    required this.icon,
    this.showNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return _buildCurrentPrayerCard();
    }
    return _buildRegularPrayerCard();
  }

  Widget _buildCurrentPrayerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.onSecondaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
                Text(
                  _getPrayerDescription(),
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 16,
                    color: AppColors.onSecondaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'نشط',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSecondaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.notifications_active,
                    size: 14,
                    color: AppColors.onSecondaryContainer.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularPrayerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryFixedDim,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (showNotification)
            Icon(
              Icons.notifications,
              color: Colors.white.withValues(alpha: 0.2),
              size: 20,
            ),
        ],
      ),
    );
  }

  String _getPrayerDescription() {
    switch (name) {
      case 'الفجر':
        return 'صلاة الفجر';
      case 'الظهر':
        return 'صلاة الظهيرة';
      case 'العصر':
        return 'صلاة العصر';
      case 'المغرب':
        return 'صلاة المغرب';
      case 'العشاء':
        return 'صلاة العشاء';
      default:
        return '';
    }
  }
}