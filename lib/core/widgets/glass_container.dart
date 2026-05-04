import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';

/// A premium glassmorphism container.
///
/// Works by clipping its region, applying a Gaussian blur on everything behind
/// it (BackdropFilter), then overlaying a translucent tinted surface + border.
///
/// IMPORTANT: For the blur to be visible the widget must sit above something
/// colourful (e.g. MeshBackground). A plain dark/white scaffold will make the
/// blur indistinguishable.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 18.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.margin,
    this.tintColor,
    this.tintOpacity = 0.14,
    this.borderColor,
    this.borderWidth = 1.5,
    this.width,
    this.constraints,
    this.shadow = true,
  });

  final Widget child;

  /// Blur sigma applied to whatever is behind this widget.
  final double blur;

  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// Base tint colour. Defaults to white (dark) / primary (light).
  final Color? tintColor;

  /// Alpha [0–1] of the tint overlay.  Keep this low (0.08–0.20).
  final double tintOpacity;

  /// Border colour. Defaults to white @20% (dark) / primary @25% (light).
  final Color? borderColor;
  final double borderWidth;

  final double? width;
  final BoxConstraints? constraints;

  /// Whether to render a soft drop-shadow beneath the card.
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final effectiveTint =
        (tintColor ??
                (isDark
                    ? Theme.of(context).colorScheme.fixedWhite
                    : cs.primary))
            .withValues(alpha: tintOpacity);

    final effectiveBorder =
        borderColor ??
        (isDark
            ? Theme.of(context).colorScheme.fixedWhite.withValues(alpha: 0.28)
            : cs.primary.withValues(alpha: 0.30));

    return Container(
      margin: margin,
      width: width,
      constraints: constraints,
      decoration: shadow
          ? BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.fixedBlack.withValues(
                    alpha: isDark ? 0.28 : 0.10,
                  ),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
              ],
            )
          : null,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: effectiveBorder, width: borderWidth),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              color: effectiveTint,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
