import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';

/// Renders soft, blurred ambient orbs behind the page content.
/// Glass cards placed above this widget will blur these colours,
/// creating the authentic frosted-glass effect.
class MeshBackground extends StatelessWidget {
  const MeshBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Base scaffold background ──────────────────────────────────────
          ColoredBox(color: cs.surface),

          // ── Orb 1 — primary, top-right ───────────────────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: _Orb(
              size: 380,
              color: cs.primary.withValues(alpha: cs.meshPrimaryOrbAlpha),
              blur: 80,
            ),
          ),

          // ── Orb 2 — primary, bottom-left ─────────────────────────────────
          Positioned(
            bottom: -80,
            left: -60,
            child: _Orb(
              size: 300,
              color: cs.primary.withValues(
                alpha: cs.meshPrimaryOrbSecondaryAlpha,
              ),
              blur: 70,
            ),
          ),

          // ── Orb 3 — secondary accent, centre ─────────────────────────────
          Positioned(
            top: size.height * 0.35,
            left: size.width * 0.1,
            child: _Orb(
              size: 240,
              color: cs.secondary.withValues(alpha: cs.meshSecondaryOrbAlpha),
              blur: 60,
            ),
          ),

          // ── Scrim: darkens/lightens to keep content readable ─────────────
          // Plain ColoredBox — NOT a BackdropFilter to avoid artefacts
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(
                context,
              ).scaffoldBackgroundColor.withValues(alpha: cs.meshScrimAlpha),
            ),
          ),

          // ── Page content ──────────────────────────────────────────────────
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color, required this.blur});

  final double size;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    // ImageFiltered renders the blur without needing a compositing layer,
    // which avoids the BackdropFilter artefact that killed the previous version.
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: TileMode.decal,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
