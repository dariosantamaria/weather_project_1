// ​​‍‍‌============‍‌​​​============‍‌‌​‍============‍‍​‍​============​‌‌‍‌============​‍​​‍============‌​​‍‍======‍​‌‍​
// Cosmic Weather — © 2025 Dario Santamaria
// Author: Dario Santamaria
// Licensed under the MIT License
// Email: dariosantamaria@hotmail.it
// Original repository: https://github.com/dariosantamaria/weather_project_1
//
// Unauthorized cloning will be reported to the Galactic Council.
// Crafted under the stars — keep this signature intact.
// ​​‍‍​============​​‍‍‌============​​‍‍‍============​‌​​​============​‌​​‌============​‌​​‍============​‌​‌​======​‌​‌‌

import 'dart:convert';
import 'package:flutter/foundation.dart';

/// =============================================================================
/// 🌦 WEATHER DEBUG TOOL
///
/// Strumento avanzato per:
/// - Stampare il JSON grezzo con formattazione
/// - Verificare la presenza dei campi principali
/// - Individuare valori sospetti (humidity=0, temp=null, ecc.)
/// - Ispezionare ogni sotto-sezione (main, weather, wind)
/// =============================================================================
class WeatherDebugTool {
  /// --------------------------------------------------------------------------
  /// 🔍 1. RAW JSON PRETTY PRINT
  /// --------------------------------------------------------------------------
  static void printRawJson(Map<String, dynamic> jsonData) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(jsonData);

    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("📦 RAW JSON (Pretty Print)");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    prettyString.split('\n').forEach(debugPrint);
  }

  /// --------------------------------------------------------------------------
  /// 🔍 2. JSON STRUCTURE INSPECTION
  /// --------------------------------------------------------------------------
  static void inspectJson(Map<String, dynamic> json) {
    debugPrint("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("🔬 WEATHER JSON INSPECTION");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // ---------------- MAIN SECTION ----------------
    final main = json["main"];
    if (main == null) {
      debugPrint("❌ main section MISSING");
    } else {
      debugPrint("🟦 main: $main");

      debugPrint("  • temp        = ${main['temp']}");
      debugPrint("  • feels_like  = ${main['feels_like']}");
      debugPrint("  • humidity    = ${main['humidity']}");

      if (main['humidity'] == 0) {
        debugPrint("⚠️ WARNING: humidity = 0 (sospetto)");
      }
    }

    // ---------------- WEATHER LIST SECTION ----------------
    final weatherList = json["weather"];
    if (weatherList == null || weatherList is! List || weatherList.isEmpty) {
      debugPrint("❌ weather[] section MISSING or EMPTY");
    } else {
      debugPrint("🟩 weather: ${weatherList[0]}");
      debugPrint("  • description = ${weatherList[0]['description']}");
      debugPrint("  • icon        = ${weatherList[0]['icon']}");
    }

    // ---------------- WIND SECTION ----------------
    final wind = json["wind"];
    if (wind == null) {
      debugPrint("❌ wind section MISSING");
    } else {
      debugPrint("🟨 wind: $wind");
      debugPrint("  • speed       = ${wind['speed']}");
    }

    // ---------------- LOCATION INFO ----------------
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("📍 LOCATION INFO");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    debugPrint("  • name        = ${json['name']}");
    debugPrint("  • timezone    = ${json['timezone']}");
    debugPrint("  • visibility  = ${json['visibility']}");

    // ---------------- GENERAL VALIDATION ----------------
    debugPrint("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("🧪 GENERAL VALIDATION");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    if (json["main"] != null && json["main"]['humidity'] == 0) {
      debugPrint("⚠️ POSSIBLE ERROR: humidity ALWAYS 0 - check parsing or API response.");
    }

    if (json["main"] != null && json["main"]['temp'] == null) {
      debugPrint("❌ ERROR: Temperature is NULL - unexpected from OpenWeather");
    }

    debugPrint("🔍 Weather JSON inspection complete.");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
  }
}
