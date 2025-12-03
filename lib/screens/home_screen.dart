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

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/planet_service.dart';
import '../providers/weather_provider.dart';
import '../widgets/animated_planet.dart';
import 'weather_screen.dart';

/// ============================================================================
/// 🌌 AuroraHomeScreen
///
/// EN:
/// Animated cosmic welcome screen featuring:
/// - Aurora gradient animation
/// - Floating/rotating planet loaded securely from backend
/// - Weather source selector (GPS or City)
///
/// IT:
/// Schermata animata di benvenuto che include:
/// - Animazione aurora dinamica
/// - Pianeta fluttuante/caricato in sicurezza dal server
/// - Selettore sorgente meteo (GPS o città)
///
/// ============================================================================
class AuroraHomeScreen extends StatefulWidget {
  final ui.Image? preloadedPlanet;
  final String? preloadError;

  const AuroraHomeScreen({
    super.key,
    this.preloadedPlanet,
    this.preloadError,
  });

  @override
  State<AuroraHomeScreen> createState() => _AuroraHomeScreenState();
}

class _AuroraHomeScreenState extends State<AuroraHomeScreen>
    with TickerProviderStateMixin {

  // ---------------------------------------------------------------------------
  // 🌈 Aurora animation controller
  // ---------------------------------------------------------------------------
  late AnimationController _gradientController;
  late Animation<double> _gradientShift;

  ui.Image? planetImage;
  String? planetError;

  bool _loadStarted = false;
  bool _loadFinished = false;

  static const int totalFrames = 32;

  @override
  void initState() {
    super.initState();

    // -----------------------------------------------------------------------
    // EN: Aurora gradient animation (soft looping wave)
    // IT: Animazione gradiente dell’aurora (morbida e ciclica)
    // -----------------------------------------------------------------------
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _gradientShift = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_gradientController);

    // -----------------------------------------------------------------------
    // EN: Use preloaded PNG if already fetched during bootstrap
    // IT: Usa PNG precaricato se già disponibile all’avvio
    // -----------------------------------------------------------------------
    if (widget.preloadedPlanet != null || widget.preloadError != null) {
      planetImage = widget.preloadedPlanet;
      planetError = widget.preloadError;
      _loadFinished = true;
    } else {
      _loadPlanetOnce();
    }
  }

  // ==========================================================================
  // 🪐 Secure planet loading logic
  // ==========================================================================
  Future<void> _loadPlanetOnce() async {
    if (_loadStarted) return;
    _loadStarted = true;

    try {
      final Uint8List bytes =
          await PlanetService.fetchPlanetSprite(frames: totalFrames);

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      setState(() {
        planetImage = frame.image;
        _loadFinished = true;
      });
    } catch (e) {
      setState(() {
        planetError = e.toString();
        _loadFinished = true;
      });
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // 🖼 UI BUILD
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ------------------------------------------------------------------
          // 🌌 Animated aurora background
          // ------------------------------------------------------------------
          AnimatedBuilder(
            animation: _gradientShift,
            builder: (_, __) {
              final colors = [
                Colors.deepPurple.withOpacity(0.85),
                Colors.cyanAccent.withOpacity(0.7),
                Colors.indigo.withOpacity(0.9),
              ];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      (math.sin(_gradientShift.value) + 1) / 2,
                      (math.cos(_gradientShift.value) + 1) / 2,
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // ------------------------------------------------------------------
          // 🪐 Floating animated planet
          // ------------------------------------------------------------------
          if (_loadFinished && planetImage != null)
            Positioned(
              top: screenHeight * 0.16,
              child: AnimatedPlanet(
                sprite: planetImage!,
                totalFrames: totalFrames,
                size: 240,
                floatRange: 30,
                floatDuration: const Duration(seconds: 4),
              ),
            ),

          // ------------------------------------------------------------------
          // ⚠️ Error loading planet
          // ------------------------------------------------------------------
          if (_loadFinished && planetError != null)
            Center(
              child: Text(
                "⚠️ Errore:\n$planetError",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ------------------------------------------------------------------
          // ⏳ Loader while PNG downloads
          // ------------------------------------------------------------------
          if (!_loadFinished)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // ------------------------------------------------------------------
          // 🌌 Title + ENTER button
          // ------------------------------------------------------------------
          Positioned(
            bottom: screenHeight * 0.18,
            child: Column(
              children: [
                Text(
                  'COSMIC WEATHER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white.withOpacity(0.95),
                    shadows: [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildEnterButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 🔘 ENTER BUTTON
  // ==========================================================================
  Widget _buildEnterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final provider = context.read<WeatherProvider>();

        // ---------------------------------------------------------------
        // Choose source: GPS or city
        // ---------------------------------------------------------------
        final choice = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Choose Weather Source'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'gps'),
                child: const Text('📍 Use my location'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'city'),
                child: const Text('🏙️ Choose city'),
              ),
            ],
          ),
        );

        if (choice == 'gps') {
          await provider.fetchWeatherByLocation();
        } else if (choice == 'city') {
          final city = await _askCity(context);
          if (city != null && city.isNotEmpty) {
            await provider.fetchWeatherByCity(city);
          }
        }

        // ---------------------------------------------------------------
        // Navigate if data ready
        // ---------------------------------------------------------------
        if (provider.weatherData != null && context.mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const WeatherScreen(),
              transitionDuration: const Duration(milliseconds: 1200),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'Enter',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // ==========================================================================
  // 🏙 Ask user for city name
  // ==========================================================================
  Future<String?> _askCity(BuildContext context) async {
    String city = '';

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter city name'),
        content: TextField(
          onChanged: (value) => city = value,
          decoration: const InputDecoration(hintText: 'eg. Rome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, city),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
