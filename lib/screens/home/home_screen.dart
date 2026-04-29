import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../location/location_picker_screen.dart';
import '../qibla/qibla_screen.dart';
import '../adkar/adkar_screen.dart';
import '../settings/settings_screen.dart';
import '../calendar/monthly_calendar_screen.dart';
import 'widgets/countdown_timer.dart';
import 'widgets/prayer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.currentLocation == null || !provider.currentLocation!.isValid) {
        _showLocationDialog();
      }
    });
  }

  void _showLocationDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeTab(),
          MonthlyCalendarScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.onSurface.withValues(alpha: 0.4),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Almarai',
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Almarai',
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'التقويم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      left: 16,
      bottom: 100,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QiblaScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.explore, color: Colors.white),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (provider.currentLocation == null || !provider.currentLocation!.isValid) {
          return _buildLocationRequired(context);
        }

        if (provider.error != null) {
          return _buildError(context, provider.error!);
        }

        return _buildContent(context, provider);
      },
    );
  }

  Widget _buildLocationRequired(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_off,
            size: 80,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'حدد موقعك أولاً',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
              );
            },
            child: const Text('اختيار الموقع'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            'حدث خطأ',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().fetchPrayerTimes();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppProvider provider) {
    final prayers = provider.currentPrayerTimes?.getAllPrayers() ?? [];
    final nextPrayer = provider.getNextPrayerTime();
    final currentIndex = provider.getCurrentPrayerIndex();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(context, provider),
        ),
        SliverToBoxAdapter(
          child: _buildCountdownSection(provider, nextPrayer),
        ),
        SliverToBoxAdapter(
          child: _buildCurrentPrayer(prayers, currentIndex),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= prayers.length) return null;
                final prayer = prayers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPrayerListItem(prayer, index, currentIndex),
                );
              },
              childCount: prayers.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildAdkarCard(context),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
              );
            },
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
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => provider.fetchPrayerTimes(),
            icon: const Icon(
              Icons.refresh,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSection(AppProvider provider, DateTime? nextPrayer) {
    if (nextPrayer == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.primaryContainer, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryFixed,
                      ),
                    ),
                  ),
                  CountdownTimer(
                    targetTime: nextPrayer,
                    prayerName: 'الظهر',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule,
                    color: AppColors.secondaryFixed,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'التالي: الظهر في 12:14 م',
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPrayer(List prayers, int currentIndex) {
    if (currentIndex < 0 || currentIndex >= prayers.length) {
      return const SizedBox.shrink();
    }

    final current = prayers[currentIndex];
    final icon = _getPrayerIcon(currentIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PrayerCard(
        name: current['name'] as String,
        nameEn: current['nameEn'] as String,
        time: current['time'] as String,
        isCurrent: true,
        icon: icon,
      ),
    );
  }

  Widget _buildPrayerListItem(Map<String, dynamic> prayer, int index, int currentIndex) {
    if (index == currentIndex) {
      return const SizedBox.shrink();
    }

    final icon = _getPrayerIcon(index);

    return PrayerCard(
      name: prayer['name'] as String,
      nameEn: prayer['nameEn'] as String,
      time: prayer['time'] as String,
      isActive: index > currentIndex,
      icon: icon,
    );
  }

  IconData _getPrayerIcon(int index) {
    switch (index) {
      case 0:
        return Icons.nights_stay;
      case 1:
        return Icons.wb_sunny;
      case 2:
        return Icons.wb_twilight;
      case 3:
        return Icons.wb_sunny_outlined;
      case 4:
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
  }

  Widget _buildAdkarCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdkarScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tertiaryContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.onTertiaryContainer.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.tertiaryFixed,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: AppColors.tertiaryFixed,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الأذكار',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'أذكار الصباح والمساء وأدعية',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 14,
                        color: AppColors.onTertiaryContainer,
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
      ),
    );
  }
}