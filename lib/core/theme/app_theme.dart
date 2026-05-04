import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration.
///
/// Color ownership rule:
/// - Hardcoded color values live here only.
/// - Screens and widgets should read colors from Theme.of(context).colorScheme.
/// - The legacy AppTheme color constants remain temporarily so the existing
///   app keeps compiling while feature files are migrated one-by-one.
class AppTheme {
  // ============================================================
  // LIGHT THEME — raw palette values
  // ============================================================
  static const Color primaryColor = Color(0xFF1D4ED8);
  static const Color primaryVariant = Color(0xFF1E40AF);
  static const Color secondaryColor = Color(0xFF3B82F6);
  static const Color secondaryVariant = Color(0xFF2563EB);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  static const Color backgroundColor = Color(0xFFEFF6FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceColor = Color(0xFF1E3A8A);
  static const Color onBackgroundColor = Color(0xFF1E3A8A);

  static const Color correctAnswerColor = Color(0xFF4CAF50);
  static const Color incorrectAnswerColor = Color(0xFFF44336);
  static const Color defaultOptionColor = Color(0xFFFFFFFF);
  static const Color selectedOptionColor = Color(0xFFE3F2FD);

  static const Color _lightPrimaryContainer = Color(0xFFDBEAFE);
  static const Color _lightSecondaryContainer = Color(0xFFBFDBFE);
  static const Color _lightOutlineVariant = Color(0xFF93C5FD);

  // ============================================================
  // DARK THEME — raw palette values
  // ============================================================
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceEl1 = Color(0xFF1C1C1E);
  static const Color darkSurfaceEl2 = Color(0xFF2C2C2E);
  static const Color darkOverlay = Color(0xFF3A3A3C);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkTextTertiary = Color(0xFF636366);

  static const Color darkPrimary = Color(0xFF5A9DFF);
  static const Color darkPrimaryMuted = Color(0xFF112A4F);
  static const Color darkSecondary = Color(0xFFBF5AF2);
  static const Color darkTertiary = Color(0xFFFF9F0A);

  static const Color darkSuccess = Color(0xFF32D74B);
  static const Color darkSuccessMuted = Color(0xFF0A3614);
  static const Color darkError = Color(0xFFFF453A);
  static const Color darkErrorMuted = Color(0xFF40110F);
  static const Color darkWarning = Color(0xFFFF9F0A);
  static const Color darkWarningMuted = Color(0xFF402802);
  static const Color darkInfo = Color(0xFF64D2FF);

  static const Color _darkSecondaryContainer = Color(0xFF3D1F17);
  static const Color _darkTertiaryContainer = Color(0xFF2D1F45);
  static const Color _darkOutline = Color(0xFF30363D);
  static const Color _darkOutlineVariant = Color(0xFF21262D);
  static const Color _darkAccentEnd = Color(0xFF007AFF);
  static const Color _darkSuccessEnd = Color(0xFF28A745);
  static const Color _darkErrorEnd = Color(0xFFD70015);
  static const Color _darkSecondaryEnd = Color(0xFF8A2BE2);

  // ============================================================
  // TEXT STYLES — Manrope font system
  // ============================================================
  static TextStyle get headlineLarge => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headlineSmall => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static TextStyle get titleLarge => GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    height: 1.3,
  );

