import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({super.key});

  @override
  State<MonthlyCalendarScreen> createState() => _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(provider),
              ),
              SliverToBoxAdapter(
                child: _buildMonthSelector(),
              ),
              SliverToBoxAdapter(
                child: _buildCalendarHeader(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildCalendarDay(index, provider);
                    },
                    childCount: 31,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildCalculationInfo(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            provider.currentLocation?.displayName ?? 'اختر الموقع',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_right, color: AppColors.primary),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'ربيع الأول - ربيع الثاني ١٤٤٥',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_left, color: AppColors.primary),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'التاريخ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'الفجر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'الظهر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'العصر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'المغرب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'العشاء',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int index, AppProvider provider) {
    final day = index + 1;
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    if (day > daysInMonth) return const SizedBox.shrink();

    final isToday = DateTime.now().day == day &&
                    DateTime.now().month == _currentMonth.month &&
                    DateTime.now().year == _currentMonth.year;

    final times = _getSampleTimes(day);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primaryFixed : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? null
            : Border.all(color: AppColors.surfaceContainer),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: isToday ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: isToday ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                if (isToday)
                  const Text(
                    'اليوم',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 10,
                      color: AppColors.onPrimaryFixedVariant,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              times['fajr'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              times['dhuhr'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              times['asr'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              times['maghrib'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              times['isha'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getSampleTimes(int day) {
    final baseFajr = 5;
    final baseDhuhr = 12;
    final baseAsr = 15;
    final baseMaghrib = 18;
    final baseIsha = 19;

    final fajr = '${baseFajr + (day % 10) ~/ 5}:${(day * 3) % 60}';
    final dhuhr = '$baseDhuhr:${(day * 7) % 60}';
    final asr = '$baseAsr:${(day * 11) % 60}';
    final maghrib = '$baseMaghrib:${(day * 13) % 60}';
    final isha = '$baseIsha:${(day * 17) % 60}';

    return {
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }

  Widget _buildCalculationInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryContainer, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.secondaryFixed.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.mosque,
                color: AppColors.secondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حساب الصلاة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'يتم حساب الأوقات بناءً على جامعة أم القرى، مكة المكرمة.',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}