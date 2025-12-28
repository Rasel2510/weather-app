import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_r/features/weather/model/weather_model.dart';

class DailyForecastPage extends StatelessWidget {
  final Weather weather;

  const DailyForecastPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final forecastDays = weather.forecast.forecastday;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent, width: 2),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  '${weather.location.name} Forecast',
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: forecastDays.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final day = forecastDays[index];
                      final isToday = index == 0;
                      final date = DateTime.parse(day.date);
                      final weekday = DateFormat('EEEE').format(date);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.lightBlue.withAlpha(20),

                              Colors.blueAccent.withAlpha(20),
                              Colors.cyanAccent.withAlpha(20),
                            ],
                          ),
                          // color: const Color.fromARGB(
                          //   255,
                          //   24,
                          //   24,
                          //   24,
                          // ), // Card color
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlueAccent.withAlpha(30),
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                            ),
                          ],
                          border: isToday
                              ? Border.all(
                                  color: Colors.lightBlueAccent,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Weather Icon with circular background
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? Colors.lightBlueAccent.withAlpha(80)
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.network(
                                  day.day.condition.icon,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.cloud,
                                        color: Colors.white70,
                                        size: 36,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Date & Condition
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      weekday,
                                      style: TextStyle(
                                        color: isToday
                                            ? Colors.lightBlueAccent
                                            : Colors.cyanAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      day.day.condition.text,
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Temperature & Rain
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Max: ${day.day.maxtempC}°C\nMin: ${day.day.mintempC}°C",
                                    style: TextStyle(
                                      color: isToday
                                          ? Colors.cyanAccent
                                          : Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.umbrella,
                                        size: 16,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${day.day.dailyChanceOfRain}%",
                                        style: const TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
