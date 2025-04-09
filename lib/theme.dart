import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5e2b19), // chocolat
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdbc4a1), // beige foncé
      onPrimaryContainer: Color(0xff3b1a0e),
      secondary: Color(0xff3b6e3a), // vert feuille
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa2c39d), // vert doux
      onSecondaryContainer: Color(0xff1f3e1e),
      tertiary: Color(0xff8b5e3c), // café moyen
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffff4e0), // mousse de lait
      onTertiaryContainer: Color(0xff3f2b1d),
      error: Color(0xffb00020),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfffcd8df),
      onErrorContainer: Color(0xff680014),
      surface: Color(0xfff5e8d0), // crème fond
      onSurface: Color(0xff3b1a0e),
      onSurfaceVariant: Color(0xff5e2b19),
      outline: Color(0xff8b5e3c),
      outlineVariant: Color(0xffdbc4a1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3b1a0e),
      inversePrimary: Color(0xffdbc4a1),
      surfaceTint: Color(0xff5e2b19),
      primaryFixed: Color(0xffdbc4a1),
      onPrimaryFixed: Color(0xff3b1a0e),
      primaryFixedDim: Color(0xff8b5e3c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffa2c39d),
      onSecondaryFixed: Color(0xff1f3e1e),
      secondaryFixedDim: Color(0xff3b6e3a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xfffff4e0),
      onTertiaryFixed: Color(0xff3f2b1d),
      tertiaryFixedDim: Color(0xff8b5e3c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe2d3b8),
      surfaceBright: Color(0xfffff8ec),
      surfaceContainerLowest: Color(0xfffffbf4),
      surfaceContainerLow: Color(0xfff9eedf),
      surfaceContainer: Color(0xfff3e2ca),
      surfaceContainerHigh: Color(0xffecd8b8),
      surfaceContainerHighest: Color(0xffe5ceab),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdbc4a1), // beige café au lait
      onPrimary: Color(0xff3b1a0e), // brun foncé
      primaryContainer: Color(0xff5e2b19), // chocolat profond
      onPrimaryContainer: Color(0xfffff4e0), // mousse de lait
      secondary: Color(0xffa2c39d), // vert doux
      onSecondary: Color(0xff1f3e1e), // vert feuille foncé
      secondaryContainer: Color(0xff3b6e3a),
      onSecondaryContainer: Color(0xffeaf7e4),
      tertiary: Color(0xfffff4e0), // lait mousseux
      onTertiary: Color(0xff3f2b1d),
      tertiaryContainer: Color(0xff8b5e3c),
      onTertiaryContainer: Color(0xfffff4e0),
      error: Color(0xfff2b8b5),
      onError: Color(0xff5c0002),
      errorContainer: Color(0xff8c1d18),
      onErrorContainer: Color(0xffffeaea),
      surface: Color(0xff2a2018), // fond brun moka
      onSurface: Color(0xfff5e8d0), // crème doux
      onSurfaceVariant: Color(0xffdbc4a1),
      outline: Color(0xff8b5e3c),
      outlineVariant: Color(0xff5e2b19),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff5e8d0),
      inversePrimary: Color(0xff5e2b19),
      surfaceTint: Color(0xffdbc4a1),
      primaryFixed: Color(0xffdbc4a1),
      onPrimaryFixed: Color(0xff3b1a0e),
      primaryFixedDim: Color(0xff8b5e3c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffa2c39d),
      onSecondaryFixed: Color(0xff1f3e1e),
      secondaryFixedDim: Color(0xff3b6e3a),
      onSecondaryFixedVariant: Color(0xffeaf7e4),
      tertiaryFixed: Color(0xfffff4e0),
      onTertiaryFixed: Color(0xff3f2b1d),
      tertiaryFixedDim: Color(0xff8b5e3c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xff1e160f),
      surfaceBright: Color(0xff3a2f26),
      surfaceContainerLowest: Color(0xff14100b),
      surfaceContainerLow: Color(0xff1d1812),
      surfaceContainer: Color(0xff251e17),
      surfaceContainerHigh: Color(0xff2e251d),
      surfaceContainerHighest: Color(0xff372d24),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
