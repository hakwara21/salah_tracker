import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/location_model.dart';
import '../../providers/app_provider.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  bool _isGpsMode = true;
  bool _isLoading = false;
  String? _selectedCountryCode;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    if (provider.currentLocation != null) {
      _isGpsMode = provider.currentLocation!.isGps;
      if (provider.currentLocation!.city != null) {
        _selectedCity = provider.currentLocation!.city;
      }
    }
  }

  Future<void> _detectLocation() async {
    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    await provider.detectLocation();

    setState(() => _isLoading = false);

    if (provider.currentLocation != null && mounted) {
      Navigator.pop(context);
    } else if (mounted && provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    }
  }

  void _onCountrySelected(String countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
      _selectedCity = null;
    });
  }

  void _onCitySelected(String city) {
    setState(() => _selectedCity = city);
  }

  Future<void> _saveManualLocation() async {
    if (_selectedCountryCode == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار الدولة والمدينة')),
      );
      return;
    }

    final country = AppConstants.supportedCountries.firstWhere(
      (c) => c['code'] == _selectedCountryCode,
    );

    final location = LocationModel(
      city: _selectedCity,
      country: country['name'],
      countryCode: _selectedCountryCode,
      isGps: false,
    );

    final provider = context.read<AppProvider>();
    await provider.setLocation(location);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'إعدادات الموقع',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGpsSection(),
            const SizedBox(height: 16),
            _buildManualSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.my_location, color: AppColors.secondary, size: 24),
            const SizedBox(width: 8),
            const Text(
              'تحديد تلقائي',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الموقع الحالي',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Consumer<AppProvider>(
                          builder: (context, provider, _) {
                            return Text(
                              provider.currentLocation?.displayName ?? 'لم يتم تحديد الموقع',
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isGpsMode,
                    onChanged: (value) {
                      setState(() => _isGpsMode = value);
                      if (value) {
                        _detectLocation();
                      }
                    },
                    activeThumbColor: AppColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.gps_fixed,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'جاري استخدام GPS لمواقيت الصلاة',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildManualSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit_location_alt, color: AppColors.secondary, size: 24),
            const SizedBox(width: 8),
            const Text(
              'اختيار يدوي',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildCountryDropdown(),
              const SizedBox(height: 16),
              _buildCityDropdown(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر الدولة',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: DropdownButton<String>(
            value: _selectedCountryCode,
            hint: const Text('اختر الدولة'),
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items: AppConstants.supportedCountries.map((country) {
              return DropdownMenuItem(
                value: country['code'],
                child: Text(
                  country['name']!,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _onCountrySelected(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    final cities = _selectedCountryCode != null
        ? _getCitiesForCountry(_selectedCountryCode!)
        : <Map<String, String>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر المدينة',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: DropdownButton<String>(
            value: _selectedCity,
            hint: const Text('اختر المدينة'),
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            items: cities.map((city) {
              return DropdownMenuItem(
                value: city['name'],
                child: Text(
                  city['name']!,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _onCitySelected(value);
              }
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getCitiesForCountry(String countryCode) {
    final citiesMap = {
      'SA': [
        {'name': 'مكة المكرمة'},
        {'name': 'المدينة المنورة'},
        {'name': 'الرياض'},
        {'name': 'جدة'},
        {'name': 'الدمام'},
        {'name': 'الظهران'},
        {'name': 'القطيف'},
        {'name': 'الخرج'},
        {'name': 'بريدة'},
        {'name': 'تبوك'},
      ],
      'AE': [
        {'name': 'أبوظبي'},
        {'name': 'دبي'},
        {'name': 'الشارقة'},
        {'name': 'عجمان'},
        {'name': 'العين'},
      ],
      'EG': [
        {'name': 'القاهرة'},
        {'name': 'الإسكندرية'},
        {'name': 'الجيزة'},
        {'name': 'المنصورة'},
        {'name': 'طنطا'},
      ],
      'MA': [
        {'name': 'الرباط'},
        {'name': 'الدار البيضاء'},
        {'name': 'مراكش'},
        {'name': 'فاس'},
      ],
      'KW': [
        {'name': 'الكويت'},
        {'name': 'الفروانية'},
        {'name': 'حولي'},
      ],
      'QA': [
        {'name': 'الدوحة'},
        {'name': 'الريان'},
        {'name': 'الوكرة'},
      ],
      'BH': [
        {'name': 'المنامة'},
        {'name': 'الرفاع'},
        {'name': 'المحرق'},
      ],
      'OM': [
        {'name': 'مسقط'},
        {'name': 'صلالة'},
        {'name': 'السيب'},
      ],
    };

    return citiesMap[countryCode] ?? [
      {'name': 'العاصمة'},
    ];
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isGpsMode ? null : _saveManualLocation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'حفظ التغييرات',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}