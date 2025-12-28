import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

class Weather {
  final Location location;
  final Current current;
  final Forecast forecast;

  Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    location: Location.fromJson(json["location"]),
    current: Current.fromJson(json["current"]),
    forecast: Forecast.fromJson(json["forecast"]),
  );
}

// 🌍 Location Info
class Location {
  final String name;
  final String country;
  final String localtime;

  Location({
    required this.name,
    required this.country,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json["name"] ?? "",
    country: json["country"] ?? "",
    localtime: json["localtime"] ?? "",
  );
}

// ☁️ Current Weather
class Current {
  final double tempC;
  final double windKph;
  final int humidity;
  final int isDay;
  final Condition condition;

  Current({
    required this.tempC,
    required this.windKph,
    required this.humidity,
    required this.isDay,
    required this.condition,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    tempC: (json["temp_c"] ?? 0.0).toDouble(),
    windKph: (json["wind_kph"] ?? 0.0).toDouble(),
    humidity: json["humidity"] ?? 0,
    isDay: json["is_day"] ?? 1,
    condition: Condition.fromJson(json["condition"]),
  );
}

// 🌤️ Condition Text + Icon
class Condition {
  final String text;
  final String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    String rawIcon = json["icon"] ?? "";
    return Condition(
      text: json["text"] ?? "",
      icon: rawIcon.startsWith("//") ? "https:$rawIcon" : rawIcon,
    );
  }
}

// 📅 Forecast (List of Days)
class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
    forecastday: List<ForecastDay>.from(
      (json["forecastday"] as List)
          .map((x) => ForecastDay.fromJson(x))
          .toList(),
    ),
  );
}

// 📆 Each Day Forecast
class ForecastDay {
  final String date;
  final Day day;
  final List<Hour> hour; // ✅ Hourly Forecast

  ForecastDay({required this.date, required this.day, required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
    date: json["date"] ?? "",
    day: Day.fromJson(json["day"]),
    hour: List<Hour>.from(
      (json["hour"] as List).map((x) => Hour.fromJson(x)).toList(),
    ),
  );
}

// 🌞 Day Summary (for daily forecast)
class Day {
  final double maxtempC;
  final double mintempC;
  final double maxwindKph;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;
  final Condition condition;

  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.maxwindKph,
    required this.dailyChanceOfRain,
    required this.dailyChanceOfSnow,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    maxtempC: (json["maxtemp_c"] ?? 0.0).toDouble(),
    mintempC: (json["mintemp_c"] ?? 0.0).toDouble(),
    maxwindKph: (json["maxwind_kph"] ?? 0.0).toDouble(),
    dailyChanceOfRain: json["daily_chance_of_rain"] ?? 0,
    dailyChanceOfSnow: json["daily_chance_of_snow"] ?? 0,
    condition: Condition.fromJson(json["condition"]),
  );

  // ✅ Helper: Average Temperature
  double get avgtempC => (maxtempC + mintempC) / 2;
}

// 🕒 Hourly Forecast (24 hours)
class Hour {
  final String time;
  final double tempC;
  final double windKph;
  final int humidity;
  final int isDay;
  final int chanceOfRain;
  final int chanceOfSnow;
  final Condition condition;

  Hour({
    required this.time,
    required this.tempC,
    required this.windKph,
    required this.humidity,
    required this.isDay,
    required this.chanceOfRain,
    required this.chanceOfSnow,
    required this.condition,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
    time: json["time"] ?? "",
    tempC: (json["temp_c"] ?? 0.0).toDouble(),
    windKph: (json["wind_kph"] ?? 0.0).toDouble(),
    humidity: json["humidity"] ?? 0,
    isDay: json["is_day"] ?? 1,
    chanceOfRain: json["chance_of_rain"] ?? 0,
    chanceOfSnow: json["chance_of_snow"] ?? 0,
    condition: Condition.fromJson(json["condition"]),
  );
}
