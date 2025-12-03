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

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
/// ============================================================================
/// 🌍 AnimatedPlanet
///
/// EN:
/// This widget displays an animated rotating planet using a sprite sheet.
/// The animation includes:
/// - frame-based sprite rotation
/// - smooth vertical floating (up/down)
///
/// IT:
/// Questo widget mostra un pianeta animato tramite sprite sheet.
/// L’animazione include:
/// - rotazione a frame della sprite
/// - movimento verticale morbido (su/giù)
/// ============================================================================
class AnimatedPlanet extends StatefulWidget {
  final ui.Image sprite;
  final int totalFrames;
  final double size;
  final Duration rotationDuration;
  final Duration floatDuration;
  final double floatRange;
  /// --------------------------------------------------------------------------
  /// EN:
  /// [sprite] is the decoded PNG sprite sheet.
  /// [totalFrames] determines how many frames the sprite contains.
  /// [size] is the visible output size of the planet.
  ///
  /// IT:
  /// [sprite] è lo sprite sheet PNG decodificato.
  /// [totalFrames] indica il numero di frame contenuti nella sprite.
  /// [size] è la dimensione visiva del pianeta renderizzato.
  /// --------------------------------------------------------------------------
  const AnimatedPlanet({
    super.key,
    required this.sprite,
    required this.totalFrames,
    required this.size,
    this.rotationDuration = const Duration(seconds: 3),
    this.floatDuration = const Duration(seconds: 4),
    this.floatRange = 40,
  });
  @override
  State<AnimatedPlanet> createState() => _AnimatedPlanetState();
}
class _AnimatedPlanetState extends State<AnimatedPlanet>
    with TickerProviderStateMixin {
  // --------------------------------------------------------------------------
  // EN: Controls the sprite frame rotation (0 → totalFrames).
  // IT: Controlla la rotazione dei frame della sprite (0 → totalFrames).
  // --------------------------------------------------------------------------
  late final AnimationController _rotationController;
  // --------------------------------------------------------------------------
  // EN: Controls the vertical floating animation.
  // IT: Controlla l’animazione del movimento verticale.
  // --------------------------------------------------------------------------
  late final AnimationController _floatController;
  // --------------------------------------------------------------------------
  // EN: Evaluates the floating offset value between -floatRange ↔ +floatRange.
  // IT: Determina l’offset verticale tra -floatRange ↔ +floatRange.
  // --------------------------------------------------------------------------
  late final Animation<double> _floatAnim;
  @override
  void initState() {
    super.initState();
    // ------------------------------------------------------------------------
    // EN: Creates a looping rotation animation for sprite frames.
    // IT: Crea un’animazione ciclica di rotazione per i frame della sprite.
    // ------------------------------------------------------------------------
    _rotationController =
        AnimationController(vsync: this, duration: widget.rotationDuration)
          ..repeat();
    // ------------------------------------------------------------------------
    // EN: Creates a smooth up/down floating animation.
    // IT: Crea una animazione di movimento su/giù morbido.
    // ------------------------------------------------------------------------
    _floatController =
        AnimationController(vsync: this, duration: widget.floatDuration)
          ..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -widget.floatRange,
      end: widget.floatRange,
    ).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.linear),
    );
  }
  /// ==========================================================================
  /// 🔄 _frameIndex()
  ///
  /// EN:
  /// Computes the current sprite frame index based on rotationController value.
  /// Ensures looping using modulo arithmetic.
  ///
  /// IT:
  /// Calcola il frame corrente della sprite in base al valore del controller.
  /// Garantisce la rotazione continua tramite modulo.
  /// ==========================================================================
  int _frameIndex() {
    return (_rotationController.value * widget.totalFrames).floor() %
        widget.totalFrames;
  }
  @override
  void dispose() {
    // ------------------------------------------------------------------------
    // EN: Clean up both animation controllers to prevent memory leaks.
    // IT: Rilascia i controller per evitare memory leaks.
    // ------------------------------------------------------------------------
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }
  /// ==========================================================================
  /// 🖼️ build()
  ///
  /// EN:
  /// Builds the planet animation by combining rotation + floating movement.
  /// The planet is drawn via a CustomPainter using the correct frame.
  ///
  /// IT:
  /// Costruisce l’animazione combinando rotazione + movimento verticale.
  /// Il pianeta viene disegnato tramite un CustomPainter usando il frame corretto.
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _floatController]),
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PlanetPainter(
              sprite: widget.sprite,
              frameIndex: _frameIndex(),
              totalFrames: widget.totalFrames,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
/// ============================================================================
/// 🎨 _PlanetPainter
///
/// EN:
/// Custom painter responsible for drawing the correct frame of the sprite.
///
/// IT:
/// CustomPainter incaricato di disegnare il frame corretto della sprite.
/// ============================================================================
class _PlanetPainter extends CustomPainter {
  final ui.Image sprite;
  final int frameIndex;
  final int totalFrames;
  final double size;
  _PlanetPainter({
    required this.sprite,
    required this.frameIndex,
    required this.totalFrames,
    required this.size,
  });
  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()..isAntiAlias = true;
    // ------------------------------------------------------------------------
    // EN: Width of each sprite frame (sprite sheet = horizontal strip).
    // IT: Larghezza di ogni frame della sprite (sprite sheet = strip orizzontale).
    // ------------------------------------------------------------------------
    final frameWidth = sprite.width / totalFrames;
    // ------------------------------------------------------------------------
    // EN: Source rect selects the current frame from the sprite sheet.
    // IT: Il rect sorgente seleziona il frame corrente dalla sprite sheet.
    // ------------------------------------------------------------------------
    final src = Rect.fromLTWH(
      frameIndex * frameWidth,
      0,
      frameWidth,
      sprite.height.toDouble(),
    );
    // ------------------------------------------------------------------------
    // EN: Destination rect where the selected frame will be drawn.
    // IT: Rect di destinazione dove il frame verrà disegnato.
    // ------------------------------------------------------------------------
    final dst = Rect.fromLTWH(0, 0, size, size);
    canvas.drawImageRect(sprite, src, dst, paint);
  }
  @override
  bool shouldRepaint(covariant _PlanetPainter old) =>
      old.frameIndex != frameIndex || old.sprite != sprite;
}
