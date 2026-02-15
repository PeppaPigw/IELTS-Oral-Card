import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class GlowBackground extends StatelessWidget {
  const GlowBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [
                        AppPalette.darkBackground,
                        AppPalette.darkBackgroundAccent
                      ]
                    : const [
                        AppPalette.lightBackground,
                        AppPalette.lightBackgroundAccent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -90,
          child: _GlowOrb(
            color: (isDark ? AppPalette.darkPrimary : AppPalette.lightPrimary)
                .withOpacity(0.35),
            size: 280,
          ),
        ),
        Positioned(
          bottom: -110,
          left: -70,
          child: _GlowOrb(
            color:
                (isDark ? AppPalette.darkSecondary : AppPalette.lightSecondary)
                    .withOpacity(0.25),
            size: 240,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: const SizedBox.shrink(),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.03)],
        ),
      ),
    );
  }
}
