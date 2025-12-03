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

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// ============================================================================
/// 🔐 SignatureDebugger
///
/// EN:
/// This utility class provides a full, detailed breakdown of how an HMAC
/// SHA-256 signature is generated.
/// It prints each internal step:
/// - Input fields (nonce, timestamp, deviceId)
/// - String concatenation
/// - Byte encoding
/// - HMAC computation
/// - Hexadecimal final digest
///
/// IT:
/// Questa classe fornisce un debug completo e dettagliato della generazione
/// della firma HMAC SHA-256.
/// Stampa ogni fase interna:
/// - Campi di input (nonce, timestamp, deviceId)
/// - Stringa concatenata
/// - Codifica in byte
/// - Computazione HMAC
/// - Digest finale esadecimale
/// ============================================================================
class SignatureDebugger {
  // ===========================================================================
  // 🧪 debugSignature()
  // ===========================================================================
  /// EN:
  /// Runs a full printable debug of the signature generation.
  /// This is helpful during development or backend integration debugging.
  ///
  /// IT:
  /// Esegue un debug stampato completo della generazione della firma.
  /// Utile durante lo sviluppo o per debug d’integrazione con il backend.
  static void debugSignature({
    required String nonce,
    required String timestamp,
    required String deviceId,
    required String clientSecret,
  }) {
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("🔍 SIGNATURE DEBUGGER START");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // ------------------------------------------------------------------------
    // 1️⃣ Build the string to sign
    // ------------------------------------------------------------------------
    final toSign = "$nonce$timestamp$deviceId";

    debugPrint("📌 STRING TO SIGN:");
    debugPrint("   \"$toSign\"");
    debugPrint("📏 Length: ${toSign.length}");
    debugPrint("🔡 NONCE:      $nonce");
    debugPrint("🔡 TIMESTAMP:  $timestamp");
    debugPrint("🔡 DEVICE ID:  $deviceId");

    // ------------------------------------------------------------------------
    // 2️⃣ Convert strings to bytes
    // ------------------------------------------------------------------------
    final keyBytes = utf8.encode(clientSecret);
    final dataBytes = utf8.encode(toSign);

    debugPrint("\n📦 keyBytes length:  ${keyBytes.length}");
    debugPrint("📦 dataBytes length: ${dataBytes.length}");

    // ------------------------------------------------------------------------
    // 3️⃣ Compute HMAC SHA-256
    // ------------------------------------------------------------------------
    final hmacSha256 = Hmac(sha256, keyBytes);
    final digest = hmacSha256.convert(dataBytes);

    // ------------------------------------------------------------------------
    // 4️⃣ Final output
    // ------------------------------------------------------------------------
    final signature = digest.toString();

    debugPrint("\n🔐 SIGNATURE GENERATED:");
    debugPrint("   $signature");
    debugPrint("📏 Signature length: ${signature.length}");

    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("🔍 SIGNATURE DEBUGGER END");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }
}
