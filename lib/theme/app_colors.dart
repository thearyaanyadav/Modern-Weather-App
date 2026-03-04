import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Colors
  static const darkBg = Color(0xFF0F1624);
  static const darkSurface = Color(0xFF1A2332);
  static const darkCard = Color(0xFF1E293B);
  static const darkCardHover = Color(0xFF243044);

  // Light Mode Colors
  static const lightBg = Color(0xFFF7F8FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardHover = Color(0xFFF0F2F8);

  // Accent Colors
  static const accentBlue = Color(0xFF60A5FA);
  static const accentPurple = Color(0xFF818CF8);
  static const accentCyan = Color(0xFF22D3EE);
  static const accentOrange = Color(0xFFFB923C);
  static const accentPink = Color(0xFFF472B6);
  static const accentYellow = Color(0xFFFBBF24);

  // Text Colors
  static const darkText = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const lightText = Color(0xFF1E293B);
  static const lightTextSecondary = Color(0xFF64748B);

  // Weather Condition Gradients
  static const sunnyGradient = [Color(0xFFF59E0B), Color(0xFFF97316), Color(0xFFEF4444)];
  static const clearNightGradient = [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)];
  static const cloudyGradient = [Color(0xFF475569), Color(0xFF64748B), Color(0xFF94A3B8)];
  static const rainyGradient = [Color(0xFF1E3A5F), Color(0xFF2563EB), Color(0xFF3B82F6)];
  static const snowGradient = [Color(0xFFBFDBFE), Color(0xFFDBEAFE), Color(0xFFEFF6FF)];
  static const thunderGradient = [Color(0xFF1F2937), Color(0xFF374151), Color(0xFF4B5563)];
  static const fogGradient = [Color(0xFF9CA3AF), Color(0xFFD1D5DB), Color(0xFFE5E7EB)];

  // Glass Effect
  static const glassWhite = Color(0x33FFFFFF);
  static const glassBorder = Color(0x22FFFFFF);
  static const glassDark = Color(0x33000000);

  static List<Color> getWeatherGradient(String condition, {bool isNight = false}) {
    if (isNight && (condition == 'Clear' || condition == 'clear sky')) {
      return clearNightGradient;
    }
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'clear sky':
        return sunnyGradient;
      case 'clouds':
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
      case 'overcast clouds':
        return cloudyGradient;
      case 'rain':
      case 'light rain':
      case 'moderate rain':
      case 'heavy intensity rain':
      case 'drizzle':
      case 'shower rain':
        return rainyGradient;
      case 'snow':
      case 'light snow':
      case 'heavy snow':
        return snowGradient;
      case 'thunderstorm':
        return thunderGradient;
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
        return fogGradient;
      default:
        return isNight ? clearNightGradient : sunnyGradient;
    }
  }

  static IconData getWeatherIcon(String condition, {bool isNight = false}) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'clear sky':
        return isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
      case 'clouds':
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
      case 'overcast clouds':
        return Icons.cloud_rounded;
      case 'rain':
      case 'light rain':
      case 'moderate rain':
      case 'heavy intensity rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.water_drop_rounded;
      case 'snow':
      case 'light snow':
      case 'heavy snow':
        return Icons.ac_unit_rounded;
      case 'thunderstorm':
        return Icons.flash_on_rounded;
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
        return Icons.foggy;
      default:
        return Icons.wb_sunny_rounded;
    }
  }
}
