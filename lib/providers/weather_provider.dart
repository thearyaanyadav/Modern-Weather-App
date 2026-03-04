import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/city_image_model.dart';
import '../services/weather_service.dart';
import '../services/image_service.dart';
import '../services/location_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final ImageService _imageService = ImageService();
  final LocationService _locationService = LocationService();

  WeatherState _state = WeatherState.initial;
  WeatherModel? _weather;
  ForecastModel? _forecast;
  CityImageModel? _cityImage;
  String _errorMessage = '';
  String _currentCity = '';
  String _units = 'metric';
  List<String> _recentCities = [];

  // Getters
  WeatherState get state => _state;
  WeatherModel? get weather => _weather;
  ForecastModel? get forecast => _forecast;
  CityImageModel? get cityImage => _cityImage;
  String get errorMessage => _errorMessage;
  String get currentCity => _currentCity;
  String get units => _units;
  List<String> get recentCities => _recentCities;
  bool get isCelsius => _units == 'metric';

  String get unitSymbol => _units == 'metric' ? '°C' : '°F';
  String get windUnit => _units == 'metric' ? 'm/s' : 'mph';

  /// Fetch weather using GPS location
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      final lat = position.latitude;
      final lon = position.longitude;

      await _fetchWeatherData(lat, lon);
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Fetch weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final weather = await _weatherService.getWeatherByCity(city, units: _units);
      _weather = weather;
      _currentCity = weather.cityName;

      // Add to recent cities
      _addRecentCity(weather.cityName);

      // Fetch forecast and image in parallel
      final futures = await Future.wait([
        _weatherService.getForecastByCity(city, units: _units),
        _imageService.getCityImage(weather.cityName),
      ]);

      _forecast = futures[0] as ForecastModel;
      _cityImage = futures[1] as CityImageModel?;

      _state = WeatherState.loaded;
      notifyListeners();
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Refresh current weather data
  Future<void> refreshWeather() async {
    if (_currentCity.isNotEmpty) {
      await fetchWeatherByCity(_currentCity);
    } else {
      await fetchWeatherByLocation();
    }
  }

  /// Toggle units between metric and imperial
  void toggleUnits() {
    _units = _units == 'metric' ? 'imperial' : 'metric';
    notifyListeners();
    if (_currentCity.isNotEmpty) {
      fetchWeatherByCity(_currentCity);
    }
  }

  // Private methods
  Future<void> _fetchWeatherData(double lat, double lon) async {
    try {
      final weather = await _weatherService.getCurrentWeather(lat, lon, units: _units);
      _weather = weather;
      _currentCity = weather.cityName;

      _addRecentCity(weather.cityName);

      final futures = await Future.wait([
        _weatherService.getForecast(lat, lon, units: _units),
        _imageService.getCityImage(weather.cityName),
      ]);

      _forecast = futures[0] as ForecastModel;
      _cityImage = futures[1] as CityImageModel?;

      _state = WeatherState.loaded;
      notifyListeners();
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _addRecentCity(String city) {
    _recentCities.remove(city);
    _recentCities.insert(0, city);
    if (_recentCities.length > 8) {
      _recentCities = _recentCities.sublist(0, 8);
    }
  }
}
