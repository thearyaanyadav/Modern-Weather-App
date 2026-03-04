import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final String unitSymbol;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Weather icon
        Icon(
          AppColors.getWeatherIcon(weather.condition, isNight: weather.isNight),
          size: 72,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        // Temperature
        Text(
          '${weather.temp.round()}$unitSymbol',
          style: textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        // Condition description
        Text(
          weather.description.split(' ').map((w) =>
            w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w
          ).join(' '),
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        // Feels like + H/L
        Text(
          'Feels like ${weather.feelsLike.round()}$unitSymbol  •  H: ${weather.tempMax.round()}$unitSymbol  L: ${weather.tempMin.round()}$unitSymbol',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class WeatherDetailRow extends StatelessWidget {
  final WeatherModel weather;
  final String windUnit;

  const WeatherDetailRow({
    super.key,
    required this.weather,
    required this.windUnit,
  });

  @override
  Widget build(BuildContext context) {
    final sunriseTime = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000),
    );
    final sunsetTime = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000),
    );

    return Column(
      children: [
        Row(
          children: [
            _DetailCard(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${weather.humidity}%',
              color: AppColors.accentBlue,
            ),
            const SizedBox(width: 12),
            _DetailCard(
              icon: Icons.air_rounded,
              label: 'Wind',
              value: '${weather.windSpeed.round()} $windUnit',
              subtitle: weather.windDirection,
              color: AppColors.accentCyan,
            ),
            const SizedBox(width: 12),
            _DetailCard(
              icon: Icons.compress_rounded,
              label: 'Pressure',
              value: '${weather.pressure}',
              subtitle: 'hPa',
              color: AppColors.accentPurple,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _DetailCard(
              icon: Icons.visibility_rounded,
              label: 'Visibility',
              value: (weather.visibility / 1000).toStringAsFixed(1),
              subtitle: 'km',
              color: AppColors.accentOrange,
            ),
            const SizedBox(width: 12),
            _DetailCard(
              icon: Icons.wb_sunny_outlined,
              label: 'Sunrise',
              value: sunriseTime,
              color: AppColors.accentYellow,
            ),
            const SizedBox(width: 12),
            _DetailCard(
              icon: Icons.nights_stay_outlined,
              label: 'Sunset',
              value: sunsetTime,
              color: AppColors.accentPink,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: 3),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
