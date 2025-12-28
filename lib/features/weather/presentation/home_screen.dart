import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_r/features/weather/presentation/weather_details_screen.dart.dart';

import 'package:weather_r/features/weather/model/weather_model.dart';
import 'package:weather_r/features/weather/data/get_api_weather.dart';
import 'package:weather_r/features/weather/data/get_location.dart';
import 'package:weather_r/features/weather/widget/hourly.dart';
import 'package:weather_r/spalsh_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GetApiWeather _weatherService = GetApiWeather();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
  }

  Future<Weather> _fetchWeather({String? cityName}) async {
    final city = cityName ?? await GetLocation().getCurrentLocation();
    return _weatherService.fetchWeatherByLocation(city);
  }

  String getweatherAnimation(String? conditionText, bool isDayTime) {
    if (conditionText == null || conditionText.isEmpty) {
      return 'assets/lotte/sunnyday.json';
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
        return isDayTime
            ? 'assets/lotte/cloud.json'
            : 'assets/lotte/ncloud.json';

      case 'rain':
      case 'light rain':
      case 'moderate rain':
      case 'heavy rain':
      case 'drizzle':
      case 'patchy rain possible':
      case 'shower rain':
        return isDayTime
            ? 'assets/lotte/rain.json'
            : 'assets/lotte/night_rain.json';

      case 'thunderstorm':
      case 'thundery outbreaks possible':
        return isDayTime
            ? 'assets/lotte/storm.json'
            : 'assets/lotte/nstorm.json';

      case 'clear':
      case 'sunny':
        return isDayTime
            ? 'assets/lotte/sunnyday.json'
            : 'assets/lotte/nclear.json';

      default:
        return isDayTime
            ? 'assets/lotte/sunnyday.json'
            : 'assets/lotte/nclear.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Weather>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpalshScreen());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load weather",
                style: TextStyle(color: Colors.cyanAccent),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No weather data",
                style: TextStyle(color: Colors.cyanAccent),
              ),
            );
          }

          final weather = snapshot.data!;

          final localDateStr = weather.location.localtime.split(' ')[0];
          final apiTodayStr = weather.forecast.forecastday.first.date;
          final isToday = localDateStr == apiTodayStr;
          final forecastDays = weather.forecast.forecastday;
          final day = forecastDays[0];
          final dt = DateTime.parse(weather.location.localtime);
          final formattedDate = DateFormat('d MMM').format(dt);
          final label = isToday ? 'Today' : DateFormat('EEEE').format(dt);

          return Center(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          weather.location.name,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$label, $formattedDate",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Lottie.asset(
                            getweatherAnimation(
                              weather.current.condition.text,
                              weather.current.isDay == 1,
                            ),
                            height: 320,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${weather.current.tempC.round()}°",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                weather.current.condition.text,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _InfoItem(
                                  "Temp",
                                  "${weather.current.tempC.round()}°",
                                ),
                                _InfoItem(
                                  "Wind",
                                  "${weather.current.windKph} km/h",
                                ),
                                _InfoItem(
                                  "Humidity",
                                  "${weather.current.humidity}%",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _InfoItem(
                                  "Avg Temp",
                                  "${day.day.avgtempC.round()}°",
                                ),
                                _InfoItem(
                                  "Min Temp",
                                  "${day.day.mintempC.round()}°",
                                ),
                                _InfoItem(
                                  "Max Temp",
                                  "${day.day.maxtempC.round()}°",
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _InfoItem(
                                  "Chance of Rain",
                                  "${day.day.dailyChanceOfRain}%",
                                ),
                                _InfoItem(
                                  "Chance of Snow",
                                  "${day.day.dailyChanceOfSnow}%",
                                ),
                                _InfoItem(
                                  "Max Wind",
                                  "${day.day.maxwindKph} km/w",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DailyForecastPage(weather: weather),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Today',
                                      style: TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 26,
                                      ),
                                    ),
                                    Text(
                                      'View Full Report',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Hourly(weather: weather),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, color: Colors.cyanAccent),
        ),
      ],
    );
  }
}
