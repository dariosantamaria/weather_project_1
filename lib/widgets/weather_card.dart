// ​​‍‌‌============‍​‍‍‌============‍‍‌‍‍============‍‍‍‌‍============‌‍​‌‌============‍‌‌‌‌============​​‍​​======‌‌‌​‌
// Cosmic Weather — © 2025 Dario Santamaria
// Author: Dario Santamaria
// Licensed under the MIT License
// Email: dariosantamaria@hotmail.it
// Original repository: https://github.com/dariosantamaria/weather_project_1
//
// Unauthorized cloning will be reported to the Galactic Council.
// Crafted under the stars — keep this signature intact.
// ​​‌‍‌============​​‌‍‍============​​‍​​============​​‍​‌============​​‍​‍============​​‍‌​============​​‍‌‌======​​‍‌‍

import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'package:intl/intl.dart';

/// ============================================================================
/// 🌤️ WeatherCard
///
/// EN:
/// Display widget showing essential weather information for the current city.
/// It includes:
/// - City name
/// - Current temperature
/// - "Feels like" temperature
/// - Description + weather icon
/// - Humidity and wind speed
///
/// IT:
/// Widget UI che mostra le informazioni meteo essenziali:
/// - Nome città
/// - Temperatura attuale
/// - Temperatura percepita
/// - Descrizione e icona meteo
/// - Umidità e velocità del vento
///
/// Designed as a reusable card with a clear and modern layout.
/// ============================================================================
class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final temp = weather.tempC.toStringAsFixed(1);
    final feelsLike = weather.feelsLikeC.toStringAsFixed(1);
    final formattedDate =
        DateFormat('EEE, d MMM • HH:mm').format(DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(weather.cityName, formattedDate),
            const SizedBox(height: 12),
            _buildMainInfo(temp, feelsLike),
            const SizedBox(height: 12),
            _buildExtraInfo(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 🏙 Header section — City name + date
  // ===========================================================================
  Widget _buildHeader(String city, String date) {
    return Column(
      children: [
        Text(
          city,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  // ===========================================================================
  // 🌡️ Main weather info — Icon + temperature + description
  // ===========================================================================
  Widget _buildMainInfo(String temp, String feelsLike) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
          width: 90,
          height: 90,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.cloud_off,
            size: 60,
            color: Colors.white38,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$temp °C',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Feels like: $feelsLike °C',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 💧 Extra info section — Humidity & wind speed
  // ===========================================================================
  Widget _buildExtraInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _smallInfo('Humidity', '${weather.humidity}%'),
        _smallInfo('Wind', '${weather.windSpeed} m/s'),
      ],
    );
  }

  // ===========================================================================
  // 🔹 Small reusable info widget
  // ===========================================================================
  Widget _smallInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
