import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class CustomTheme extends ThemeExtension<CustomTheme> {
  const CustomTheme({
    this.primaryColor = const Color(0xFF6750A4),
    this.tertiaryColor = const Color(0xFF625B71),
    this.neutralColor = const Color(0xFF939094),
  });

  final Color primaryColor;
  final Color tertiaryColor;
  final Color neutralColor;

  ColorScheme _scheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final base = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    );
    final surface = _mix(
      neutralColor,
      isLight ? Colors.white : Colors.black,
      isLight ? 0.90 : 0.72,
    );
    final surfaceContainerHighest = _mix(
      neutralColor,
      isLight ? Colors.white : Colors.black,
      isLight ? 0.78 : 0.42,
    );
    final tertiaryContainer = _mix(
      tertiaryColor,
      isLight ? Colors.white : Colors.black,
      isLight ? 0.78 : 0.40,
    );

    return base.copyWith(
      tertiary: tertiaryColor,
      onTertiary: _foregroundFor(tertiaryColor),
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: _foregroundFor(tertiaryContainer),
      surface: surface,
      onSurface: _foregroundFor(surface),
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: _foregroundFor(surfaceContainerHighest),
      outline: _mix(
        surfaceContainerHighest,
        _foregroundFor(surfaceContainerHighest),
        isLight ? 0.45 : 0.30,
      ),
      shadow: Colors.black,
      scrim: Colors.black,
      surfaceTint: primaryColor,
    );
  }

  ThemeData _base(final ColorScheme colorScheme) {
    final primaryTextTheme = GoogleFonts.exoTextTheme();
    final secondaryTextTheme = GoogleFonts.neuchaTextTheme();
    final textTheme = primaryTextTheme.copyWith(
      displaySmall: secondaryTextTheme.displaySmall,
      displayMedium: secondaryTextTheme.displayMedium,
      displayLarge: secondaryTextTheme.displayLarge,
      headlineSmall: secondaryTextTheme.headlineSmall,
      headlineMedium: secondaryTextTheme.headlineMedium,
      headlineLarge: secondaryTextTheme.headlineLarge,
    );

    return ThemeData(
      useMaterial3: true,
      extensions: [this],
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        toolbarHeight: 152,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      ),
      cardTheme: CardThemeData(color: colorScheme.surfaceContainerHighest),
      // scaffoldBackgroundColor: isLight ? neutralColor : colorScheme.background,
      // tabBarTheme: TabBarTheme(
      //     labelColor: colorScheme.onSurface,
      //     unselectedLabelColor: colorScheme.onSurface,
      //     indicator: BoxDecoration(
      //         border: Border(
      //             bottom: BorderSide(color: colorScheme.primary, width: 2)))),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //     backgroundColor: colorScheme.secondaryContainer,
      //     foregroundColor: colorScheme.onSecondaryContainer),
      // navigationRailTheme: NavigationRailThemeData(
      //     backgroundColor: isLight ? neutralColor : colorScheme.surface,
      //     selectedIconTheme:
      //         IconThemeData(color: colorScheme.onSecondaryContainer),
      //     indicatorColor: colorScheme.secondaryContainer),
      // chipTheme: ChipThemeData(
      //     backgroundColor: isLight ? neutralColor : colorScheme.surface),
    );
  }

  ThemeData toThemeData() {
    final colorScheme = _scheme(Brightness.light);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  ThemeData toThemeDataDark() {
    final colorScheme = _scheme(Brightness.dark);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  @override
  ThemeExtension<CustomTheme> copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
  }) =>
      CustomTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
      );

  @override
  CustomTheme lerp(
    covariant ThemeExtension<CustomTheme>? other,
    double t,
  ) {
    if (other is! CustomTheme) return this;
    return CustomTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }

  static Color _mix(Color foreground, Color background, double amount) {
    return Color.alphaBlend(
      foreground.withValues(alpha: amount),
      background,
    );
  }

  static Color _foregroundFor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