  static TextStyle get titleMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle get labelLarge => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get japaneseText => GoogleFonts.notoSansJp(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static TextStyle get burmeseText => GoogleFonts.notoSansMyanmar(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  // ============================================================
  // LIGHT THEME — ColorScheme mapping
  // ============================================================
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // primary is the app's main blue brand action color. It is used for
    // primary buttons, selected controls, progress highlights, active states,
    // major icons, and the blue emphasis text used throughout vocabulary and
    // quiz flows. The original shade is preserved exactly so existing brand
    // contrast and component emphasis do not shift.
    primary: primaryColor,

    // onPrimary is white because primary buttons and filled blue controls need
    // light text/icons to keep the original high-contrast action treatment.
    // This is used by filled buttons, app-level loading/error affordances, and
    // any future component that places content directly on primary.
    onPrimary: surfaceColor,

    // primaryContainer is the pale blue card background used by vocabulary
    // card accents and selected learning/quiz states. It keeps the existing
    // Color(0xFFDBEAFE) tone so highlighted surfaces remain soft instead of
    // looking like active buttons.
    primaryContainer: _lightPrimaryContainer,

    // onPrimaryContainer is the deeper blue label color used on pale primary
    // containers, especially vocabulary tags and card accent text. It matches
    // the former primaryVariant value for exact readability on light blue.
    onPrimaryContainer: primaryVariant,

    // secondary carries the brighter blue used for secondary emphasis, such as
    // bookmarks, secondary icons, and supporting actions. It stays distinct
    // from primary so secondary UI can remain vivid without becoming the main
    // call to action.
    secondary: secondaryColor,

    // onSecondary is white for text/icons placed directly on the brighter blue
    // secondary color, preserving the same filled-control contrast as primary.
    onSecondary: surfaceColor,

    // secondaryContainer is the tag/chip fill used by vocabulary cards and
    // lightweight badges. This exact pale blue was already used as CardPalette
    // tagBg, so mapping it here lets chips and badge backgrounds stay stable.
    secondaryContainer: _lightSecondaryContainer,

    // onSecondaryContainer uses the Blue 800 variant for compact text/icons on
    // the secondary container, matching the previous tag text color.
    onSecondaryContainer: primaryVariant,

    // tertiary maps to the app's warning amber because Material 3 tertiary is
    // the best semantic home for warm supporting emphasis that is not brand
    // blue. It is used for warning states and future warm accents.
    tertiary: warningColor,

    // onTertiary is white so text/icons placed on amber warning fills keep the
    // same simple contrast behavior as existing warning badges and snackbars.
    onTertiary: surfaceColor,

    // tertiaryContainer is the muted warning background used by the color
    // extension for low-emphasis warning surfaces. It preserves the previous
    // 10% amber tint for warning panels and no-vocabulary notices.
    tertiaryContainer: Color(0x1AFF9800),

    // onTertiaryContainer is the full warning amber for labels/icons rendered
    // on muted warning backgrounds.
    onTertiaryContainer: warningColor,

    // error is the app's destructive/error red. It is used for incorrect quiz
    // answers, delete/remove actions, validation errors, and error snackbars.
    error: errorColor,

    // onError is white because destructive filled states previously rendered
    // white text/icons on the red background.
    onError: surfaceColor,

    // errorContainer is the muted error fill used by incorrect answer
    // backgrounds and low-emphasis error panels. The alpha is kept at the
    // original 10% value.
    errorContainer: Color(0x1AF44336),

    // onErrorContainer is the full red used for icons/text on muted error
    // containers, keeping incorrect-answer labels visually identical.
    onErrorContainer: errorColor,

    // surface is pure white for cards, dialogs, input fills, list items, and
    // other raised content surfaces in light mode. This keeps the existing
    // clean white card system over the pale blue scaffold.
    surface: surfaceColor,

    // onSurface is Blue 900, the existing primary text color for headings and
    // body text on white/light surfaces. It keeps the app's slightly branded
    // text tone instead of switching to neutral black.
    onSurface: onSurfaceColor,

    // surfaceContainerHighest is the pale Blue 50 reading background used in
    // vocabulary card reading areas and soft panels. It also mirrors the light
    // scaffold color so larger content regions remain airy and consistent.
    surfaceContainerHighest: backgroundColor,

    // surfaceContainerHigh is the selected quiz option blue. It is intentionally
    // separate from primaryContainer because selected answers were a lighter,
    // more Material-blue tint than the vocabulary card container.
    surfaceContainerHigh: selectedOptionColor,

    // surfaceContainer, surfaceContainerLow, and surfaceContainerLowest all map
    // to white in light mode because the current UI does not visually separate
    // light card elevations with different fills.
    surfaceContainer: surfaceColor,
    surfaceContainerLow: surfaceColor,
    surfaceContainerLowest: surfaceColor,

    // onSurfaceVariant is the softer text color used for secondary labels,
    // hints, metadata, and inactive content. It reuses Blue 800 so muted text
    // still feels connected to the app's blue vocabulary-card palette.
    onSurfaceVariant: primaryVariant,

    // outline is the stronger border color for focused inputs and selected
    // controls. It keeps the original primary blue where borders are meant to
    // indicate activity or focus.
    outline: primaryColor,

    // outlineVariant is the pale divider/border blue used by vocabulary cards,
    // separators, and low-emphasis borders. The original Color(0xFF93C5FD)
    // remains unchanged.
    outlineVariant: _lightOutlineVariant,

    // shadow and scrim are black because Material overlays, modal barriers, and
    // card shadows should retain Flutter's standard light-mode depth behavior.
    shadow: Colors.black,
    scrim: Colors.black,

    // inverseSurface/onInverseSurface support snackbars and any inverted
    // surfaces. They use the app's text blue against white to preserve the
    // existing light palette if an inverse component appears.
    inverseSurface: onSurfaceColor,
    onInverseSurface: surfaceColor,

    // inversePrimary points to the dark-mode primary blue so components that
    // need a primary color on inverse surfaces stay legible.
    inversePrimary: darkPrimary,
  );

  static ThemeData get lightTheme {
    const colorScheme = _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.manrope().fontFamily,
      colorScheme: colorScheme,
      splashColor: colorScheme.primary.withValues(alpha: 0.15),
      highlightColor: colorScheme.primary.withValues(alpha: 0.05),
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
    );
  }

