class ForecastModel {
  final List<ForecastItem> items;
  final String cityName;
  final String country;

  ForecastModel({
    required this.items,
    required this.cityName,
    required this.country,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>? ?? [];
    return ForecastModel(
      items: list.map((item) => ForecastItem.fromJson(item)).toList(),
      cityName: json['city']?['name'] ?? '',
      country: json['city']?['country'] ?? '',
    );
  }

  /// Get daily forecasts (one per day, using midday data)
  List<ForecastItem> get dailyForecasts {
    final Map<String, ForecastItem> dailyMap = {};
    for (final item in items) {
      final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
      final key = '${date.year}-${date.month}-${date.day}';
      if (!dailyMap.containsKey(key) || date.hour >= 12 && date.hour <= 15) {
        dailyMap[key] = item;
      }
    }
    return dailyMap.values.toList();
  }

  /// Get today's hourly forecasts
  List<ForecastItem> get hourlyForecasts {
    final now = DateTime.now();
    return items.where((item) {
      final itemDate = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
      return itemDate.isAfter(now) &&
          itemDate.isBefore(now.add(const Duration(hours: 24)));
    }).toList();
  }
}

class ForecastItem {
  final int dt;
  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int humidity;
  final String condition;
  final String description;
  final String icon;
  final double windSpeed;
  final int clouds;
  final double pop; // probability of precipitation

  ForecastItem({
    required this.dt,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.humidity,
    required this.condition,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.clouds,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'] ?? 0,
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      condition: json['weather']?[0]?['main'] ?? '',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '',
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      clouds: json['clouds']?['all'] ?? 0,
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(dt * 1000);
}
