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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

// 👉 DEBUG TOOL (per vedere tutta la risposta meteo)
import '../debug/weather_debug.dart';

/// ============================================================================
/// 🌦 WeatherProvider
///
/// Provider centrale per caricare e gestire i dati meteo.
/// Include:
/// - GEO lookup
/// - FETCH meteo
/// - Debug completo JSON
/// - Safe parsing
/// - Stato loading
/// ============================================================================
class WeatherProvider extends ChangeNotifier {
  Map<String, dynamic>? weatherData;

  // ---------------------------------------------------------------------------
  // 🔧 Stato interno
  // ---------------------------------------------------------------------------
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // ---------------------------------------------------------------------------
  // 🔗 URL builders
  // ---------------------------------------------------------------------------
  String _geoUrl(String city) =>
      'https://api.openweathermap.org/geo/1.0/direct'
      '?q=$city&limit=1&appid=$_apiKey';

  String _weatherUrl(double lat, double lon) =>
      'https://api.openweathermap.org/data/2.5/weather'
      '?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=it';

  // ============================================================================
  // 🔧 PRIVATE HELPERS
  // ============================================================================

  void _handleHttpErrors(http.Response r, String origin) {
    switch (r.statusCode) {
      case 401:
        throw Exception("($origin) ❌ API key non valida");
      case 404:
        throw Exception("($origin) 🔎 Risorsa non trovata");
      case 429:
        throw Exception("($origin) ⚠️ Troppe richieste (Rate Limit)");
      case 500:
        throw Exception("($origin) 💥 Errore interno OpenWeather");
    }

    if (r.statusCode != 200) {
      throw Exception("($origin) ❌ Errore HTTP generico: ${r.statusCode}");
    }
  }

  T _safe<T>(dynamic value, T fallback) {
    try {
      if (value == null) return fallback;
      return value is T ? value : fallback;
    } catch (_) {
      return fallback;
    }
  }

  // ============================================================================
  // 🌍 PUBLIC API
  // ============================================================================

  /// ==========================================================================
  /// 🌦️ Meteo da nome città
  /// ==========================================================================
  Future<void> fetchWeatherByCity(String cityName) async {
    if (_apiKey.isEmpty) {
      debugPrint("❌ API Key non trovata nel file .env");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // -------------------------------------------------------
      // 1️⃣ GEO lookup
      // -------------------------------------------------------
      final geoResp = await http.get(Uri.parse(_geoUrl(cityName)));
      _handleHttpErrors(geoResp, "GEO");

      final geoData = jsonDecode(geoResp.body);
      if (geoData.isEmpty) throw Exception("Città non trovata");

      final lat = _safe<double>(geoData[0]['lat'], 0.0);
      final lon = _safe<double>(geoData[0]['lon'], 0.0);
      final resolvedName = _safe<String>(geoData[0]['name'], "Unknown");
      final country = _safe<String>(geoData[0]['country'], "--");

      debugPrint("📍 GEO → $resolvedName ($country) → $lat, $lon");

      // -------------------------------------------------------
      // 2️⃣ WEATHER lookup
      // -------------------------------------------------------
      final weatherResp = await http.get(Uri.parse(_weatherUrl(lat, lon)));
      _handleHttpErrors(weatherResp, "WEATHER");

      final decoded = jsonDecode(weatherResp.body);

      // 🔥 DEBUG AVANZATO
      WeatherDebugTool.printRawJson(decoded);
      WeatherDebugTool.inspectJson(decoded);

      weatherData = decoded;
    } catch (e) {
      debugPrint("⚠️ Errore meteo città: $e");
      weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ==========================================================================
  /// 📍 Meteo tramite GPS 
  /// ==========================================================================
  Future<void> fetchWeatherByLocation() async {
    if (_apiKey.isEmpty) {
      debugPrint("❌ API Key non trovata nel file .env");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // -------------------------------------------------------
      // 1️⃣ Permissions
      // -------------------------------------------------------
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          throw Exception("Permesso localizzazione negato");
        }
      }

      if (perm == LocationPermission.deniedForever) {
        throw Exception("Permessi GPS disattivati permanentemente");
      }

      // -------------------------------------------------------
      // 2️⃣ Coordinates
      // -------------------------------------------------------
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint("📡 GPS → ${pos.latitude}, ${pos.longitude}");

      // -------------------------------------------------------
      // 3️⃣ WEATHER lookup
      // -------------------------------------------------------
      final resp =
          await http.get(Uri.parse(_weatherUrl(pos.latitude, pos.longitude)));

      _handleHttpErrors(resp, "WEATHER");

      final decoded = jsonDecode(resp.body);

      // 🔥 DEBUG AVANZATO
      WeatherDebugTool.printRawJson(decoded);
      WeatherDebugTool.inspectJson(decoded);

      weatherData = decoded;
    } catch (e) {
      debugPrint("⚠️ Errore meteo GPS: $e");
      weatherData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
