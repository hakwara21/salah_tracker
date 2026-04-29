import 'dart:math' as math;

class QiblaCalculator {
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  static double calculateQiblaDirection(double latitude, double longitude) {
    final latRad = _toRadians(latitude);
    final lonRad = _toRadians(longitude);

    final kaabaLatRad = _toRadians(kaabaLatitude);
    final kaabaLonRad = _toRadians(kaabaLongitude);

    final y = math.sin(kaabaLonRad - lonRad);
    final x = math.cos(latRad) * math.tan(kaabaLatRad) -
              math.sin(latRad) * math.cos(kaabaLonRad - lonRad);

    final qiblaRad = math.atan2(y, x);
    double qiblaDeg = _toDegrees(qiblaRad);

    qiblaDeg = (qiblaDeg + 360) % 360;

    return qiblaDeg;
  }

  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  static double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  static String getDirectionName(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'شمال';
    if (degrees >= 22.5 && degrees < 67.5) return 'شمال شرق';
    if (degrees >= 67.5 && degrees < 112.5) return 'شرق';
    if (degrees >= 112.5 && degrees < 157.5) return 'جنوب شرق';
    if (degrees >= 157.5 && degrees < 202.5) return 'جنوب';
    if (degrees >= 202.5 && degrees < 247.5) return 'جنوب غرب';
    if (degrees >= 247.5 && degrees < 292.5) return 'غرب';
    if (degrees >= 292.5 && degrees < 337.5) return 'شمال غرب';
    return '';
  }

  static double normalizeAngle(double angle) {
    return (angle + 360) % 360;
  }

  static double calculateAngleDifference(double currentHeading, double targetHeading) {
    double diff = targetHeading - currentHeading;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }
}