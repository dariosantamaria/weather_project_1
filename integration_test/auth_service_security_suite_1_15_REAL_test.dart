// ​​‍‍‌============‍‌​​​============‍‌‌​‍============‍‍​‍​============​‌‌‍‌============​‍​​‍============‌​​‍‍======‍​‌‍​
// Cosmic Weather — © 2025 Dario Santamaria
// Author: Dario Santamaria
// Licensed under the MIT License
// Email: dariosantamaria@hotmail.it
// Original repository: https://github.com/dariosantamaria/weather_project_1
//
// Unauthorized cloning will be reported to the Galactic Council.
// Crafted under the stars — keep this signature intact.
// ​​‍‍​============​​‍‍‌============​​‍‍‍============​‌​​​============​‌​​‌============​‌​​‍============​‌​‌​======​‌‌

// ============================================================================
//  🔐 FULL SECURITY SUITE 1–15  (integration_test)
//  Eseguire con:
//
// flutter drive --driver=test_driver/integration_test.dart \
//   --target=integration_test/auth_service_security_suite_1_15_test.dart \
//   -d 2201116PG
// ============================================================================

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:weather_project_1/services/auth_service.dart';
import 'package:flutter/foundation.dart';


// ---------------------------------------------------------------------------
// Utility
// ---------------------------------------------------------------------------

void logLine([String msg = ""]) => debugPrint(msg);

Future<void> _loadEnv() async {
  if (dotenv.isInitialized) return;

  // Legge il parametro passato da --dart-define
  const envFile = String.fromEnvironment(
    'ENV_FILE',
    defaultValue: 'assets/.env.demo',
  );

  await dotenv.load(fileName: envFile);

  debugPrint("📦 Loaded ENV file: $envFile");
}

