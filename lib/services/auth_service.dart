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
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'debug_signature.dart';

/// ============================================================================
/// 🔐 AuthService — HMAC-secured authentication
/// ============================================================================
class AuthService {
  /// URL backend
  final String baseUrl = dotenv.env["API_BASE_URL"] ?? "";

  /// Device ID
  final String deviceId = dotenv.env["PLANET_DEVICE_ID"] ?? "";

  /// Secret (potrebbe essere HEX oppure stringa normale!)
  final String clientSecret = dotenv.env["PLANET_CLIENT_SECRET"] ?? "";

  // --------------------------------------------------------------------------
  // 🔵 Richiede nonce
  // --------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchNonce() async {
    final url = Uri.parse("$baseUrl/auth/nonce");

    debugPrint("🔵 [AuthService] Requesting NONCE → $url");

    final res = await http.get(url).timeout(const Duration(seconds: 5));
    if (res.statusCode != 200) {
      throw Exception("Errore NONCE: ${res.statusCode}");
    }

    return jsonDecode(res.body);
  }

  // --------------------------------------------------------------------------
  // 🔧 Converte segreto → bytes (HEX oppure UTF8)
  // --------------------------------------------------------------------------
  Uint8List _secretToBytes(String secret) {
    final isHex = RegExp(r'^[0-9a-fA-F]+$').hasMatch(secret);

    if (isHex) {
      // HEX → BYTES
      final out = <int>[];
      for (int i = 0; i < secret.length; i += 2) {
        out.add(int.parse(secret.substring(i, i + 2), radix: 16));
      }
      return Uint8List.fromList(out);
    }

    // STRINGA STANDARD → UTF8
    return Uint8List.fromList(utf8.encode(secret));
  }

  // --------------------------------------------------------------------------
  // 🔐 Genera firma HMAC-SHA256
  // --------------------------------------------------------------------------
  String generateSignature({
    required String nonce,
    required int timestamp,
  }) {
    final toSign = "$nonce$timestamp$deviceId";

    // <── QUI LA FIX: usa nuovo convertitore
    final keyBytes = _secretToBytes(clientSecret);
    final dataBytes = utf8.encode(toSign);

    final hmacSha256 = Hmac(sha256, keyBytes);
    final signature = hmacSha256.convert(dataBytes).toString();

    // Debug opzionale
    SignatureDebugger.debugSignature(
      nonce: nonce,
      timestamp: timestamp.toString(),
      deviceId: deviceId,
      clientSecret: clientSecret,
    );

    debugPrint("🔐 [AuthService] Signature generated = $signature");

    return signature;
  }

  // --------------------------------------------------------------------------
  // 🌍 Scarica WebP protetto
  // --------------------------------------------------------------------------
  Future<Uint8List> fetchPlanetWithHeaders({
    required String nonce,
    required int timestamp,
    required String signature,
    int frames = 32,
  }) async {
    final url = Uri.parse("$baseUrl/planet?frames=$frames");

    debugPrint("🌍 Requesting WebP → $url");

    final response = await http.get(
      url,
      headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": timestamp.toString(),
        "X-DEVICE": deviceId,
        "X-SIGNATURE": signature,
      },
    );

    debugPrint("HTTP STATUS = ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception("Errore fetch WebP: ${response.statusCode}");
    }

    return response.bodyBytes;
  }
}
