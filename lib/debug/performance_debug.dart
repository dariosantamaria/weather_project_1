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

import 'package:flutter/foundation.dart';

/// ============================================================================
/// 🕒 PerformanceDebug
///
/// EN:
/// Lightweight performance profiler for debugging async operations and code
/// blocks. Each timer is identified by a string key and prints elapsed ms.
///
/// IT:
/// Piccolo profiler per misurare le performance di operazioni asincrone
/// o blocchi di codice. Ogni timer è identificato da una stringa e stampa
/// la durata in millisecondi.
///
/// ============================================================================
class PerformanceDebug {
  static final Map<String, Stopwatch> _timers = {};

  /// ==========================================================================
  /// ▶️ start(name)
  ///
  /// EN:
  /// Begins a stopwatch with the specified name. If the name already exists,
  /// it is overwritten.
  ///
  /// IT:
  /// Avvia un timer con il nome specificato. Se il nome esiste già,
  /// viene sovrascritto.
  ///
  /// ==========================================================================
  static void start(String name) {
    final sw = Stopwatch()..start();
    _timers[name] = sw;
    debugPrint("⏱️ START [$name]");
  }

  /// ==========================================================================
  /// ⏹ end(name)
  ///
  /// EN:
  /// Stops the timer and prints the elapsed milliseconds. If the timer does
  /// not exist, prints a warning.
  ///
  /// IT:
  /// Ferma il timer e stampa i millisecondi trascorsi. Se il timer non esiste,
  /// stampa un avviso.
  ///
  /// ==========================================================================
  static void end(String name) {
    if (_timers.containsKey(name)) {
      final sw = _timers[name]!;
      sw.stop();
      debugPrint("⏱️ END   [$name] → ${sw.elapsedMilliseconds} ms");
      _timers.remove(name);
    } else {
      debugPrint("⚠️ Tried to stop unknown timer: $name");
    }
  }
}
