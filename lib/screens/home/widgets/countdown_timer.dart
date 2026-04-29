import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final String? prayerName;
  final VoidCallback? onComplete;

  const CountdownTimer({
    super.key,
    required this.targetTime,
    this.prayerName,
    this.onComplete,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final diff = widget.targetTime.difference(now);

    if (diff.isNegative) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
      _remaining = Duration.zero;
    } else {
      _remaining = diff;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.prayerName != null)
          Text(
            widget.prayerName!,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          _formatDuration(_remaining),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 44,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}