  // Alias kept for compatibility
  static ThemeData get darkPaletteLightTheme => lightTheme;

  // ============================================================
  // DARK THEME — ColorScheme mapping
  // ============================================================
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,

      // primary is the vivid dark-mode blue used for main actions, progress,
      // selected controls, focused borders, and prominent icons. It is brighter
      // than the light primary so the same brand role remains visible on black
      // and charcoal surfaces.
      primary: darkPrimary,

      // onPrimary is pure black because filled dark-mode primary controls use
      // bright blue backgrounds; black text/icons preserve the original high
      // contrast treatment.
      onPrimary: darkBackground,

      // primaryContainer is the deep muted blue used behind selected or active
      // primary content in dark mode. It keeps highlights visible without
      // flooding cards with bright blue.
      primaryContainer: darkPrimaryMuted,

      // onPrimaryContainer is the vivid primary blue for labels/icons placed on
      // the muted primary container, keeping selected states crisp.
      onPrimaryContainer: darkPrimary,

      // secondary is the soft purple used for secondary emphasis, including
      // bookmark accents, floating action buttons, and non-primary highlights.
      // It remains separate from primary so supporting actions do not compete
      // with the main blue action language.
      secondary: darkSecondary,

      // onSecondary is black because purple filled controls in this dark theme
      // are bright enough to carry dark text/icons cleanly.
      onSecondary: darkBackground,

      // secondaryContainer is a deep warm container retained from the existing
      // dark palette. It is used for muted secondary surfaces where a full
      // purple fill would be too loud.
      secondaryContainer: _darkSecondaryContainer,

      // onSecondaryContainer uses the purple accent on muted secondary
      // backgrounds for readable chips, tags, and supporting labels.
      onSecondaryContainer: darkSecondary,

      // tertiary is the amber warning/accent color used for warm emphasis and
      // warning states. It maps to Material 3 tertiary because it is neither
      // the brand action blue nor the secondary purple.
      tertiary: darkTertiary,

      // onTertiary is black for text/icons placed directly on amber fills.
      onTertiary: darkBackground,

      // tertiaryContainer is the existing deep purple-tinted container used for
      // low-emphasis tertiary surfaces in dark mode. Keeping this value avoids
      // changing the current premium dark visual balance.
      tertiaryContainer: _darkTertiaryContainer,

      // onTertiaryContainer uses amber on muted tertiary containers for warning
      // labels, icons, and future tertiary chip content.
      onTertiaryContainer: darkTertiary,

      // error is the vivid dark-mode red used for incorrect quiz answers,
      // destructive actions, and error snackbars. It is brighter than the light
      // red so it remains legible on black surfaces.
      error: darkError,

      // onError is black because the dark-mode error fill is bright enough to
      // support dark text/icons while matching the existing filled-state style.
      onError: darkBackground,

      // errorContainer is the deep red muted background used for incorrect
      // answer fills and low-emphasis error panels.
      errorContainer: darkErrorMuted,

      // onErrorContainer is vivid red for text/icons on muted error surfaces.
      onErrorContainer: darkError,

      // surface is the base charcoal surface used by cards, dialogs, inputs,
      // bottom navigation, list tiles, and most raised content. It is distinct
      // from the pure black scaffold to preserve the existing OLED-like depth.
      surface: darkSurface,

