// ‌‌‍‍‌============​​‌‍‍============​‍‍​‌============‍‌‍​​============​‍‍​​============​​​‌​============‌‍‌‍‌======‌‍​‌‌
// Cosmic Weather — © 2025 Dario Santamaria
// Author: Dario Santamaria
// Licensed under the MIT License
// Email: dariosantamaria@hotmail.it
// Original repository: https://github.com/dariosantamaria/weather_project_1
//
// Unauthorized cloning will be reported to the Galactic Council.
// Crafted under the stars — keep this signature intact.
// ​​​​​============​​​​‌============​​​​‍============​​​‌​============​​​‌‌============​​​‌‍============​​​‍​======​​​‍‌

import 'package:flutter/foundation.dart';

/// =============================================================================
/// 🌦 WEATHER MODEL — Complete, robust, fault-tolerant, fully logged
///
/// This model represents the parsed result of the OpenWeather API response.
/// It includes:
///  • Defensive JSON parsing
///  • Detailed log output
///  • Full inspection of `main`, `weather`, and `wind` objects
///  • Safe fallback values
/// =============================================================================
class Weather {
  final String cityName;
  final double tempC;
  final String description;
  final String icon;
  final double feelsLikeC;
  final int humidity;       // percentage (0–100)
  final double windSpeed;   // m/s

  Weather({
    required this.cityName,
    required this.tempC,
    required this.description,
    required this.icon,
    required this.feelsLikeC,
    required this.humidity,
    required this.windSpeed,
  });

  /// ===========================================================================
  /// 🔍 FACTORY: Weather.fromJson()
  ///
  /// This includes extremely detailed logging:
  ///  • Raw JSON
  ///  • Extracted keys
  ///  • Humidity verification
  ///  • Type safety checks
  /// ===========================================================================
  factory Weather.fromJson(Map<String, dynamic> json) {
    debugPrint("────────────────────────────────────────────");
    debugPrint("🌦 WEATHER.fromJson() — RAW INPUT JSON:");
    debugPrint(json.toString());
    debugPrint("────────────────────────────────────────────");

    final city = json['name'] ?? '';
    final main = json['main'] ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final w = weatherList.isNotEmpty ? weatherList[0] : {};
    final wind = json['wind'] ?? {};

    // Log estrazione valori
    debugPrint("🏙 city = $city");
    debugPrint("🌡 temp = ${main['temp']}");
    debugPrint("🌡 feelsLike = ${main['feels_like']}");
    debugPrint("💧 humidity(raw) = ${main['humidity']}");
    debugPrint("💨 windSpeed(raw) = ${wind['speed']}");
    debugPrint("🌤 description = ${w['description']}");
    debugPrint("🖼 icon = ${w['icon']}");

    // Umidità estratta in modo sicuro
    final humidityParsed = (main['humidity'] as num?)?.toInt() ?? -1;

    debugPrint("💧 humidity(parsed) = $humidityParsed");
    debugPrint("────────────────────────────────────────────");

    return Weather(
      cityName: city,
      tempC: (main['temp'] as num?)?.toDouble() ?? 0.0,
      description: (w['description'] ?? '').toString(),
      icon: (w['icon'] ?? '01d').toString(),
      feelsLikeC: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: humidityParsed,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
