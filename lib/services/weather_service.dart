import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeather(double lat, double lon, {String units = 'metric'}) async {
    final url = AppConstants.currentWeatherUrl(lat, lon, units: units);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw WeatherException('API key not active yet — new OpenWeatherMap keys can take up to 2 hours to activate. Please wait and try again!');
    } else {
      throw WeatherException('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<ForecastModel> getForecast(double lat, double lon, {String units = 'metric'}) async {
    final url = AppConstants.forecastUrl(lat, lon, units: units);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw WeatherException('API key not active yet — please wait up to 2 hours after signup.');
    } else {
      throw WeatherException('Failed to load forecast data: ${response.statusCode}');
    }
  }

  Future<WeatherModel> getWeatherByCity(String city, {String units = 'metric'}) async {
    final url = AppConstants.weatherByCityUrl(city, units: units);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw WeatherException('City not found: $city');
    } else {
      throw WeatherException('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<ForecastModel> getForecastByCity(String city, {String units = 'metric'}) async {
    final url = AppConstants.forecastByCityUrl(city, units: units);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw WeatherException('Failed to load forecast data: ${response.statusCode}');
    }
  }
}

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}