      // onSurface is pure white for primary text and icons on dark surfaces.
      onSurface: darkTextPrimary,

      // surfaceContainerHighest is the nested elevated container color used for
      // progress tracks, inner panels, and high-emphasis dark fills.
      surfaceContainerHighest: darkSurfaceEl2,

      // surfaceContainerHigh is the first elevated card layer used by snackbars,
      // dialogs, chips, elevated learning cards, and selected option surfaces.
      surfaceContainerHigh: darkSurfaceEl1,

      // surfaceContainer is the normal dark card/input surface.
      surfaceContainer: darkSurface,

      // surfaceContainerLow and surfaceContainerLowest are pure black because
      // the scaffold and lowest layers intentionally use an OLED-style base.
      surfaceContainerLow: darkBackground,
      surfaceContainerLowest: darkBackground,

      // onSurfaceVariant is the cool grey used for secondary text, hint labels,
      // inactive navigation items, supporting copy, and default icons.
      onSurfaceVariant: darkTextSecondary,

      // outline is the stronger GitHub-style border used for inputs, chip
      // borders, and visible component outlines.
      outline: _darkOutline,

      // outlineVariant is the subtler border/divider color used on cards and
      // separators where the UI needs depth without a high-contrast stroke.
      outlineVariant: _darkOutlineVariant,

      // shadow and scrim are black to preserve the existing dark overlay,
      // modal barrier, and shadow behavior.
      shadow: Colors.black,
      scrim: Colors.black,

      // inverseSurface/onInverseSurface support inverted components such as
      // snackbars. White on black mirrors the existing high-contrast dark mode.
      inverseSurface: darkTextPrimary,
      onInverseSurface: darkBackground,