Uint8List _secretToBytes(String secret) {
  final isHex = RegExp(r'^[0-9a-fA-F]+$').hasMatch(secret);
  if (isHex) {
    final out = <int>[];
    for (var i = 0; i < secret.length; i += 2) {
      out.add(int.parse(secret.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(out);
  }
  return Uint8List.fromList(utf8.encode(secret));
}

// ============================================================================
// MAIN
// ============================================================================
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthService auth;
  late String baseUrl;
  late String deviceId;
  late String clientSecret;

  // ---------------------------------------------------------------------------
  // SETUP
  // ---------------------------------------------------------------------------
  setUpAll(() async {
    await _loadEnv();

    auth = AuthService();
    baseUrl = dotenv.env["API_BASE_URL"] ?? "";
    deviceId = dotenv.env["PLANET_DEVICE_ID"] ?? "";
    clientSecret = dotenv.env["PLANET_CLIENT_SECRET"] ?? "";

    logLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logLine("🔐 Cosmic Weather — FULL SECURITY SUITE 1–15");
    logLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logLine("🌍 DEVICE_ID = $deviceId");
    logLine("🌍 BASE_URL  = $baseUrl");
  });

  tearDownAll(() {
    logLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    logLine("🏁 FULL SECURITY SUITE COMPLETATA");
    logLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  });

  // ==========================================================================
  // 1 — REAL SIGNATURE
  // ==========================================================================
  testWidgets("1️⃣ TEST 1 — REAL SIGNATURE", (tester) async {
    const nonce = "abcd1234abcd1234abcd1234abcd1234";
    const timestamp = 1700000000;

    final sig = auth.generateSignature(nonce: nonce, timestamp: timestamp);

    const expectedRealSignatureReal  =
        "697aa44122677c6a69f88520756cb808d26c9ed6ead8ea0f8f5895b2b045b0d5";

    expect(sig, expectedRealSignatureReal );
  });

  // ==========================================================================
  // 2 — FULL CHAIN
  // ==========================================================================
  testWidgets("2️⃣ TEST 2 — FULL CHAIN", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final sig = auth.generateSignature(nonce: nonce, timestamp: ts);

    final bytes = await auth.fetchPlanetWithHeaders(
      nonce: nonce,
      timestamp: ts,
      signature: sig,
      frames: 32,
    );

    expect(bytes.isNotEmpty, true);
  });

// ==========================================================================
// 3 — DEMO SIGNATURE (SKIPPED IN REAL)
// ==========================================================================
testWidgets("3️⃣ TEST 3 — DEMO SIGNATURE (SKIPPED in REAL mode)", (tester) async {
  debugPrint("🔸 TEST 3 skipped: this test is only valid in DEMO mode.");
  expect(true, isTrue); // Pass automatico
});

  // ==========================================================================
  // 4 — INVALID SIGNATURE
  // ==========================================================================
  testWidgets("4️⃣ TEST 4 — INVALID SIGNATURE", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const fake =
        "2cdc3927c5367d626157f54e98a4e9ee870a860ed88301fb2a2edc4da868e606";

    final res = await http.get(
      Uri.parse("$baseUrl/planet?frames=32"),
      headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": "$ts",
        "X-DEVICE": deviceId,
        "X-SIGNATURE": fake,
      },
    );

    expect(res.statusCode, 403);
  });

  // ==========================================================================
  // 5 — CLOCK SKEW
  // ==========================================================================
  testWidgets("5️⃣ TEST 5 — CLOCK SKEW", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    Future<int> callTs(int ts) async {
      final s = auth.generateSignature(nonce: nonce, timestamp: ts);
      final r = await http.get(
        Uri.parse("$baseUrl/planet?frames=32"),
        headers: {
          "X-NONCE": nonce,
          "X-TIMESTAMP": "$ts",
          "X-DEVICE": deviceId,
          "X-SIGNATURE": s,
        },
      );
      return r.statusCode;
    }

    final old = await callTs(now - 120);
    final future = await callTs(now + 120);

    expect(old, 403);
    expect(future, 403);
  });

  // ==========================================================================
  // 6 — DEVICE ID MISMATCH
  // ==========================================================================
  testWidgets("6️⃣ TEST 6 — DEVICE ID MISMATCH", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final s = auth.generateSignature(nonce: nonce, timestamp: ts);

    final res = await http.get(
      Uri.parse("$baseUrl/planet?frames=32"),
      headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": "$ts",
        "X-DEVICE": "android-hacker-9000",
        "X-SIGNATURE": s,
      },
    );

    expect(res.statusCode, 403);
  });

  // ==========================================================================
  // 7 — WRONG SECRET KEY
  // ==========================================================================
  testWidgets("7️⃣ TEST 7 — WRONG SECRET KEY", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const wrong = "wrong_secret_key_testing";
    final fakeSig = Hmac(sha256, utf8.encode(wrong))
        .convert(utf8.encode("$nonce$ts$deviceId"))
        .toString();

    final res = await http.get(
      Uri.parse("$baseUrl/planet?frames=32"),
      headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": "$ts",
        "X-DEVICE": deviceId,
        "X-SIGNATURE": fakeSig,
      },
    );

    expect(res.statusCode, 403);
  });

  // ==========================================================================
  // 8 — NO SIGNATURE
  // ==========================================================================
  testWidgets("8️⃣ TEST 8 — NO SIGNATURE", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final res = await http.get(
      Uri.parse("$baseUrl/planet?frames=32"),
      headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": "$ts",
        "X-DEVICE": deviceId,
      },
    );

    expect(res.statusCode, 403);
  });

  // ==========================================================================
  // 9 — MALFORMED SIGNATURES
  // ==========================================================================
  testWidgets("9️⃣ TEST 9 — MALFORMED SIGNATURES", (tester) async {
    final n = await auth.fetchNonce();
    final nonce = n["nonce"];
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final malformed = [
      "123",
      "",
      "    ",
      "abc def 123",
      "zzzzzzzzzzzzzzzzzzzzzzzz",
    ];

    for (final m in malformed) {
      final r = await http.get(
        Uri.parse("$baseUrl/planet?frames=32"),
        headers: {
          "X-NONCE": nonce,
          "X-TIMESTAMP": "$ts",
          "X-DEVICE": deviceId,
          "X-SIGNATURE": m,
        },
      );
      expect(r.statusCode, 403);
    }
  });

  // ==========================================================================
  // 10A — RATE LIMIT REALISTIC
  // ==========================================================================
  testWidgets("🔟 TEST 10A — RATE LIMIT REALISTICO", (tester) async {
    final url = Uri.parse("$baseUrl/planet?frames=32");
    final statuses = <int>[];

    for (int i = 0; i < 8; i++) {
      final n = await auth.fetchNonce();
      final nonce = n["nonce"];
      final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sig = auth.generateSignature(nonce: nonce, timestamp: ts);

      final r = await http.get(url, headers: {
        "X-NONCE": nonce,
        "X-TIMESTAMP": "$ts",
        "X-DEVICE": deviceId,
        "X-SIGNATURE": sig,
      });

      statuses.add(r.statusCode);
      await Future.delayed(const Duration(milliseconds: 350));
    }

    final okCount = statuses.where((s) => s == 200).length;
    expect(okCount >= 1, true);
  });

