import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/qibla_calculator.dart';
import '../../providers/app_provider.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _currentHeading;
  double? _qiblaDirection;
  StreamSubscription<dynamic>? _compassSubscription;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  Future<void> _initCompass() async {
    final provider = context.read<AppProvider>();
    final location = provider.currentLocation;

    if (location == null || !location.isValid) {
      setState(() {
        _errorMessage = 'لم يتم تحديد الموقع';
        _isLoading = false;
      });
      return;
    }

    _qiblaDirection = QiblaCalculator.calculateQiblaDirection(
      location.latitude!,
      location.longitude!,
    );

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _currentHeading = event.heading;
          _isLoading = false;
        });
      }
    });

    if (_compassSubscription == null) {
      setState(() {
        _errorMessage = 'البوصلة غير متوفرة';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'اتجاه القبلة',
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _errorMessage.isNotEmpty
              ? _buildError()
              : _buildCompass(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.explore_off,
            size: 80,
            color: Colors.white54,
          ),
          const SizedBox(height: 24),
          Text(
            _errorMessage,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = '';
              });
              _initCompass();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    final heading = _currentHeading ?? 0;
    final qibla = _qiblaDirection ?? 0;
    final rotation = (qibla - heading) * (math.pi / 180);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -rotation,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: CompassPainter(qiblaDirection: qibla),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: AppColors.onSecondaryContainer,
                          size: 32,
                        ),
                        Text(
                          '${qibla.toStringAsFixed(1)}°',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildDirectionInfo(heading, qibla),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDirectionInfo(double heading, double qibla) {
    final diff = QiblaCalculator.calculateAngleDifference(heading, qibla);
    final isAligned = diff.abs() < 5;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                'الاتجاه',
                QiblaCalculator.getDirectionName(qibla),
              ),
              _buildInfoItem(
                'زاوية القبلة',
                '${qibla.toStringAsFixed(1)}°',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isAligned
                  ? AppColors.secondaryContainer
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAligned ? Icons.check_circle : Icons.screen_rotation,
                  color: isAligned
                      ? AppColors.onSecondaryContainer
                      : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isAligned
                      ? 'أنت متجه نحو القبلة'
                      : 'أدر الجهاز حتى تكون متجهًا للقبلة',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 14,
                    color: isAligned
                        ? AppColors.onSecondaryContainer
                        : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              return Text(
                provider.currentLocation?.displayName ?? '',
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  color: Colors.white54,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CompassPainter extends CustomPainter {
  final double qiblaDirection;

  CompassPainter({required this.qiblaDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 36; i++) {
      final angle = i * 10 * (math.pi / 180) - math.pi / 2;
      final length = i % 9 == 0 ? 20.0 : 10.0;
      final start = Offset(
        center.dx + (radius - length) * math.cos(angle),
        center.dy + (radius - length) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final directions = ['شمال', 'شمال شرق', 'شرق', 'جنوب شرق', 'جنوب', 'جنوب غرب', 'غرب', 'شمال west'];
    final angles = [0, 45, 90, 135, 180, 225, 270, 315];

    for (int i = 0; i < 8; i++) {
      final angle = angles[i] * (math.pi / 180) - math.pi / 2;
      final x = center.dx + (radius - 35) * math.cos(angle);
      final y = center.dy + (radius - 35) * math.sin(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 12,
          fontFamily: 'Almarai',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    final qiblaAngle = qiblaDirection * (math.pi / 180) - math.pi / 2;
    final qiblaPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final qiblaPath = Path();
    qiblaPath.moveTo(
      center.dx + radius * 0.7 * math.cos(qiblaAngle),
      center.dy + radius * 0.7 * math.sin(qiblaAngle),
    );
    qiblaPath.lineTo(
      center.dx + (radius - 20) * math.cos(qiblaAngle - 0.1),
      center.dy + (radius - 20) * math.sin(qiblaAngle - 0.1),
    );
    qiblaPath.lineTo(
      center.dx + (radius - 20) * math.cos(qiblaAngle + 0.1),
      center.dy + (radius - 20) * math.sin(qiblaAngle + 0.1),
    );
    qiblaPath.close();

    canvas.drawPath(qiblaPath, qiblaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}