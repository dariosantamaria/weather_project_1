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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/weather_provider.dart';

/// ============================================================================
/// 🌦️ WeatherScreen
///
/// EN:
/// Displays the detailed weather information.
/// Handles:
/// • Loading state
/// • Extracting & normalizing nested JSON values
/// • Dynamic Lottie animation
/// • Responsive weather UI
///
/// IT:
/// Mostra le informazioni meteo dettagliate.
/// Gestisce:
/// • Stato di caricamento
/// • Parsing sicuro dei dati JSON
/// • Animazione tramite Lottie
/// • UI moderna e responsive
/// ============================================================================
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  /// --------------------------------------------------------------------------
  /// 🔧 Safe JSON extractor
  ///
  /// EN: Extracts a value safely with type-checking + fallback
  /// IT: Estrae un valore JSON in sicurezza con controllo tipo + fallback
  /// --------------------------------------------------------------------------
  T _normalize<T>(dynamic value, T fallback) {
    try {
      if (value == null) return fallback;
      return value is T ? value : fallback;
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final weather = provider.weatherData;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cosmic Weather'),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : weather == null
              ? const Center(
                  child: Text(
                    'No weather data available 🚫',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : _content(context, weather),
    );
  }

  /// ==========================================================================
  /// 🌤 Content Builder
  ///
  /// Builds:
  /// • City name
  /// • Description
  /// • Lottie animation
  /// • Temperature
  /// • Humidity + Wind tiles
  /// ==========================================================================
  Widget _content(BuildContext context, Map<String, dynamic> weather) {
    // -------------------------------------------------------------------------
    // JSON extraction — FIX humidity bug here
    // -------------------------------------------------------------------------
    final city = _normalize<String>(weather['name'], "--");
    final desc =
        _normalize<String>(weather['weather']?[0]?['description'], "");
    final main =
        _normalize<String>(weather['weather']?[0]?['main'], "");
    final icon =
        _normalize<String>(weather['weather']?[0]?['icon'], "");

    final temp =
        _normalize<num>(weather['main']?['temp'], 0).toDouble();

    final humidity =
        _normalize<num>(weather['main']?['humidity'], 0).toInt();

    final wind =
        _normalize<num>(weather['wind']?['speed'], 0).toDouble();

    // Accent color by temperature
    final Color accent = temp < 10
        ? Colors.blueAccent
        : (temp < 25 ? Colors.cyanAccent : Colors.orangeAccent);

    // -------------------------------------------------------------------------
    // UI Rendering
    // -------------------------------------------------------------------------
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withOpacity(0.25),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
        child: Column(
          children: [
            Text(
              city.toUpperCase(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: accent,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              desc.isNotEmpty
                  ? desc[0].toUpperCase() + desc.substring(1)
                  : '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Lottie.asset(
                _animation(main, icon),
                width: 200,
                height: 200,
              ),
            ),

            Text(
              '${temp.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tile('💧 Humidity', '$humidity%', accent),
                _tile('🌬️ Wind', '${wind.toStringAsFixed(1)} m/s', accent),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================================================================
  /// 📊 Info Tile
  /// ==========================================================================
  Widget _tile(String label, String value, Color c) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
              color: c, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// ==========================================================================
  /// 🎬 Weather Animation Selector
  /// ==========================================================================
  String _animation(String main, String iconCode) {
    final m = main.toLowerCase();
    final i = iconCode.toLowerCase();

    if (m.contains('clear')) {
      return i.contains('n')
          ? 'assets/animations/night.json'
          : 'assets/animations/sunny.json';
    }
    if (m.contains('cloud')) return 'assets/animations/cloudy.json';
    if (m.contains('rain') || m.contains('drizzle'))
      return 'assets/animations/rain.json';
    if (m.contains('thunderstorm'))
      return 'assets/animations/rain.json';
    if (m.contains('snow')) return 'assets/animations/snow.json';
    if (m.contains('fog') ||
        m.contains('mist') ||
        m.contains('haze') ||
        m.contains('dust')) {
      return 'assets/animations/fog.json';
    }

    return 'assets/animations/cloudy.json';
  }
}
