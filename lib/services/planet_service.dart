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
import 'package:flutter/foundation.dart';

import 'auth_service.dart';
import '../debug/performance_debug.dart';

/// ============================================================================
/// 🌍 PlanetService
///
/// EN:
/// High-level service that coordinates the entire secure download flow of the
/// planet animation (WebP sprite). It manages:
/// - Nonce retrieval
/// - HMAC signature generation
/// - Authenticated request to fetch the protected WebP
/// - Performance profiling for each phase
///
/// IT:
/// Servizio di alto livello che coordina l’intero flusso di download sicuro
/// dello sprite del pianeta (WebP). Gestisce:
/// - Recupero del nonce
/// - Generazione firma HMAC
/// - Richiesta autenticata al backend per ottenere il WebP
/// - Profilazione delle performance per ogni fase
/// ============================================================================
class PlanetService {
  // Singleton dell’AuthService.
  static final AuthService _auth = AuthService();

  /// ==========================================================================
  /// fetchPlanetSprite()
  ///
  /// EN:
  /// Main method used to securely obtain the WebP sprite from the backend.
  /// This method:
  ///  1) Requests a fresh nonce
  ///  2) Generates a valid signature
  ///  3) Downloads the WebP over an authenticated channel
  ///  4) Measures performance of the entire chain
  ///
  /// IT:
  /// Metodo principale per ottenere in sicurezza lo sprite WebP dal backend.
  /// Questo metodo:
  ///  1) Richiede un nuovo nonce
  ///  2) Genera la firma valida
  ///  3) Scarica il WebP tramite canale autenticato
  ///  4) Misura le performance dell’intera catena
  /// ==========================================================================
  static Future<Uint8List> fetchPlanetSprite({int frames = 16}) async {
    if (frames != 16 && frames != 32) {
      throw Exception("Frames deve essere 16 o 32");
    }

    PerformanceDebug.start("planet_process");

    try {
      debugPrint("🔵 [PlanetService] Requesting NONCE…");

      // 1️⃣ RICHIESTA NONCE
      final nonceData = await _auth.fetchNonce();
      final nonce = nonceData["nonce"];
      final timestamp = nonceData["timestamp"];

      debugPrint("🔵 Nonce: $nonce");
      debugPrint("🔵 Timestamp: $timestamp");

      // 2️⃣ GENERA FIRMA SICURA
      final signature = _auth.generateSignature(
        nonce: nonce,
        timestamp: timestamp,
      );

      debugPrint("🔵 Signature: $signature");
      debugPrint("🌍 Fetching WebP ($frames frames)…");

      // 3️⃣ DOWNLOAD WebP SICURO
      PerformanceDebug.start("planet_download");

      final webpBytes = await _auth.fetchPlanetWithHeaders(
        nonce: nonce,
        timestamp: timestamp,
        signature: signature,
        frames: frames,
      );

      PerformanceDebug.end("planet_download");

      debugPrint("🎉 Pianeta WebP caricato ($frames frames)!");
      PerformanceDebug.end("planet_process");

      return webpBytes;

    } catch (e) {
      PerformanceDebug.end("planet_process");
      debugPrint("❌ Errore fetch pianeta (WebP): $e");
      rethrow;
    }
  }
}
