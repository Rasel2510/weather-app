import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather/models/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final Weather weather;

  const HourlyForecast({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final allHours = weather.forecast.forecastday.first.hour;
    final now = DateTime.now();

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

          final rainChance = hour.chanceOfRain;

          final isNow = dateTime.hour == now.hour;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Text(
                  isNow ? 'Now' : time,
                  style: TextStyle(
                    color: isNow ? Colors.blueAccent : Colors.grey,
                    fontSize: 12,
                    fontWeight: isNow ? FontWeight.bold : FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$temp°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

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
