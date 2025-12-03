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

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../services/planet_service.dart';
import 'home_screen.dart';

/// ============================================================================
/// 🚀 IntroScreen
///
/// EN:
/// Startup screen of the Cosmic Weather app. It performs the first-time loading
/// of the WebP planet sprite, decodes it into a Flutter ui.Image, shows a
/// loading animation, and then transitions to the AuroraHomeScreen.
///
/// IT:
/// Schermata iniziale dell’app Cosmic Weather. Effettua il primo caricamento
/// dello sprite WebP del pianeta, lo decodifica in un ui.Image, mostra
/// un’animazione di caricamento e poi passa all’AuroraHomeScreen.
/// ============================================================================
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  /// Stato interno: caricamento in corso.
  bool _loading = true;

  /// Immagine decodificata del pianeta.
  ui.Image? _planetImage;

  /// Eventuale errore durante il caricamento.
  String? _planetError;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  /// ==========================================================================
  /// _safeDelay()
  ///
  /// EN:
  /// Small artificial delay used to smooth out the transition animation.
  ///
  /// IT:
  /// Piccolo ritardo artificiale per rendere più fluida la transizione.
  /// ==========================================================================
  Future<void> _safeDelay([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  /// ==========================================================================
  /// _startLoading()
  ///
  /// EN:
  /// Main boot procedure:
  ///  1) Downloads the 32-frame WebP sprite (authenticated)
  ///  2) Decodes the WebP into a Flutter ui.Image
  ///  3) Updates UI state
  ///  4) Navigates to the AuroraHomeScreen
  ///
  /// IT:
  /// Procedura principale di avvio:
  ///  1) Scarica lo sprite WebP a 32 frame (autenticato)
  ///  2) Decodifica il WebP in un ui.Image
  ///  3) Aggiorna lo stato UI
  ///  4) Naviga verso AuroraHomeScreen
  /// ==========================================================================
  Future<void> _startLoading() async {
    try {
      // 1️⃣ Scarica Sprite (NO CACHE)
      final bytes = await PlanetService.fetchPlanetSprite(frames: 32);

      // 2️⃣ Decodifica WebP → ui.Image
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _planetImage = frame.image;

      await _safeDelay();

      if (mounted) {
        setState(() => _loading = false);
      }

    } catch (e) {
      _planetError = e.toString();
      debugPrint("⚠️ Errore caricamento WebP: $e");
    }

    if (!mounted) return;

    // 3️⃣ Transizione verso la Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AuroraHomeScreen(
          preloadedPlanet: _planetImage,
          preloadError: _planetError,
        ),
      ),
    );
  }

  /// ==========================================================================
  /// build()
  ///
  /// EN:
  /// Displays loading UI, animated messages, and app branding.
  ///
  /// IT:
  /// Mostra la UI di caricamento, messaggi animati e branding dell'app.
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            const Text(
              "✨ Cosmic Weather ✨",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const CircularProgressIndicator(color: Colors.cyanAccent),

            const SizedBox(height: 40),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _loading
                    ? "Demo sviluppata da Dario Santamaria..."
                    : "Caricamento completato!",
                key: ValueKey<bool>(_loading),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
