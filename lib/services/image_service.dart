import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/city_image_model.dart';

class ImageService {
  final Map<String, CityImageModel> _cache = {};

  Future<CityImageModel?> getCityImage(String cityName) async {
    // Check cache first
    if (_cache.containsKey(cityName.toLowerCase())) {
      return _cache[cityName.toLowerCase()];
    }

    try {
      final url = AppConstants.cityImageUrl(cityName);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>?;

        if (results != null && results.isNotEmpty) {
          final image = CityImageModel.fromJson(results[0]);
          _cache[cityName.toLowerCase()] = image;
          return image;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
