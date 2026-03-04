class AppConstants {
  // OpenWeatherMap API (direct - for demo/portfolio use)
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherApiKey = '6c62dde1884d5af5c1c6d87f5794c1e0'; // Replace with your key

  // Unsplash API
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static const String unsplashAccessKey = '9CvrR-ZbHzQSAeSECnRzkwPnUYSXThcg2sD2ACbFNj4'; // Replace with your key

  // Default settings
  static const String defaultUnits = 'metric'; // metric = Celsius, imperial = Fahrenheit
  static const String defaultCity = 'London';
  static const double defaultLat = 51.5074;
  static const double defaultLon = -0.1278;

  // Weather API endpoints
  static String currentWeatherUrl(double lat, double lon, {String units = defaultUnits}) =>
      '$weatherBaseUrl/weather?lat=$lat&lon=$lon&units=$units&appid=$weatherApiKey';

  static String forecastUrl(double lat, double lon, {String units = defaultUnits}) =>
      '$weatherBaseUrl/forecast?lat=$lat&lon=$lon&units=$units&appid=$weatherApiKey';

  static String weatherByCityUrl(String city, {String units = defaultUnits}) =>
      '$weatherBaseUrl/weather?q=$city&units=$units&appid=$weatherApiKey';

  static String forecastByCityUrl(String city, {String units = defaultUnits}) =>
      '$weatherBaseUrl/forecast?q=$city&units=$units&appid=$weatherApiKey';

  // Unsplash API endpoints
  static String cityImageUrl(String query) =>
      '$unsplashBaseUrl/search/photos?query=$query+city+skyline&per_page=1&orientation=landscape&client_id=$unsplashAccessKey';

  // OpenWeatherMap icon URL
  static String weatherIconUrl(String icon) =>
      'https://openweathermap.org/img/wn/$icon@4x.png';
}
