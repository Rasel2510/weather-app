import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';

class DailyForecastPage extends StatelessWidget {
  final Weather weather;

  const DailyForecastPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final forecastDays = weather.forecast.forecastday;

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: ListView.builder(
          itemCount: forecastDays.length,
          itemBuilder: (context, index) {
            final day = forecastDays[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              color: const Color.fromARGB(255, 24, 24, 24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City Name
                    Text(
                      weather.location.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date & Condition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day.date,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              day.day.condition.text,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        Image.network(
                          day.day.condition.icon,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.cloud,
                                color: Colors.white54,
                                size: 36,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Temperature & Rain info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Max: ${day.day.maxtempC}°C\nMin: ${day.day.mintempC}°C",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Rain: ${day.day.dailyChanceOfRain}%",
                          style: const TextStyle(color: Colors.lightBlueAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
