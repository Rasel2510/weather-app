import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_r/features/weather/model/weather_model.dart';

class GetApiWeather {
  final String apiKey = "72e7e4f689134be0b3640336252309";
  final String baseUrl = "https://api.weatherapi.com/v1"; 
  Future<Weather> fetchWeatherByLocation(String cityName) async {
    final url = Uri.parse(
      '$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=7',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('error${response.statusCode}');
      }
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future fetchWeather(String cityName) async {}
}
