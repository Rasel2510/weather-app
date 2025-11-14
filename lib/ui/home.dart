import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/serviese/apiservice.dart';
import 'package:weather/serviese/get_location.dart';
import 'package:weather/ui/weather_datils.dart';
import 'package:weather/widget/hourly.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather({String? cityName}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final city = cityName ?? await GetLocation().getCurrentLocation();
      final weather = await _weatherService.fetchWeatherByLocation(city);

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getweatherAnimation(String? conditionText, bool isDayTime) {
    if (conditionText == null || conditionText.isEmpty) {
      return 'assets/sunnyday.json';
    }
    switch (conditionText.toLowerCase()) {
      case 'cloudy':
      case 'overcast':
      case 'partly cloudy':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return isDayTime ? 'assets/cloud.json' : 'assets/ncloud.json';

      case 'rain':
      case 'light rain':
      case 'moderate rain':
      case 'heavy rain':
      case 'drizzle':
      case 'patchy rain possible':
      case 'shower rain':
        return isDayTime ? 'assets/rain.json' : 'assets/night_rain.json';
      case 'thunderstorm':
      case 'thundery outbreaks possible':
        return isDayTime ? 'assets/storm.json' : 'assets/nstorm.json';

      case 'clear':
      case 'sunny':
        return isDayTime ? 'assets/sunnyday.json' : 'assets/nclear.json';

      default:
        return isDayTime ? 'assets/sunnyday.json' : 'assets/nclear.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    String label = '';
    String formattedDate = '';

    if (_weather != null) {
      final localDateStr = _weather!.location.localtime.split(' ')[0];
      final apiTodayStr = _weather!.forecast.forecastday.first.date;
      final isToday = localDateStr == apiTodayStr;

      final dt = DateTime.parse(_weather!.location.localtime);
      formattedDate = DateFormat('d MMM').format(dt);
      label = isToday ? 'Today' : DateFormat('EEEE').format(dt);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weather == null
          ? const Center(child: Text("Failed to load weather"))
          : Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          _weather!.location.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$label, $formattedDate",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Image.network(
                        //   _weather!.current.condition.icon,
                        //   height: 180,
                        //   width: 180,
                        //   fit: BoxFit.contain,
                        //   errorBuilder: (context, error, stackTrace) => const Icon(
                        //     Icons.wb_cloudy,
                        //     size: 120,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        Lottie.asset(
                          getweatherAnimation(
                            _weather!.current.condition.text,
                            _weather!.current.isDay == 1,
                          ),
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),

                        Text(
                          "${_weather!.current.tempC.round()}°",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _weather!.current.condition.text,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Temp",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${_weather!.current.tempC.round()}°",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Wind",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${_weather!.current.windKph} km/h",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Humidity",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${_weather!.current.humidity}%",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DailyForecastPage(weather: _weather!),
                                  ),
                                );
                              },
                              child: Text(
                                'View Full Report',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Hourly(weather: _weather!),
                        // HourlyForecast(weather: _weather!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
