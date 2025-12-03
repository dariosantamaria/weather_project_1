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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../debug/debug_raw_weather.dart';

/// ============================================================================
/// 🌦️ WeatherService
///
/// EN:
/// Service responsible for fetching weather data from the OpenWeather API,
/// either by using the device GPS position or by specifying a city name.
/// Handles:
/// - GPS permission flow
/// - Network calls
/// - JSON decoding
/// - Error validation
///
/// IT:
/// Servizio incaricato di ottenere i dati meteo dall’API OpenWeather,
/// usando la posizione GPS del dispositivo oppure una città specificata.
/// Gestisce:
/// - Flusso permessi GPS
/// - Chiamate HTTP
/// - Decodifica JSON
/// - Validazione errori
/// ============================================================================
class WeatherService {
  /// Base endpoint for OpenWeather API.
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  /// API key loaded securely from `.env`.
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? "";

  // ===========================================================================
  // 📍 Fetch weather by GPS position
  // ===========================================================================
  /// EN:
  /// Retrieves weather information based on the user's current GPS location.
  ///
  /// IT:
  /// Recupera i dati meteo in base alla posizione GPS corrente dell’utente.
  Future<Map<String, dynamic>> fetchWeatherByLocation() async {
    final position = await _determinePosition();

    final url =
        '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Errore caricamento meteo');
    }

    final data = jsonDecode(response.body);
    debugRawWeather(data);
    return data;
  }

  // ===========================================================================
  // 🏙 Fetch weather by city name
  // ===========================================================================
  /// EN:
  /// Retrieves weather data for a given city name (case-insensitive).
  ///
  /// IT:
  /// Recupera i dati meteo per una specifica città (case-insensitive).
  Future<Map<String, dynamic>> fetchWeatherByCity(String city) async {
    final url = '$baseUrl?q=$city&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Errore caricamento meteo per città');
    }

    final data = jsonDecode(response.body);
    debugRawWeather(data);
    return data;
  }

  // ===========================================================================
  // 📡 Determine user GPS position (permissions included)
  // ===========================================================================
  /// EN:
  /// Handles the full permission flow + retrieves GPS coordinates.
  ///
  /// IT:
  /// Gestisce l’intero flusso dei permessi + ritorna le coordinate GPS.
  Future<Position> _determinePosition() async {
    // Check if GPS is enabled
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('GPS disabilitato');

    // Permission check
    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw Exception('Permesso posizione negato');
      }
    }

    if (perm == LocationPermission.deniedForever) {
      throw Exception('Permesso di posizione negato permanentemente');
    }

    // Retrieve GPS coordinates
    return Geolocator.getCurrentPosition();
  }
}
