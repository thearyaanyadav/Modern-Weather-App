import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class ForecastCard extends StatelessWidget {
  final List<ForecastItem> dailyForecasts;
  final String unitSymbol;

  const ForecastCard({
    super.key,
    required this.dailyForecasts,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '5-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: List.generate(
              dailyForecasts.length > 5 ? 5 : dailyForecasts.length,
              (index) {
                final item = dailyForecasts[index];
                final isLast = index == (dailyForecasts.length > 5 ? 4 : dailyForecasts.length - 1);
                final dayName = index == 0
                    ? 'Today'
                    : DateFormat('EEE').format(item.dateTime);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          // Day name
                          SizedBox(
                            width: 56,
                            child: Text(
                              dayName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          // Weather icon
                          Icon(
                            AppColors.getWeatherIcon(item.condition),
                            size: 24,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 10),
                          // Condition
                          Expanded(
                            child: Text(
                              item.condition,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Precipitation
                          if (item.pop > 0) ...[
                            Icon(
                              Icons.water_drop,
                              size: 12,
                              color: AppColors.accentBlue.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${(item.pop * 100).round()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.accentBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          // Temperature range
                          Text(
                            '${item.tempMax.round()}°',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Temperature bar
                          SizedBox(
                            width: 48,
                            height: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: _tempProgress(item.tempMin, item.tempMax),
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _tempColor(item.tempMax),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.tempMin.round()}°',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 1,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double _tempProgress(double min, double max) {
    final range = max - min;
    if (range <= 0) return 0.5;
    return (range / 30).clamp(0.15, 1.0);
  }

  Color _tempColor(double temp) {
    if (temp >= 35) return AppColors.accentOrange;
    if (temp >= 25) return AppColors.accentYellow;
    if (temp >= 15) return AppColors.accentCyan;
    if (temp >= 5) return AppColors.accentBlue;
    return AppColors.accentPurple;
  }
}
