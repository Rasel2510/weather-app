import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather/models/weather_model.dart';

class Hourly extends StatelessWidget {
  final Weather weather;
  const Hourly({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final allHours = [
      ...weather.forecast.forecastday[0].hour,
      ...weather.forecast.forecastday[1].hour,
    ];
    final now = DateTime.now();
    final filteredHours = allHours.where((h) {
      final hourTime = DateTime.parse(h.time);
      final different = hourTime.difference(now).inHours;
      return different >= 0 && different <= 24;
    }).toList();

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: filteredHours.length,
        itemBuilder: (context, index) {
          final hour = filteredHours[index];
          final dateTime = DateTime.parse(hour.time);
          final time = DateFormat("h a").format(dateTime);
          final temp = hour.tempC.round();

          final isNow = dateTime.hour == now.hour;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Container(
              width: 75,
              decoration: BoxDecoration(
                color: isNow
                    ? const Color.fromARGB(118, 68, 137, 255)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    hour.condition.icon,
                    height: 40,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.cloud, color: Colors.white54, size: 36),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isNow ? 'Now' : time,
                    style: TextStyle(
                      color: isNow ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$temp°',
                    style: TextStyle(
                      fontSize: 16,
                      color: isNow ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