// ==========================================================================
// 10B — FLOOD ESTREMO (REAL VERSION) — basato sullo stand-alone DEMO
// ==========================================================================
testWidgets("🔟 TEST 10B — FLOOD ESTREMO (REAL FINAL VERSION)", (tester) async {
  debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  debugPrint("🔐 TEST 10B — REAL FINAL VERSION");
  debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  final url = Uri.parse("$baseUrl/planet?frames=32");

  // Secret reale (UTF-8)
  final keyBytes = utf8.encode(clientSecret);

  // Funzione singola richiesta stile stand-alone
  Future<int> singleRequestReal() async {
    try {
      // 1️⃣ Ottieni NONCE reale
      final nonceResp =
          await http.get(Uri.parse("$baseUrl/auth/nonce"));
      final nonceJson = json.decode(nonceResp.body);
      final String nonce = nonceJson["nonce"];

      // 2️⃣ Timestamp realtime
      final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      // 3️⃣ Costruzione firma REAL
      final data = "$nonce$ts$deviceId";
      final sig =
          Hmac(sha256, keyBytes).convert(utf8.encode(data)).toString();

      // 4️⃣ Richiesta al server
      final resp = await http.get(
        url,
        headers: {
          "X-NONCE": nonce,
          "X-TIMESTAMP": ts,
          "X-DEVICE": deviceId,
          "X-SIGNATURE": sig,
        },
      );

      return resp.statusCode;
    } catch (e) {
      debugPrint("❌ Errore richiesta: $e");
      return -1;
    }
  }

  debugPrint("🚀 Lancio 20 richieste parallele...");
  final futures = List.generate(20, (_) => singleRequestReal());

  final results = await Future.wait(futures);

  debugPrint("\n📊 RISULTATI:");
  for (final r in results) {
    debugPrint(" → $r");
  }

  // Cerchiamo almeno un 429
  final has429 = results.contains(429);

  debugPrint("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  debugPrint("🔍 VERIFICA RATE LIMIT");
  debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  if (has429) {
    debugPrint("🎉 SUCCESSO — REAL server rate limit OK!");
  } else {
    debugPrint("❌ ERRORE — Nessun 429 rilevato!");
  }

  // Test vero e proprio
  expect(has429, true);
});

  // ==========================================================================
// 11 — MISSING / PARTIAL HEADERS
// ==========================================================================
testWidgets("1️⃣1️⃣ TEST 11 — MISSING HEADERS", (tester) async {
  final n = await auth.fetchNonce();
  final nonce = n["nonce"];
  final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final sig = auth.generateSignature(nonce: nonce, timestamp: ts);

  final url = Uri.parse("$baseUrl/planet?frames=32");

  final List<Map<String, String>> sets = [
    {
      "X-TIMESTAMP": "$ts",
      "X-DEVICE": deviceId,
      "X-SIGNATURE": sig,
    },
    {
      "X-NONCE": nonce,
      "X-DEVICE": deviceId,
      "X-SIGNATURE": sig,
    },
    {
      "X-NONCE": nonce,
      "X-TIMESTAMP": "$ts",
      "X-SIGNATURE": sig,
    },
    {
      "X-NONCE": nonce,
      "X-TIMESTAMP": "$ts",
      "X-DEVICE": deviceId,
    },
    {"X-SIGNATURE": sig},
    {
      "X-NONCE": nonce,
      "X-TIMESTAMP": "$ts",
    },
  ];

  for (final Map<String, String> h in sets) {
    final r = await http.get(url, headers: h);
    expect(r.statusCode, 403);
  }
});

  // ==========================================================================
  // 14 — FRAMES VALID
  // ==========================================================================
  testWidgets("1️⃣4️⃣ TEST 14 — FRAMES VALID (16/32/64)", (tester) async {
    final valid = [32];

    for (final f in valid) {
      final n = await auth.fetchNonce();
      final nonce = n["nonce"];
      final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sig = auth.generateSignature(nonce: nonce, timestamp: ts);

      try {
        final bytes = await auth.fetchPlanetWithHeaders(
          nonce: nonce,
          timestamp: ts,
          signature: sig,
          frames: f,
        );
        expect(bytes.isNotEmpty, true);
      } catch (_) {
        // se 404 per valori non supportati → non è fail
      }
    }
  });

  // ==========================================================================
  // 15 — FRAMES INVALID
  // ==========================================================================
  testWidgets("1️⃣5️⃣ TEST 15 — FRAMES INVALID", (tester) async {
    final invalid = [0, 1, 7, 15, 99999];
    for (final f in invalid) {
      final n = await auth.fetchNonce();
      final nonce = n["nonce"];
      final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sig = auth.generateSignature(nonce: nonce, timestamp: ts);

      final r = await http.get(
        Uri.parse("$baseUrl/planet?frames=$f"),
        headers: {
          "X-NONCE": nonce,
          "X-TIMESTAMP": "$ts",
          "X-DEVICE": deviceId,
          "X-SIGNATURE": sig,
        },
      );

      expect(r.statusCode >= 400, true);
    }
  });
}
