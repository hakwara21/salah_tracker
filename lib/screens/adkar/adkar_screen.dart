import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class AdkarScreen extends StatefulWidget {
  const AdkarScreen({super.key});

  @override
  State<AdkarScreen> createState() => _AdkarScreenState();
}

class _AdkarScreenState extends State<AdkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _adhkarData;
  bool _isLoading = true;
  String? _error;

  final List<Map<String, String>> _categories = [
    {'key': 'أذكار الاستيقاظ من النوم', 'title': 'أذكار الاستيقاظ', 'icon': 'wb_sunny'},
    {'key': 'أذكار النوم', 'title': 'أذكار النوم', 'icon': 'bedtime'},
    {'key': 'أذكار الصباح', 'title': 'أذكار الصباح', 'icon': 'wb_twilight'},
    {'key': 'أذكار المساء', 'title': 'أذكار المساء', 'icon': 'nights_stay'},
    {'key': 'أذكار بعد الصلاة', 'title': 'بعد الصلاة', 'icon': 'mosque'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadAdhkarData();
  }

  Future<void> _loadAdhkarData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/Adhkar/hisn_almuslim.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _adhkarData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'الأذكار',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: _isLoading
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.secondary,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                ),
                indicatorColor: AppColors.secondary,
                tabs: _categories.map((cat) {
                  return Tab(text: cat['title']);
                }).toList(),
              ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _error != null
              ? _buildError()
              : TabBarView(
                  controller: _tabController,
                  children: _categories.map((cat) {
                    return _buildAdkarList(cat['key']!);
                  }).toList(),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل الأذكار',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? '',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdkarList(String categoryKey) {
    final category = _adhkarData?[categoryKey];

    if (category == null) {
      return _buildEmptyCategory(categoryKey);
    }

    final texts = category['text'] as List<dynamic>? ?? [];
    final footnotes = category['footnote'] as List<dynamic>? ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: texts.length,
      itemBuilder: (context, index) {
        return _buildAdkarCard(
          texts[index]?.toString() ?? '',
          index < footnotes.length ? footnotes[index]?.toString() : null,
        );
      },
    );
  }

  Widget _buildEmptyCategory(String categoryKey) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book,
            size: 80,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أذكار في هذا القسم',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            categoryKey,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 12,
              color: AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdkarCard(String text, String? footnote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'NaskhArabic',
              fontSize: 18,
              height: 1.8,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
          if (footnote != null && footnote.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                footnote,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}