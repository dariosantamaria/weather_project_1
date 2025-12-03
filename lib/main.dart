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
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'screens/intro_screen.dart';
import 'debug/performance_debug.dart';

/// 👇👇👇 ADD: test-mode detector
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

class _StubGeolocator extends GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.always;
}

/// ============================================================================
/// 🚀 MAIN ENTRYPOINT (REAL / DEMO SELECTOR)
/// ============================================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Detect Integration Test Mode
  const bool isIntegrationTest =
      bool.fromEnvironment('INTEGRATION_TEST', defaultValue: false);

  if (isIntegrationTest) {
    debugPrint("🧪 Integration Test MODE attivo → Geolocator disabilitato");
    GeolocatorPlatform.instance = _StubGeolocator();
  }

  await _configureDevice();
  await _loadEnvironment();

  PerformanceDebug.start("app_boot");

  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const CosmicWeatherApp(),
    ),
  );
}

/// ============================================================================
/// 🔧 _configureDevice()
/// ============================================================================
Future<void> _configureDevice() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

/// ============================================================================
/// 🔧 _loadEnvironment() — REAL / DEMO AUTO-SELECTION
///
/// Usa:
///   --dart-define=ENV=REAL
///   --dart-define=ENV=DEMO
///
/// Default: REAL
/// ============================================================================
Future<void> _loadEnvironment() async {
  try {
    const env = String.fromEnvironment("ENV", defaultValue: "REAL");
    final file = env == "DEMO" ? "assets/.env.demo" : "assets/.env";

    debugPrint("🌍 Selected ENV: $env → loading $file");

    await dotenv.load(fileName: file);

    debugPrint("✅ .env file loaded");

    assert(() {
      debugPrint("🔎 ENV CONTENT: ${dotenv.env}");
      return true;
    }());
  } catch (e) {
    debugPrint("❌ Failed to load .env: $e");
  }
}

/// ============================================================================
/// 🎨 CosmicWeatherApp
/// ============================================================================
class CosmicWeatherApp extends StatelessWidget {
  const CosmicWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const IntroScreen(),
    );
  }
}