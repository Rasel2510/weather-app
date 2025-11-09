import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:weather_r/models/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final Weather weather;

  const HourlyForecast({super.key, required this.weather});

  // 🎞️ Animation select based on condition or rain chance
  String getWeatherAnimation(String condition, bool isDay, int rainChance) {
    condition = condition.toLowerCase();

    if (rainChance >= 40) {
      return isDay ? 'assets/rain.json' : 'assets/night_rain.json';
    }

    switch (condition) {
      case String c
          when c.contains('rain') ||
              c.contains('drizzle') ||
              c.contains('shower'):
        return isDay ? 'assets/rain.json' : 'assets/night_rain.json';

      case String c when c.contains('thunder'):
        return isDay ? 'assets/storm.json' : 'assets/nstorm.json';

      case String c
          when c.contains('fog') || c.contains('mist') || c.contains('haze'):
        return 'assets/fog.json';

      case String c when c.contains('snow'):
        return 'assets/snow.json';

      case String c when c.contains('cloud') || c.contains('overcast'):
        return isDay ? 'assets/cloud.json' : 'assets/ncloud.json';

      case String c when c.contains('sunny') || c.contains('clear'):
        return isDay ? 'assets/sunnyday.json' : 'assets/nclear.json';

      default:
        return isDay ? 'assets/cloud.json' : 'assets/ncloud.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allHours = weather.forecast.forecastday.first.hour;
    final now = DateTime.now();

    // ⏰ Filter: show only current hour → next 12 hours
    final filteredHours = allHours.where((h) {
      final hourTime = DateTime.parse(h.time);
      final difference = hourTime.difference(now).inHours;
      return difference >= 0 && difference <= 12;
    }).toList();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filteredHours.length,
        itemBuilder: (context, index) {
          final hour = filteredHours[index];
          final dateTime = DateTime.parse(hour.time);
          final time = DateFormat('h a').format(dateTime);
          final temp = hour.tempC.round();
          final conditionText = hour.condition.text;
          final rainChance = hour.chanceOfRain;
          final isDay = hour.isDay == 1;

          final animationPath = getWeatherAnimation(
            conditionText,
            isDay,
            rainChance,
          );

          final isNow = dateTime.hour == now.hour;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎬 Lottie Animation
                Lottie.asset(animationPath, height: 33, fit: BoxFit.contain),

                const SizedBox(height: 10),

                // 🕒 Time
                Text(
                  isNow ? 'Now' : time,
                  style: TextStyle(
                    color: isNow ? Colors.blueAccent : Colors.grey,
                    fontSize: 12,
                    fontWeight: isNow ? FontWeight.bold : FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // 🌡️ Temperature
                Text(
                  '$temp°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 💧 Rain chance
                if (rainChance > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '💧$rainChance%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
