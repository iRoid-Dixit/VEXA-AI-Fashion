import 'package:flutter/material.dart';

/// VEXA design tokens — mirrors the approved HTML prototype 1:1.
abstract class VexaColors {
  static const ink = Color(0xFF0B0B0F);
  static const ink2 = Color(0xFF16151B);
  static const paper = Color(0xFFF8F8F8);
  static const card = Colors.white;

  static const iris = Color(0xFF8A5CFF);
  static const irisDeep = Color(0xFF6E41E2);
  static const irisSoft = Color(0xFFF1EBFF);
  static const irisGhost = Color(0xFFF7F4FF);

  static const text = Color(0xFF131217);
  static const muted = Color(0xFF726E7C);
  static const faint = Color(0xFFA9A5B3);
  static const line = Color(0xFFECEAF1);
  static const line2 = Color(0xFFE2DFE9);

  static const good = Color(0xFF34C759);
  static const goodSoft = Color(0xFFE9F9EE);
  static const warn = Color(0xFFFF9500);
  static const warnSoft = Color(0xFFFFF3E0);
  static const bad = Color(0xFFFF3B30);
  static const badSoft = Color(0xFFFFECEA);

  static const irisGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9B72FF), Color(0xFF7747F2)],
  );
}

abstract class VexaText {
  static const sans = 'PlusJakartaSans';
  static const serif = 'PlayfairDisplay';

  /// Pin the variable-font weight axis so every weight renders exactly
  /// as designed on all platforms.
  static List<FontVariation> _wght(double w) => [FontVariation('wght', w)];

  /// Editorial serif accent — used sparingly (hero words, taglines).
  static TextStyle serifAccent({
    double size = 32,
    Color color = VexaColors.text,
  }) => TextStyle(
    fontFamily: serif,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontVariations: _wght(500),
    fontSize: size,
    color: color,
    height: 1.08,
  );

  static TextStyle display({double size = 32, Color color = VexaColors.text}) =>
      TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w800,
        fontVariations: _wght(800),
        fontSize: size,
        letterSpacing: size * -0.038,
        height: 1.06,
        color: color,
      );

  static TextStyle eyebrow({Color color = VexaColors.faint}) => TextStyle(
    fontFamily: sans,
    fontWeight: FontWeight.w700,
    fontVariations: _wght(700),
    fontSize: 10.5,
    letterSpacing: 2.2,
    color: color,
  );

  static TextStyle body({double size = 14, Color color = VexaColors.muted}) =>
      TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w500,
        fontVariations: _wght(480),
        fontSize: size,
        height: 1.6,
        color: color,
      );

  static TextStyle title({double size = 16.5, Color color = VexaColors.text}) =>
      TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w800,
        fontVariations: _wght(760),
        fontSize: size,
        letterSpacing: -0.35,
        color: color,
      );

  static TextStyle label({double size = 12.5, Color color = VexaColors.text}) =>
      TextStyle(
        fontFamily: sans,
        fontWeight: FontWeight.w700,
        fontVariations: _wght(680),
        fontSize: size,
        letterSpacing: -0.1,
        color: color,
      );

  /// Shared button label treatment — one size, one weight, everywhere.
  static TextStyle button({Color color = Colors.white}) => TextStyle(
    fontFamily: sans,
    fontWeight: FontWeight.w700,
    fontVariations: _wght(700),
    fontSize: 15,
    letterSpacing: -0.2,
    color: color,
  );
}

abstract class VexaShadows {
  static const card = [
    BoxShadow(color: Color(0x0A131217), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x12131217), blurRadius: 28, offset: Offset(0, 10)),
  ];
  static const pop = [
    BoxShadow(color: Color(0x14131217), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x2E131217), blurRadius: 48, offset: Offset(0, 24)),
  ];
}

ThemeData vexaTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: VexaText.sans,
    scaffoldBackgroundColor: VexaColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: VexaColors.iris,
      primary: VexaColors.ink,
      secondary: VexaColors.iris,
      surface: VexaColors.paper,
    ),
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    // Soft right-to-left slide pushes on every platform — feels hand-tuned,
    // not the default Material zoom.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: base.textTheme.apply(
      bodyColor: VexaColors.text,
      displayColor: VexaColors.text,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: VexaColors.ink2.withValues(alpha: .94),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      contentTextStyle: const TextStyle(
        fontFamily: VexaText.sans,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Colors.white,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: VexaColors.line,
      thickness: 1,
      space: 1,
    ),
  );
}