      // inversePrimary is the original light-mode primary blue, giving inverse
      // surfaces a stable brand color if Material components request it.
      inversePrimary: primaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.manrope().fontFamily,
      colorScheme: colorScheme,
      splashColor: colorScheme.primary.withValues(alpha: 0.15),
      highlightColor: colorScheme.primary.withValues(alpha: 0.05),
      scaffoldBackgroundColor: darkBackground,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        color: colorScheme.surface,
        shadowColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: const TextStyle(color: darkTextTertiary),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.primary),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      primaryIconTheme: IconThemeData(color: colorScheme.primary),
    );
  }

  // ============================================================
  // DARK THEME GRADIENT & DECORATION HELPERS
  // ============================================================

  /// Dark card gradient.
  ///
  /// Uses surfaceContainerHigh -> surface to preserve the existing elevated
  /// dark-card depth. Learning cards, quiz panels, and glass-like content areas
  /// use this when a flat ColorScheme.surface fill is not visually rich enough.
  static LinearGradient get darkCardGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSurfaceEl1, darkSurface],
  );

  /// Dark primary accent gradient.
  ///
  /// Starts with ColorScheme.primary and ends with the original iOS-style blue
  /// accent. Used for premium primary highlights where the existing UI expects
  /// motion/depth while still reading as the main brand action color.
  static LinearGradient get darkAccentGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimary, _darkAccentEnd],
  );

  /// Dark success gradient.
  ///
  /// Uses the same green success family as ColorSchemeExtension.success. Quiz
  /// completion states and positive feedback can use it without changing the
  /// app's current correct-answer appearance.
  static LinearGradient get darkSuccessGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSuccess, _darkSuccessEnd],
  );

  /// Dark error gradient.
  ///
  /// Uses the dark error red family for destructive and incorrect-answer
  /// emphasis. The endpoint is preserved from the original theme so existing
  /// error gradients keep the same contrast and saturation.
  static LinearGradient get darkErrorGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkError, _darkErrorEnd],
  );

  /// Dark secondary gradient.
  ///
  /// Uses ColorScheme.secondary and its deeper purple endpoint for bookmark and
  /// secondary-action moments where the UI intentionally moves away from brand
  /// blue while retaining the same dark-mode vibrancy.
  static LinearGradient get darkSecondaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSecondary, _darkSecondaryEnd],
  );

  /// Dark glass decoration.
  ///
  /// Uses the first elevated dark surface with an 85% alpha because existing
  /// glass containers need a readable charcoal fill over the black scaffold.
  /// The border uses the primary blue at 18% alpha for a subtle brand edge, and
  /// the black shadow at 35% alpha keeps the current floating depth.
  static BoxDecoration darkGlassDecoration = BoxDecoration(
    color: darkSurfaceEl1.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: darkPrimary.withValues(alpha: 0.18), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );

  /// Returns the base ColorScheme surface for cards and panels.
  static Color surfaceForContext(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Returns the elevated ColorScheme surface for cards, snackbars, and panels.
  static Color elevatedSurfaceForContext(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerHigh;
  }

  /// Returns ColorScheme.primary for legacy call sites during migration.
  static Color primaryForContext(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// Returns the semantic success color exposed by ColorSchemeExtension.
  static Color successForContext(BuildContext context) {
    return Theme.of(context).colorScheme.success;
  }

  /// Returns ColorScheme.error for legacy call sites during migration.
  static Color errorForContext(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  /// Returns the semantic warning color exposed by ColorSchemeExtension.
  static Color warningForContext(BuildContext context) {
    return Theme.of(context).colorScheme.warning;
  }
}

extension ColorSchemeExtension on ColorScheme {
  /// Fixed white is used for content that intentionally stays white in both
  /// themes, such as text/icons on gradients, decorative light overlays, and
  /// branded hero/banner elements. This preserves existing hardcoded white
  /// areas without tying them to theme brightness.
  Color get fixedWhite => AppTheme.surfaceColor;

  /// Fixed black is used for shadows and rare text/icon cases that were
  /// intentionally pure black in both themes. Most UI should prefer shadow,
  /// scrim, or onSurface; this keeps exact legacy black where needed.
  Color get fixedBlack => AppTheme.darkBackground;

  /// Transparent is derived from surface at 0% opacity so callers can express
  /// clear fills, borders, and gradient stops through ColorScheme without
  /// depending on Colors.transparent.
  Color get transparent => surface.withValues(alpha: 0);

  /// Neutral grey is Flutter's default Colors.grey shade. It appears in
  /// fallback empty/error states and stays exact for components that were not
  /// using the branded blue text palette.
  Color get neutralGrey => const Color(0xFF9E9E9E);

  /// Neutral 100 is the very light grey used for unselected option/card fills.
  /// It remains separate from surfaceContainerHighest because the app also has
  /// a blue-tinted container for vocabulary reading surfaces.
  Color get neutral100 => const Color(0xFFF5F5F5);

  /// Neutral 200 is used for subtle inactive icon backgrounds in selection
  /// controls. It keeps the original Flutter grey[200] value.
  Color get neutral200 => const Color(0xFFEEEEEE);

  /// Neutral 300 is used for default borders, disabled button backgrounds, and
  /// unselected option outlines in light-mode quiz/setup controls.
  Color get neutral300 => const Color(0xFFE0E0E0);

  /// Neutral 400 is used for disabled or empty-state icons where the previous
  /// design wanted a mid-light grey instead of branded blue.
  Color get neutral400 => const Color(0xFFBDBDBD);

  /// Neutral 500 is used for tertiary text and low-emphasis metadata that was
  /// previously Flutter grey[500].
  Color get neutral500 => const Color(0xFF9E9E9E);

  /// Neutral 600 is used for secondary body copy, helper text, and inactive
  /// option labels in legacy light surfaces.
  Color get neutral600 => const Color(0xFF757575);

  /// Neutral 700 is used for stronger secondary text in older learning-mode
  /// cards while staying below primary text emphasis.
  Color get neutral700 => const Color(0xFF616161);

  /// Neutral 800 is used for high-emphasis fallback titles on light surfaces
  /// where the previous UI intentionally used dark grey rather than blue.
  Color get neutral800 => const Color(0xFF424242);

  /// Locked batch background in light mode. Batch selection uses this for
  /// locked blocks so unavailable content looks quiet, flat, and separate from
  /// active/completed vocabulary blocks.
  Color get batchLockedSurface => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.05)
      : const Color(0xFFF8F9FA);

  /// Locked batch border/status fill. Used by locked block borders, badges, and
  /// progress range pills to preserve the original cool grey inactive styling.
  Color get batchLockedContainer => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.10)
      : const Color(0xFFF1F3F5);

  /// Locked batch icon/text background. Gives locked block numbers a muted
  /// circular fill distinct from the card surface.
  Color get batchLockedCircle => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.10)
      : const Color(0xFFE9ECEF);

  /// Locked batch primary text. This is the darker grey label used for locked
  /// block titles in light mode and the matching muted grey in dark mode.
  Color get batchLockedTitle =>
      brightness == Brightness.dark ? neutral400 : const Color(0xFF495057);

  /// Locked batch secondary text. Used for locked block numbers, subtitles, and
  /// range pills so inactive metadata stays visibly subdued.
  Color get batchLockedText =>
      brightness == Brightness.dark ? neutral600 : const Color(0xFFADB5BD);

  /// Completed batch surface. Used for completed block cards; the dark value is
  /// intentionally alpha-blended to keep completion visible without overpowering
  /// the dark grid.
  Color get batchCompletedSurface => brightness == Brightness.dark
      ? const Color(0xFF2B4A3E).withValues(alpha: 0.30)
      : const Color(0xFFF2FCF5);

  /// Completed batch border. Keeps the original light green success border for
  /// completed vocabulary blocks.
  Color get batchCompletedOutline => brightness == Brightness.dark
      ? const Color(0xFF51CF66).withValues(alpha: 0.30)
      : const Color(0xFFB2F2BB);

  /// Completed batch circle/pill background. Used for completed block numbers
  /// and completion-count chips.
  Color get batchCompletedContainer => brightness == Brightness.dark
      ? const Color(0xFF2B4A3E)
      : const Color(0xFFD3F9D8);

  /// Completed batch foreground. Used for completed block numbers and text on
  /// completed chips, preserving the original darker green in light mode.
  Color get batchCompletedForeground => brightness == Brightness.dark
      ? const Color(0xFF51CF66)
      : const Color(0xFF2B8A3E);

  /// Completed batch badge fill. Used by the small check badge on completed
  /// blocks; it remains a stronger success green than the card container.
  Color get batchCompletedBadge => brightness == Brightness.dark
      ? const Color(0xFF51CF66)
      : const Color(0xFF40C057);

  /// Active batch surface. Used for unlocked but incomplete block cards and
  /// keeps the original pale blue progress-selection treatment.
  Color get batchActiveSurface => brightness == Brightness.dark
      ? const Color(0xFF3B5BDB).withValues(alpha: 0.15)
      : const Color(0xFFF0F4FF);

  /// Active batch border. Used around available block cards to keep the
  /// previous periwinkle blue outline exactly.
  Color get batchActiveOutline => brightness == Brightness.dark
      ? const Color(0xFF748FFC).withValues(alpha: 0.40)
      : const Color(0xFF748FFC);

  /// Active batch circle background. Used behind unlocked block numbers.
  Color get batchActiveContainer => brightness == Brightness.dark
      ? const Color(0xFF335499)
      : const Color(0xFFDCE4FF);

  /// Active batch foreground. Used for unlocked block numbers, icons, and
  /// progress percentages.
  Color get batchActiveForeground => brightness == Brightness.dark
      ? const Color(0xFF748FFC)
      : const Color(0xFF3B5BDB);

  /// Brand banner gradient start. Used by level and batch selection hero cards
  /// where the original design used a saturated indigo gradient rather than
  /// the standard primary blue.
  Color get bannerGradientStart => const Color(0xFF3B5BDB);

  /// Brand banner gradient end. Used with bannerGradientStart for the existing
  /// indigo-to-periwinkle header gradients.
  Color get bannerGradientEnd => const Color(0xFF5C7CFA);

  /// Soft banner/card background. Used by home and SRS panels that previously
  /// used a pale blue #F0F5FF surface.
  Color get softBlueSurface => const Color(0xFFF0F5FF);

  /// Dark feature card surface. Used by the legacy home feature card where the
  /// design called for a near-black #1A1A1F card instead of the global dark
  /// surface layer.
  Color get darkFeatureSurface => const Color(0xFF1A1A1F);

  /// Deep learning scaffold. Used on the vocabulary learning page for the
  /// bottom/outer dark background that is slightly bluer than pure black.
  Color get learningDeepScaffold => const Color(0xFF0A0F1D);

  /// Secondary strong blue. Used by SRS stats gradients that previously used
  /// #2563EB as a stronger endpoint than ColorScheme.secondary.
  Color get secondaryStrong => const Color(0xFF2563EB);

  /// Amber accent. Used by home streak/stat highlights that previously used
  /// #FFC107, which is brighter than the global warning amber.
  Color get amberAccent => const Color(0xFFFFC107);

  /// Home primary accent. Used by home feature panels that used the brighter
  /// #1D6BF3 blue instead of the core primary action shade.
  Color get homePrimary => const Color(0xFF1D6BF3);

  /// Home secondary accent. Used in the home gradient pair with homePrimary.
  Color get homeSecondary => const Color(0xFF3B8EF7);

  /// Home deep purple accent. Used as the second custom home card accent.
  Color get homePurple => const Color(0xFF2A1C6A);

  /// Bookmark active red. Used on the bookmarked vocabulary page for active
  /// bookmark icons and chips; it is slightly different from ColorScheme.error
  /// and therefore stays as its own semantic role.
  Color get bookmarkActive => const Color(0xFFE53935);

  /// Streak gradient start. Used by streak cards to preserve the existing warm
  /// orange achievement treatment.
  Color get streakGradientStart => const Color(0xFFE85D04);

  /// Streak gradient end. Used with streakGradientStart for streak cards.
  Color get streakGradientEnd => const Color(0xFFFF7E27);

  /// JLPT N5 accent. Used by level chips, SRS review indicators, and vocabulary
  /// learning level badges for beginner-level green states.
  Color get jlptN5 => const Color(0xFF3FB950);

  /// JLPT N4 accent. Used by level chips, SRS review indicators, and default
  /// JLPT badge fallbacks for blue states.
  Color get jlptN4 => const Color(0xFF58A6FF);

  /// JLPT N3 accent. Used by level chips and SRS review indicators for amber
  /// mid-level states.
  Color get jlptN3 => const Color(0xFFD29922);

  /// JLPT N2 accent. Used by level chips for the salmon advanced-level state.
  Color get jlptN2 => const Color(0xFFFF8C72);

  /// JLPT N1 accent. Used by level chips and category accents for the purple
  /// highest-level state.
  Color get jlptN1 => const Color(0xFFBC8CFF);

  /// SRS again/error accent. Used by review grading buttons where the previous
  /// design used GitHub-style red rather than the global error red.
  Color get srsAgain => const Color(0xFFF85149);

  /// Statistics success accent. Used by SRS stats cards for emerald progress
  /// metrics that differ from the standard success green.
  Color get statsSuccess => const Color(0xFF10B981);

  /// Statistics purple accent. Used by SRS stats cards for review/due metrics.
  Color get statsPurple => const Color(0xFF8B5CF6);

  /// Statistics orange accent. Used by SRS stats cards for warm metric cards.
  Color get statsOrange => const Color(0xFFF97316);

  /// Legacy level blue. Used by older JLPT level cards that used #4361EE as
  /// their N5/N4-style primary accent.
  Color get legacyLevelBlue => const Color(0xFF4361EE);

  /// Legacy level green. Used by older JLPT level cards for success/easy level
  /// accents.
  Color get legacyLevelGreen => const Color(0xFF28A745);

  /// Legacy level teal. Used by older level cards for informational JLPT
  /// accents.
  Color get legacyLevelTeal => const Color(0xFF17A2B8);

  /// Legacy level orange. Used by older level cards for warm JLPT accents.
  Color get legacyLevelOrange => const Color(0xFFE67E22);

  /// Legacy level red. Used by older level cards for hard/advanced JLPT accents.
  Color get legacyLevelRed => const Color(0xFFDC3545);

  /// Deep purple accent. Used by category selection for the advanced purple
  /// category chip that previously referenced Colors.deepPurpleAccent.
  Color get deepPurpleAccent => const Color(0xFF7C4DFF);

  /// Teal accent. Used by category selection where the original category chip
  /// used Flutter's teal material color.
  Color get tealAccent => const Color(0xFF009688);

  /// Learning card gradient start. Used by vocabulary learning cards and
  /// reusable card components for the existing bright cyan-blue face gradient.
  Color get learningCardGradientStart => const Color(0xFF4DB8FF);

  /// Learning card gradient end. Used with learningCardGradientStart for card
  /// faces, and matches the app's informational blue.
  Color get learningCardGradientEnd => const Color(0xFF2196F3);

  /// Learning card back gradient start. Preserves the older recall/flip card
  /// back gradient where it is still referenced.
  Color get learningCardBackStart => const Color(0xFF1E88E5);

  /// Learning card back gradient end. Preserves the darker blue endpoint used
  /// by older recall/flip card backs.
  Color get learningCardBackEnd => const Color(0xFF1565C0);

  /// Dark learning surface. Used by absorb/recall learning cards for the exact
  /// navy panel tint that sits above the black scaffold in dark mode.
  Color get learningDarkSurface => const Color(0xFF161B28);

  /// Dark learning surface alternate. Used by nested translations and panels
  /// inside learning cards.
  Color get learningDarkSurfaceAlt => const Color(0xFF16213A);

  /// Dark learning elevated surface. Used by example sentence cards and locked
  /// batch snackbars.
  Color get learningDarkElevated => const Color(0xFF1C2333);

  /// Dark learning primary container. Used by example badges and icon button
  /// backgrounds in absorb cards.
  Color get learningDarkPrimaryContainer => const Color(0xFF21335A);

  /// Dark learning outline. Used by absorb card borders and nested panel
  /// outlines.
  Color get learningDarkOutline => const Color(0xFF2A3245);

  /// Dark learning elevated outline. Used by example sentence card borders.
  Color get learningDarkOutlineAlt => const Color(0xFF2B3346);

  /// Dark learning translation outline. Used by translation boxes inside absorb
  /// cards.
  Color get learningDarkTranslationOutline => const Color(0xFF22345A);

  /// Dark learning icon fill. Used by speak buttons in absorb cards.
  Color get learningDarkIconFill => const Color(0xFF23365F);

  /// Dark learning icon border. Used by speak buttons in absorb cards.
  Color get learningDarkIconBorder => const Color(0xFF2B478B);

  /// Dark learning secondary icon border. Used by copy buttons in absorb cards.
  Color get learningDarkSecondaryIconBorder => const Color(0xFF384358);

  /// Dark learning icon accent. Used by speak icons in absorb cards.
  Color get learningDarkIconAccent => const Color(0xFF5A94FF);

  /// Dark learning muted foreground. Used by copy icons and subtle metadata in
  /// absorb cards.
  Color get learningDarkMutedForeground => const Color(0xFF7A869C);

  /// Dark learning badge foreground. Used by example-count labels.
  Color get learningDarkBadgeForeground => const Color(0xFF88A9F3);

  /// Dark learning body foreground. Used by translated example text.
  Color get learningDarkBodyForeground => const Color(0xFF9BA7C0);

  /// Dark stat surface. Used by SRS stats panels that had a slightly different
  /// black surface than the global dark background.
  Color get statsDarkSurface => const Color(0xFF16161A);

  /// Dark stat elevated surface. Used by SRS stats cards and metric containers.
  Color get statsDarkElevated => const Color(0xFF212124);

  /// Success maps correct answers, completed states, streak wins, and positive
  /// feedback. Material 3 does not provide a built-in success slot, so this
  /// extension keeps success semantic while still being read from ColorScheme.
  Color get success => brightness == Brightness.dark
      ? AppTheme.darkSuccess
      : AppTheme.successColor;

  /// Warning maps caution panels, medium quiz scores, no-vocabulary notices,
  /// and warm attention states. It aligns with tertiary in both themes.
  Color get warning => brightness == Brightness.dark
      ? AppTheme.darkWarning
      : AppTheme.warningColor;

  /// Info maps neutral informational badges and helper notices. It remains
  /// separate from primary so informational UI does not look like an action.
  Color get info =>
      brightness == Brightness.dark ? AppTheme.darkInfo : AppTheme.infoColor;

  /// Muted success is the low-emphasis correct-answer/background tint.
  Color get successMuted => brightness == Brightness.dark
      ? AppTheme.darkSuccessMuted
      : AppTheme.successColor.withValues(alpha: 0.1);

  /// Muted error is the low-emphasis incorrect-answer/error-panel tint.
  Color get errorMuted => brightness == Brightness.dark
      ? AppTheme.darkErrorMuted
      : AppTheme.errorColor.withValues(alpha: 0.1);

  /// Muted warning is the low-emphasis caution/background tint.
  Color get warningMuted => brightness == Brightness.dark
      ? AppTheme.darkWarningMuted
      : AppTheme.warningColor.withValues(alpha: 0.1);
}
