import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_r/features/weather/model/weather_model.dart';

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
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: filteredHours.length,
        itemBuilder: (context, index) {
          final hour = filteredHours[index];
          final dateTime = DateTime.parse(hour.time);
          final time = DateFormat("h a").format(dateTime);
          final temp = hour.tempC.round();

          final isNow = dateTime.hour == now.hour;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              width: 75,
              decoration: BoxDecoration(
                color: isNow
                    ? Colors.blueAccent.withAlpha(120)
                    : Colors.blueGrey.withAlpha(60),
                borderRadius: BorderRadius.circular(15),
                border: isNow
                    ? Border.all(color: Colors.lightBlueAccent, width: 2)
                    : Border.all(color: Colors.white24, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon without circular background
                  Image.network(
                    hour.condition.icon,
                    height: 40,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.cloud,
                      color: Colors.white70,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isNow ? 'Now' : time,
                    style: TextStyle(
                      color: isNow ? Colors.lightBlueAccent : Colors.cyanAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$temp°',
                    style: TextStyle(
                      color: isNow ? Colors.cyanAccent : Colors.blueAccent,
                      fontSize: 16,
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
