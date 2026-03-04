import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class HourlyForecast extends StatelessWidget {
  final List<ForecastItem> items;
  final String unitSymbol;

  const HourlyForecast({
    super.key,
    required this.items,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Hourly Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: items.length > 8 ? 8 : items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final time = DateFormat('ha').format(item.dateTime);

              return GlassCard(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      index == 0 ? 'Now' : time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    Icon(
                      AppColors.getWeatherIcon(item.condition),
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    Text(
                      '${item.temp.round()}$unitSymbol',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.pop > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 10,
                            color: AppColors.accentBlue.withValues(alpha: 0.7),
                          ),
                          Text(
                            '${(item.pop * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.accentBlue,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(height: 14),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
