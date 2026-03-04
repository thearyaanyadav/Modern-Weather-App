class WeatherModel {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDeg;
  final int visibility;
  final int clouds;
  final String condition;
  final String description;
  final String icon;
  final int sunrise;
  final int sunset;
  final int dt;
  final int timezone;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
    required this.visibility,
    required this.clouds,
    required this.condition,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.dt,
    required this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      windDeg: json['wind']?['deg'] ?? 0,
      visibility: json['visibility'] ?? 0,
      clouds: json['clouds']?['all'] ?? 0,
      condition: json['weather']?[0]?['main'] ?? '',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '',
      sunrise: json['sys']?['sunrise'] ?? 0,
      sunset: json['sys']?['sunset'] ?? 0,
      dt: json['dt'] ?? 0,
      timezone: json['timezone'] ?? 0,
    );
  }

  bool get isNight {
    final now = dt;
    return now < sunrise || now > sunset;
  }

  String get windDirection {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((windDeg + 22.5) % 360 / 45).floor();
    return directions[index];
  }
}
