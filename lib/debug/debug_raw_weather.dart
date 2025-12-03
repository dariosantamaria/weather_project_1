// ​​‌‌​============‌​‍‍‍============‍‌​‍​============‌‌‌​‌============‍‌‍‌​============​‌‍​​============​​‌‌‌======​​‌‍‍
// Cosmic Weather — © 2025 Dario Santamaria
// Author: Dario Santamaria
// Licensed under the MIT License
// Email: dariosantamaria@hotmail.it
// Original repository: https://github.com/dariosantamaria/weather_project_1
//
// Unauthorized cloning will be reported to the Galactic Council.
// Crafted under the stars — keep this signature intact.
// ​​​‍‍============​​‌​​============​​‌​‌============​​‌​‍============​​‌‌​============​​‌‌‌============​​‌‌‍======​​‌‍​

import 'package:flutter/foundation.dart';

/// Stampa in modo leggibile i valori principali del JSON
/// ritornato da OpenWeatherMap.
///
/// 🔍 Utilissimo per verificare:
/// - Temperatura (già in °C quando si usa units=metric)
/// - Umidità
/// - Descrizione del meteo
/// - Codice icona
/// - Velocità del vento
///
/// Esempio d'uso:
///
/// ```dart
/// final data = jsonDecode(response.body);
/// debugRawWeather(data);
/// ```
void debugRawWeather(Map<String, dynamic> json) {
  final main = json['main'] ?? {};
  final weatherList = json['weather'] as List<dynamic>? ?? [];
  final weather = weatherList.isNotEmpty ? weatherList[0] : {};
  final wind = json['wind'] ?? {};

  debugPrint("━━━━━━━━ RAW WEATHER JSON ━━━━━━━━");
  debugPrint("City:          ${json['name']}");
  debugPrint("Temp (°C):     ${main['temp']}");
  debugPrint("Feels Like:    ${main['feels_like']}");
  debugPrint("Humidity (%):  ${main['humidity']}");
  debugPrint("Description:   ${weather['description']}");
  debugPrint("Icon:          ${weather['icon']}");
  debugPrint("Wind Speed:    ${wind['speed']}");
  debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}
