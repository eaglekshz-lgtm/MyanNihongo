import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration.
///
/// Color ownership rule:
/// - Hardcoded color values live in this file only.
/// - Screens and widgets should read colors from Theme.of(context).colorScheme.
/// - ColorSchemeExtension exists as a migration bridge for app-specific
///   semantic colors that do not have native Material 3 ColorScheme slots.
/// - The legacy AppTheme color constants remain temporarily so the existing app
///   keeps compiling while feature files are migrated one-by-one.
class AppTheme {
  // ============================================================
  // LIGHT THEME — raw palette values
  // ============================================================

  // Primary brand blue. Used by ColorScheme.primary for main actions, selected
  // states, progress fills, focused borders, and prominent vocabulary/quiz
  // affordances. This exact shade preserves the current light-mode identity.
  static const Color primaryColor = Color(0xFF1D4ED8);

  // Deep brand blue. Used by onPrimaryContainer and legacy text accents where
  // text sits on pale blue fills and needs stronger contrast than primary.
  static const Color primaryVariant = Color(0xFF1E40AF);

  // Secondary action blue. Used by ColorScheme.secondary for supporting actions
  // and secondary icons that should remain blue without competing with primary.
  static const Color secondaryColor = Color(0xFF3B82F6);

  // Strong secondary blue. Kept for older gradients and endpoints that need a
  // deeper blue than secondary while staying in the same brand family.
  static const Color secondaryVariant = Color(0xFF2563EB);

  // Positive green. Used for correct answers, completed states, success
  // snackbars, streak wins, and success semantic extension colors.
  static const Color successColor = Color(0xFF4CAF50);

  // Destructive red. Used by ColorScheme.error for incorrect answers,
  // validation errors, destructive actions, and error feedback.
  static const Color errorColor = Color(0xFFF44336);

  // Warning amber. Used by ColorScheme.tertiary for caution states, warm
  // attention panels, and warning semantic extension colors.
  static const Color warningColor = Color(0xFFFF9800);

  // Informational blue. Used by informational badges/notices and older learning
  // card gradients where the color should not imply a primary action.
  static const Color infoColor = Color(0xFF2196F3);

  // Light scaffold blue. Used by scaffoldBackgroundColor and the highest
  // surface container so the app keeps its airy blue-tinted background.
  static const Color backgroundColor = Color(0xFFEFF6FF);

  // Light base surface. Used by cards, dialogs, inputs, list items, and fixed
  // white content that intentionally stays white in both themes.
  static const Color surfaceColor = Color(0xFFFFFFFF);

  // Light primary text blue. Used by ColorScheme.onSurface so headings/body
  // text retain the current branded navy tone rather than neutral black.
  static const Color onSurfaceColor = Color(0xFF1E3A8A);

  // Legacy background foreground. Kept as an alias for older call sites that
  // referred to background text before the app moved fully to ColorScheme.
  static const Color onBackgroundColor = Color(0xFF1E3A8A);

  // Correct-answer semantic alias. Kept for quiz migration and maps to the
  // same green as successColor so old and new correct states remain identical.
  static const Color correctAnswerColor = Color(0xFF4CAF50);

  // Incorrect-answer semantic alias. Kept for quiz migration and maps to the
  // same red as errorColor so old and new incorrect states remain identical.
  static const Color incorrectAnswerColor = Color(0xFFF44336);

  // Default quiz option fill. Used by ColorScheme.surface and old option cards
  // so unselected answers continue to render as pure white.
  static const Color defaultOptionColor = Color(0xFFFFFFFF);

  // Selected quiz option fill. Used by surfaceContainerHigh to preserve the
  // previous soft Material-blue selected-answer treatment.
  static const Color selectedOptionColor = Color(0xFFE3F2FD);

  // Pale primary container. Used for selected vocabulary/card accents where a
  // brand-blue tint is needed without the weight of a filled button.
  static const Color _lightPrimaryContainer = Color(0xFFDBEAFE);

  // Pale secondary container. Used for tags, chips, and lightweight badges that
  // need a slightly stronger blue fill than the scaffold background.
  static const Color _lightSecondaryContainer = Color(0xFFBFDBFE);

  // Light outline variant. Used for low-emphasis borders and dividers in card
  // layouts while preserving the existing pale-blue stroke system.
  static const Color _lightOutlineVariant = Color(0xFF93C5FD);

  // ============================================================
  // DARK THEME — raw palette values
  // ============================================================

  // Dark scaffold black. Used by ColorScheme lowest containers, the dark
  // scaffold, fixed black, modal scrims, and high-contrast dark backgrounds.
  static const Color darkBackground = Color(0xFF000000);

  // Dark base surface. Used by ColorScheme.surface for cards, inputs, dialogs,
  // navigation, and most raised content over the black scaffold.
  static const Color darkSurface = Color(0xFF121212);

  // First dark elevation. Used by surfaceContainerHigh and dark card gradients
  // for panels that need visible depth without becoming grey.
  static const Color darkSurfaceEl1 = Color(0xFF1C1C1E);

  // Second dark elevation. Used by surfaceContainerHighest for inner panels,
  // progress tracks, selected surfaces, and nested dark fills.
  static const Color darkSurfaceEl2 = Color(0xFF2C2C2E);

  // Dark overlay grey. Reserved for overlays and legacy surfaces that need a
  // brighter charcoal than normal elevated cards.
  static const Color darkOverlay = Color(0xFF3A3A3C);

  // Dark primary text. Used by ColorScheme.onSurface for headings, body text,
  // icons, and high-emphasis content on charcoal surfaces.
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  // Dark secondary text. Used by onSurfaceVariant for metadata, inactive
  // states, hint-adjacent text, and lower-emphasis icons.
  static const Color darkTextSecondary = Color(0xFF8E8E93);

  // Dark tertiary text. Used by dark input hints where the existing UI wants a
  // quieter grey than onSurfaceVariant.
  static const Color darkTextTertiary = Color(0xFF636366);

  // Dark primary blue. Used by ColorScheme.primary for main actions, progress,
  // selected controls, and active learning accents in dark mode.
  static const Color darkPrimary = Color(0xFF5A9DFF);

  // Muted dark primary container. Used by primaryContainer for active/selected
  // dark surfaces that should read blue without becoming luminous.
  static const Color darkPrimaryMuted = Color(0xFF112A4F);

  // Dark secondary purple. Used by ColorScheme.secondary for bookmark,
  // floating-action, and secondary emphasis moments in dark mode.
  static const Color darkSecondary = Color(0xFFBF5AF2);

  // Dark tertiary amber. Used by ColorScheme.tertiary for warnings and warm
  // accents that must remain vivid on black and charcoal surfaces.
  static const Color darkTertiary = Color(0xFFFF9F0A);

  // Dark success green. Used by success semantic colors and correct/completed
  // states so positive feedback stays legible on dark surfaces.
  static const Color darkSuccess = Color(0xFF32D74B);

  // Dark muted success fill. Used by low-emphasis success containers and
  // correct-answer backgrounds in dark mode.
  static const Color darkSuccessMuted = Color(0xFF0A3614);

  // Dark error red. Used by ColorScheme.error for destructive and incorrect
  // states in dark mode.
  static const Color darkError = Color(0xFFFF453A);

  // Dark muted error fill. Used by errorContainer and low-emphasis incorrect
  // answer surfaces in dark mode.
  static const Color darkErrorMuted = Color(0xFF40110F);

  // Dark warning amber. Used by warning semantic colors and matches tertiary so
  // caution states stay consistent with Material's warm accent role.
  static const Color darkWarning = Color(0xFFFF9F0A);

  // Dark muted warning fill. Used by low-emphasis caution panels and warning
  // backgrounds in dark mode.
  static const Color darkWarningMuted = Color(0xFF402802);

  // Dark informational cyan. Used by info semantic colors where an informational
  // state needs to remain separate from primary action blue.
  static const Color darkInfo = Color(0xFF64D2FF);

  // Deep secondary container. Used by ColorScheme.secondaryContainer for muted
  // secondary surfaces where a full purple fill would be too strong.
  static const Color _darkSecondaryContainer = Color(0xFF3D1F17);

  // Deep tertiary container. Used by ColorScheme.tertiaryContainer for muted
  // warm/purple supporting surfaces in dark mode.
  static const Color _darkTertiaryContainer = Color(0xFF2D1F45);

  // Strong dark outline. Used by ColorScheme.outline for input, chip, and
  // component borders that need a clear visible edge.
  static const Color _darkOutline = Color(0xFF30363D);

  // Subtle dark outline. Used by outlineVariant for separators and low-emphasis
  // card borders.
  static const Color _darkOutlineVariant = Color(0xFF21262D);

  // Dark primary gradient endpoint. Used with darkPrimary for premium blue
  // accent gradients while keeping the current iOS-style blue endpoint.
  static const Color _darkAccentEnd = Color(0xFF007AFF);

  // Dark success gradient endpoint. Used by positive dark gradients to preserve
  // the original deeper green finish.
  static const Color _darkSuccessEnd = Color(0xFF28A745);

  // Dark error gradient endpoint. Used by destructive dark gradients to keep
  // the current deeper red finish.
  static const Color _darkErrorEnd = Color(0xFFD70015);

  // Dark secondary gradient endpoint. Used with darkSecondary for purple
  // gradients in bookmark and secondary-action contexts.
  static const Color _darkSecondaryEnd = Color(0xFF8A2BE2);

  // ============================================================
  // TEXT STYLES — Manrope font system
  // ============================================================
  static final TextStyle headlineLarge = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static final TextStyle headlineMedium = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static final TextStyle headlineSmall = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static final TextStyle titleLarge = GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    height: 1.3,
  );

  static final TextStyle titleMedium = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  static final TextStyle bodyLarge = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle labelLarge = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static final TextStyle japaneseText = GoogleFonts.notoSansJp(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static final TextStyle burmeseText = GoogleFonts.notoSansMyanmar(
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

    // shadow and scrim use the theme-owned fixed black so Material overlays,
    // modal barriers, and card shadows retain Flutter's standard light-mode
    // depth behavior while still being defined inside this palette.
    shadow: darkBackground,
    scrim: darkBackground,

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
  static const ColorScheme _darkColorScheme = ColorScheme(
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

    // errorContainer is the deep red muted background used for incorrect answer
    // fills and low-emphasis error panels.
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

    // surfaceContainerLow and surfaceContainerLowest are pure black because the
    // scaffold and lowest layers intentionally use an OLED-style base.
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

    // shadow and scrim use the theme-owned fixed black to preserve the existing
    // dark overlay, modal barrier, and shadow behavior.
    shadow: darkBackground,
    scrim: darkBackground,

    // inverseSurface/onInverseSurface support inverted components such as
    // snackbars. White on black mirrors the existing high-contrast dark mode.
    inverseSurface: darkTextPrimary,
    onInverseSurface: darkBackground,

    // inversePrimary is the original light-mode primary blue, giving inverse
    // surfaces a stable brand color if Material components request it.
    inversePrimary: primaryColor,
  );

  static ThemeData get darkTheme {
    const colorScheme = _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.manrope().fontFamily,
      colorScheme: colorScheme,
      splashColor: colorScheme.primary.withValues(alpha: 0.15),
      highlightColor: colorScheme.primary.withValues(alpha: 0.05),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.transparent,
        shadowColor: colorScheme.transparent,
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
        shadowColor: colorScheme.transparent,
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
        surfaceTintColor: colorScheme.transparent,
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
        color: darkBackground.withValues(alpha: 0.35),
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

  /// Home scaffold surface. Keeps the home page black in dark mode and the
  /// soft blue #F0F5FF base in light mode.
  Color get homeScaffold =>
      brightness == Brightness.dark ? fixedBlack : softBlueSurface;

  /// Home hero gradient colors. Dark mode uses the existing purple-to-black
  /// header, while light mode keeps the bright blue-to-soft-blue stack.
  List<Color> get homeGradientColors => brightness == Brightness.dark
      ? [homePurple, fixedBlack]
      : [homePrimary, homeSecondary, softBlueSurface];

  /// Home hero gradient stops. Preserves the two-stop dark fade and three-stop
  /// light fade used by the current home page.
  List<double> get homeGradientStops =>
      brightness == Brightness.dark ? [0.0, 1.0] : [0.0, 0.6, 1.0];

  /// Home section icon backing. Keeps the dark translucent white treatment and
  /// the light blue-tinted treatment for the start-learning marker.
  Color get homeSectionIconSurface => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.10)
      : homePrimary.withValues(alpha: 0.10);

  /// Home feature card surface. Feature cards use a custom near-black panel in
  /// dark mode and the standard surface in light mode.
  Color get homeFeatureSurface =>
      brightness == Brightness.dark ? darkFeatureSurface : surface;

  /// Home feature card border. Dark cards use a subtle white edge, while light
  /// cards tint the border with the feature accent color.
  Color homeFeatureBorder(Color accent) => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.05)
      : accent.withValues(alpha: 0.15);

  /// Glass default tint base. Glass containers tint with white in dark mode and
  /// primary blue in light mode before the caller's opacity is applied.
  Color get glassTintBase =>
      brightness == Brightness.dark ? fixedWhite : primary;

  /// Glass default border. Preserves the stronger dark white edge and the
  /// primary-blue light edge for frosted panels.
  Color get glassBorder => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.28)
      : primary.withValues(alpha: 0.30);

  /// Glass shadow alpha. Dark glass uses a deeper shadow than light glass.
  double get glassShadowAlpha => brightness == Brightness.dark ? 0.28 : 0.10;

  /// Mesh primary orb alpha. Light mode returns zero because the previous light
  /// mesh path rendered a plain solid background.
  double get meshPrimaryOrbAlpha => brightness == Brightness.dark ? 0.30 : 0.0;

  /// Mesh secondary primary-orb alpha for the smaller lower-left glow.
  double get meshPrimaryOrbSecondaryAlpha =>
      brightness == Brightness.dark ? 0.21 : 0.0;

  /// Mesh secondary accent alpha for the center ambient glow.
  double get meshSecondaryOrbAlpha =>
      brightness == Brightness.dark ? 0.20 : 0.0;

  /// Mesh scrim alpha. Dark mesh keeps the readability scrim; light mode stays
  /// exactly solid by returning zero.
  double get meshScrimAlpha => brightness == Brightness.dark ? 0.50 : 0.0;

  /// Shared card border for learning progress panels.
  Color get learningPanelBorder =>
      brightness == Brightness.dark ? outlineVariant : transparent;

  /// Shared card shadow alpha for learning progress panels.
  double get learningPanelShadowAlpha =>
      brightness == Brightness.dark ? 0.30 : 0.06;

  /// Configuration card shadow alpha used by setup sections.
  double get configSectionShadowAlpha =>
      brightness == Brightness.dark ? 0.20 : 0.05;

  /// Bottom start/action bar shadow alpha used by learning and quiz setup
  /// bottom controls.
  double get bottomActionBarShadowAlpha =>
      brightness == Brightness.dark ? 0.20 : 0.05;

  /// Quiz result bottom glass tint opacity. Dark mode needs a lighter tint than
  /// the brighter light-mode glass bar.
  double get quizResultBottomTintOpacity =>
      brightness == Brightness.dark ? 0.22 : 0.38;

  /// Meaning-language card shadow alpha used by setup sections.
  double get meaningLanguageShadowAlpha =>
      brightness == Brightness.dark ? 0.15 : 0.03;

  /// Recall card blur sigma. Dark mode keeps the frosted effect; light mode
  /// remains flat.
  double get recallCardBlur => brightness == Brightness.dark ? 20.0 : 0.0;

  /// Recall card tint opacity.
  double get recallCardTintOpacity =>
      brightness == Brightness.dark ? 0.18 : 1.0;

  /// Shared flashcard surface for absorb and recall learning cards. Light mode
  /// uses a calm white card instead of a colored fill so swipe feedback can be
  /// directional without making the resting card feel noisy.
  Color get learningFlashcardSurface =>
      brightness == Brightness.dark ? learningDarkSurface : fixedWhite;

  /// Main vocabulary word foreground on learning flashcards.
  Color get learningWordForeground =>
      brightness == Brightness.dark ? fixedWhite : fixedBlack;

  /// Invisible flashcard border for the current no-border card treatment.
  Color get learningFlashcardTransparentBorder => transparent;

  /// Shared flashcard border for absorb and recall learning cards.
  Color get learningFlashcardBorder => brightness == Brightness.dark
      ? learningDarkOutline
      : outlineVariant.withValues(alpha: 0.58);

  /// Shared bookmarked flashcard border.
  Color get learningFlashcardBookmarkBorder => brightness == Brightness.dark
      ? secondary.withValues(alpha: 0.72)
      : secondary.withValues(alpha: 0.62);

  /// Recall card border.
  Color get recallCardBorder => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.22)
      : outlineVariant;

  /// Absorb card fill. Dark mode uses the custom learning navy surface; light
  /// mode keeps the primary container flashcard tint.
  Color get absorbCardSurface =>
      brightness == Brightness.dark ? learningDarkSurface : primaryContainer;

  /// Absorb card normal border. Bookmark borders are still supplied by callers
  /// through the secondary accent, while this covers the default state.
  Color get absorbCardBorder =>
      brightness == Brightness.dark ? learningDarkOutline : outlineVariant;

  /// Study-mode part-of-speech badge fill.
  Color get studyBadgeSurface =>
      brightness == Brightness.dark ? primaryContainer : secondaryContainer;

  /// Study-mode part-of-speech badge border.
  Color get studyBadgeBorder => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.25)
      : outlineVariant;

  /// Study-mode part-of-speech badge foreground.
  Color get studyBadgeForeground =>
      brightness == Brightness.dark ? primary : onPrimaryContainer;

  /// Study-mode reading pill fallback fill. It is null in dark mode because the
  /// dark design uses a gradient instead of a flat color.
  Color? get studyReadingSurface =>
      brightness == Brightness.dark ? null : surfaceContainerHighest;

  /// Study-mode reading pill gradient. Light mode returns null to preserve its
  /// original flat surface.
  LinearGradient? get studyReadingGradient => brightness == Brightness.dark
      ? LinearGradient(
          colors: [primaryContainer, primaryContainer.withValues(alpha: 0.80)],
        )
      : null;

  /// Study-mode reading pill border.
  Color get studyReadingBorder => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.20)
      : outlineVariant;

  /// Study-mode divider flat color. Dark mode uses the gradient divider instead
  /// of this flat color.
  Color? get studyDividerColor =>
      brightness == Brightness.dark ? null : outlineVariant;

  /// Study-mode divider gradient.
  LinearGradient? get studyDividerGradient => brightness == Brightness.dark
      ? LinearGradient(
          colors: [transparent, primary.withValues(alpha: 0.30), transparent],
        )
      : null;

  /// Study-mode meaning label side rules.
  Color get studyMeaningRule => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.30)
      : outlineVariant;

  /// Study-mode meaning label foreground.
  Color get studyMeaningForeground =>
      brightness == Brightness.dark ? primary.withValues(alpha: 0.70) : primary;

  /// Example-sentences title foreground.
  Color get exampleTitleForeground =>
      brightness == Brightness.dark ? learningDarkIconAccent : primary;

  /// Example sentence card fill.
  Color get exampleCardSurface => brightness == Brightness.dark
      ? learningDarkElevated
      : primary.withValues(alpha: 0.05);

  /// Example sentence card border.
  Color get exampleCardBorder => brightness == Brightness.dark
      ? learningDarkOutlineAlt
      : primary.withValues(alpha: 0.15);

  /// Example badge fill.
  Color get exampleBadgeSurface => brightness == Brightness.dark
      ? learningDarkPrimaryContainer
      : secondaryContainer;

  /// Example badge foreground.
  Color get exampleBadgeForeground => brightness == Brightness.dark
      ? learningDarkBadgeForeground
      : onPrimaryContainer;

  /// Example Japanese sentence foreground.
  Color get exampleJapaneseForeground =>
      brightness == Brightness.dark ? fixedWhite : onSurface;

  /// Example speaker button fill.
  Color get exampleSpeakerSurface => brightness == Brightness.dark
      ? learningDarkIconFill
      : primary.withValues(alpha: 0.15);

  /// Example speaker button border.
  Color get exampleSpeakerBorder => brightness == Brightness.dark
      ? learningDarkIconBorder
      : primary.withValues(alpha: 0.30);

  /// Example speaker icon foreground.
  Color get exampleSpeakerForeground =>
      brightness == Brightness.dark ? learningDarkIconAccent : primary;

  /// Example copy button fill.
  Color get exampleCopySurface => brightness == Brightness.dark
      ? learningDarkSecondaryIconFill
      : transparent;

  /// Example copy button border.
  Color get exampleCopyBorder => brightness == Brightness.dark
      ? learningDarkSecondaryIconBorder
      : secondary.withValues(alpha: 0.30);

  /// Example copy icon foreground.
  Color get exampleCopyForeground =>
      brightness == Brightness.dark ? learningDarkMutedForeground : secondary;

  /// Example translation box fill.
  Color get exampleTranslationSurface => brightness == Brightness.dark
      ? learningDarkSurfaceAlt
      : surfaceContainerHighest;

  /// Example translation box border.
  Color get exampleTranslationBorder => brightness == Brightness.dark
      ? learningDarkTranslationOutline
      : outlineVariant;

  /// Example translation leading icon foreground.
  Color get exampleTranslationIcon =>
      brightness == Brightness.dark ? learningDarkIconAccent : primary;

  /// Example translation body foreground.
  Color get exampleTranslationBody =>
      brightness == Brightness.dark ? learningDarkBodyForeground : onSurface;

  /// Learning action-bar surface.
  Color get learningControlsSurface => brightness == Brightness.dark
      ? surfaceContainerHigh
      : fixedWhite.withValues(alpha: 0.80);

  /// Learning action-bar top divider.
  Color get learningControlsBorder => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.08)
      : fixedBlack.withValues(alpha: 0.05);

  /// Disabled learning button background.
  Color get learningDisabledBackground =>
      brightness == Brightness.dark ? surfaceContainerHighest : neutral100;

  /// Disabled learning button foreground.
  Color get learningDisabledForeground => brightness == Brightness.dark
      ? onSurface.withValues(alpha: 0.30)
      : neutral400;

  /// Disabled learning button border.
  Color get learningDisabledBorder => brightness == Brightness.dark
      ? outline.withValues(alpha: 0.20)
      : neutral300;

  /// Inactive bookmark button foreground.
  Color get learningInactiveBookmarkForeground => brightness == Brightness.dark
      ? onSurface.withValues(alpha: 0.50)
      : neutral600;

  /// Inactive bookmark button border.
  Color get learningInactiveBookmarkBorder => brightness == Brightness.dark
      ? outline.withValues(alpha: 0.20)
      : neutral400.withValues(alpha: 0.30);

  /// Category badge fill used by recall cards.
  Color get categoryBadgeSurface => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.12)
      : primaryContainer;

  /// Category badge border used by recall cards.
  Color get categoryBadgeBorder => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.25)
      : outlineVariant;

  /// Category badge text color.
  Color get categoryBadgeForeground =>
      brightness == Brightness.dark ? primary : onPrimaryContainer;

  /// Reading pill fill for Burmese/English card backs.
  Color get readingPillSurface => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.15)
      : primary.withValues(alpha: 0.06);

  /// Reading pill border for Burmese/English card backs.
  Color get readingPillBorder => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.25)
      : primary.withValues(alpha: 0.20);

  /// Vocabulary learning app-bar foreground.
  Color get learningAppBarForeground =>
      brightness == Brightness.dark ? fixedWhite : onSurface;

  /// Vocabulary learning app-bar icon foreground.
  Color get learningAppBarIcon =>
      brightness == Brightness.dark ? learningDarkMutedForeground : onSurface;

  /// Vocabulary learning scaffold surface.
  Color get learningScaffold =>
      brightness == Brightness.dark ? learningDeepScaffold : surface;

  /// Vocabulary learning page background.
  Color get learningPageScaffold =>
      brightness == Brightness.dark ? learningDeepScaffold : lightLearningPage;

  /// Whether the learning screen should use the ambient mesh background.
  bool get usesLearningMesh => brightness != Brightness.dark;

  /// Hard swipe flash color.
  Color get learningHardFlash => const Color(0xFFF87171);

  /// Easy swipe flash color.
  Color get learningEasyFlash => const Color(0xFF34D399);

  /// Recall choice "Hard" action color.
  Color get learningRecallHard => bookmarkActive;

  /// Recall choice "Easy" action color.
  Color get learningRecallEasy => const Color(0xFF2E7D32);

  /// Learning swipe primary lift shadow alpha.
  double get learningSwipeLiftShadowAlpha =>
      brightness == Brightness.dark ? 0.34 : 0.12;

  /// Learning swipe active-color shadow alpha multiplier.
  double get learningSwipeActiveShadowAlpha =>
      brightness == Brightness.dark ? 0.16 : 0.10;

  /// Learning swipe next-card primary slot shadow alpha.
  double get learningSwipeSlotPrimaryShadowAlpha =>
      brightness == Brightness.dark ? 0.28 : 0.12;

  /// Learning swipe next-card secondary slot shadow alpha.
  double get learningSwipeSlotSecondaryShadowAlpha =>
      brightness == Brightness.dark ? 0.10 : 0.05;

  /// Empty card-stack slot fill.
  Color get learningSwipeEmptySlotSurface =>
      brightness == Brightness.dark ? surfaceContainerLowest : lightStackSlot;

  /// Learning swipe directional overlay alpha multiplier.
  double get learningSwipeOverlayAlpha =>
      brightness == Brightness.dark ? 0.06 : 0.04;

  /// Muted difficulty label foreground in the learning progress header.
  Color get learningDifficultyMutedForeground => brightness == Brightness.dark
      ? onSurface.withValues(alpha: 0.25)
      : onSurface.withValues(alpha: 0.22);

  /// Vocabulary progress header number font size.
  double get learningProgressNumberFontSize =>
      brightness == Brightness.dark ? 20 : 15;

  /// Vocabulary progress header number font weight.
  FontWeight get learningProgressNumberFontWeight =>
      brightness == Brightness.dark ? FontWeight.w700 : FontWeight.w600;

  /// Vocabulary progress header foreground.
  Color get learningProgressForeground =>
      brightness == Brightness.dark ? learningDarkIconAccent : onSurface;

  /// Vocabulary progress current-index foreground.
  Color get learningProgressCurrentForeground =>
      brightness == Brightness.dark ? learningDarkIconAccent : primary;

  /// Vocabulary progress current-index font size.
  double? get learningProgressCurrentFontSize =>
      brightness == Brightness.dark ? null : 16;

  /// Vocabulary progress level pill fill.
  Color get learningLevelPillSurface => brightness == Brightness.dark
      ? learningDarkPrimaryContainer
      : primary.withValues(alpha: 0.12);

  /// Vocabulary progress level pill border.
  Color get learningLevelPillBorder => brightness == Brightness.dark
      ? learningDarkIconBorder
      : primary.withValues(alpha: 0.12);

  /// Vocabulary progress level pill foreground.
  Color get learningLevelPillForeground =>
      brightness == Brightness.dark ? learningDarkBadgeForeground : primary;

  /// Vocabulary progress track.
  Color get learningProgressTrack => brightness == Brightness.dark
      ? learningDarkProgressTrack
      : outlineVariant.withValues(alpha: 0.25);

  /// Vocabulary progress fill.
  Color learningProgressFill(bool highlightSuccess) =>
      brightness == Brightness.dark
      ? learningDarkIconAccent
      : (highlightSuccess ? success : primary);

  /// Vocabulary progress glow.
  List<BoxShadow>? get learningProgressGlow => brightness == Brightness.dark
      ? [
          BoxShadow(
            color: learningDarkIconAccent.withValues(alpha: 0.60),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ]
      : null;

  /// Batch back button surface.
  Color get batchBackButtonSurface => brightness == Brightness.dark
      ? fixedWhite.withValues(alpha: 0.10)
      : fixedBlack.withValues(alpha: 0.05);

  /// Locked batch snackbar foreground.
  Color get batchLockedSnackForeground =>
      brightness == Brightness.dark ? fixedWhite : fixedBlack;

  /// Locked batch snackbar background.
  Color get batchLockedSnackBackground =>
      brightness == Brightness.dark ? learningDarkElevated : fixedWhite;

  /// Locked batch range pill fill.
  Color get batchLockedRangeSurface =>
      brightness == Brightness.dark ? neutral800 : batchLockedContainer;

  /// Locked batch range pill text.
  Color get batchLockedRangeForeground =>
      brightness == Brightness.dark ? neutral400 : batchLockedText;

  /// Batch top-banner gradient.
  List<Color> get batchBannerGradientColors => brightness == Brightness.dark
      ? [primary.withValues(alpha: 0.80), primary.withValues(alpha: 0.40)]
      : [bannerGradientStart, bannerGradientEnd];

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

  /// Soft banner/card background. Used by home panels that previously used a
  /// pale blue #F0F5FF surface.
  Color get softBlueSurface => const Color(0xFFF0F5FF);

  /// Dark feature card surface. Used by the legacy home feature card where the
  /// design called for a near-black #1A1A1F card instead of the global dark
  /// surface layer.
  Color get darkFeatureSurface => const Color(0xFF1A1A1F);

  /// Deep learning scaffold. Used on the vocabulary learning page behind the
  /// progress header, flipped vocabulary card, and bottom controls. The
  /// screenshot uses an almost-black navy rather than pure black, so this keeps
  /// the learning experience deep and calm while preserving the blue undertone
  /// that lets the card borders remain visible.
  Color get learningDeepScaffold => const Color(0xFF060C18);

  /// Secondary strong blue. Used where the UI needs #2563EB as a stronger
  /// endpoint than ColorScheme.secondary.
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

  /// JLPT N5 accent. Used by level chips and vocabulary learning level badges
  /// for beginner-level green states.
  Color get jlptN5 => const Color(0xFF3FB950);

  /// JLPT N4 accent. Used by level chips and default JLPT badge fallbacks for
  /// blue states.
  Color get jlptN4 => const Color(0xFF58A6FF);

  /// JLPT N3 accent. Used by level chips for amber mid-level states.
  Color get jlptN3 => const Color(0xFFD29922);

  /// JLPT N2 accent. Used by level chips for the salmon advanced-level state.
  Color get jlptN2 => const Color(0xFFFF8C72);

  /// JLPT N1 accent. Used by level chips and category accents for the purple
  /// highest-level state.
  Color get jlptN1 => const Color(0xFFBC8CFF);

  /// Statistics success accent for emerald progress metrics that differ from
  /// the standard success green.
  Color get statsSuccess => const Color(0xFF10B981);

  /// Statistics purple accent.
  Color get statsPurple => const Color(0xFF8B5CF6);

  /// Statistics orange accent.
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

  /// Light learning page background used behind vocabulary flashcards.
  Color get lightLearningPage => const Color(0xFFEEF3FF);

  /// Light empty stack slot shown when there is no next vocabulary card.
  Color get lightStackSlot => const Color(0xFFDDE6F8);

  /// Dark learning surface. Used by the large flipped vocabulary card that
  /// contains "Example Sentences". The selected shade matches the screenshot's
  /// raised navy panel: lighter than the scaffold, darker than the nested
  /// example cards, and quiet enough for the bright blue title to stand out.
  Color get learningDarkSurface => const Color(0xFF111824);

  /// Dark learning translation surface. Used inside each example sentence for
  /// the Burmese/English translation pill. This shade is intentionally bluer
  /// than the surrounding example card so the translation area reads as an
  /// interactive/supporting surface while keeping the same low-light tone.
  Color get learningDarkSurfaceAlt => const Color(0xFF17243A);

  /// Dark learning elevated surface. Used by individual example sentence cards
  /// and small elevated learning panels. It is one step above the main card
  /// surface, matching the screenshot where examples sit as distinct nested
  /// panels without becoming bright grey boxes.
  Color get learningDarkElevated => const Color(0xFF1A202C);

  /// Dark learning primary container. Used by the N-level pill, example number
  /// badges, and blue-tinted learning controls. This color keeps the exact
  /// dark-blue badge family shown in the screenshot while mapping semantically
  /// to a primary container state rather than a one-off hardcoded chip color.
  Color get learningDarkPrimaryContainer => const Color(0xFF1B3768);

  /// Dark learning outline. Used by the outer learning card border. The value
  /// is a low-contrast blue-grey chosen so the big card edge remains visible on
  /// the near-black scaffold without creating a heavy frame.
  Color get learningDarkOutline => const Color(0xFF2A3342);

  /// Dark learning elevated outline. Used by example sentence card borders. It
  /// is slightly brighter than learningDarkOutline because nested cards need a
  /// clearer edge against the dark learning surface.
  Color get learningDarkOutlineAlt => const Color(0xFF303847);

  /// Dark learning translation outline. Used by translation boxes inside
  /// example cards. The screenshot gives these boxes a more saturated blue
  /// border, so this role preserves that emphasis while keeping it separate
  /// from general card outlines.
  Color get learningDarkTranslationOutline => const Color(0xFF21437E);

  /// Dark learning icon fill. Used by the active speaker button background in
  /// example sentence rows. It shares the badge's blue family but is tuned
  /// darker so the bright speaker icon remains the focal point.
  Color get learningDarkIconFill => const Color(0xFF1D3768);

  /// Dark learning icon border. Used by the active speaker button border and
  /// level pill border. This saturated outline is what gives the controls their
  /// crisp blue edge in the screenshot.
  Color get learningDarkIconBorder => const Color(0xFF2C57A3);

  /// Dark learning secondary icon fill. Used by inactive secondary icon
  /// buttons such as copy. The screenshot shows these controls as filled
  /// charcoal buttons, not transparent outlines, so this role gives secondary
  /// actions a solid muted surface.
  Color get learningDarkSecondaryIconFill => const Color(0xFF252B37);

  /// Dark learning secondary icon border. Used by copy buttons in absorb cards.
  /// This blue-grey border is softer than the speaker border to communicate
  /// secondary action priority while still matching the visible rounded control.
  Color get learningDarkSecondaryIconBorder => const Color(0xFF3A4352);

  /// Dark learning accent blue. Used for the progress number, progress fill,
  /// "Example Sentences" title, speaker icons, and translation leading icon.
  /// It matches the screenshot's vivid periwinkle-blue action color and keeps
  /// all active learning accents tied to one semantic learning role.
  Color get learningDarkIconAccent => const Color(0xFF5A9DFF);

  /// Dark learning progress track. Used by the thin progress bar track below
  /// the word count. The track is deliberately close to the card outline color
  /// so progress is visible but understated behind the bright fill.
  Color get learningDarkProgressTrack => const Color(0xFF1B2330);

  /// Dark learning muted foreground. Used by back/reset app-bar icons, copy
  /// icons, and low-emphasis controls on the learning screen. This grey-blue
  /// matches the screenshot's inactive icon treatment and avoids stark white
  /// for non-primary actions.
  Color get learningDarkMutedForeground => const Color(0xFF8B95A5);

  /// Dark learning badge foreground. Used by the N-level pill and "Example 1"
  /// badges. It is a lighter companion to learningDarkPrimaryContainer so text
  /// remains readable while staying within the screenshot's blue badge palette.
  Color get learningDarkBadgeForeground => const Color(0xFFA5C6FF);

  /// Dark learning body foreground. Used by translated example text. The
  /// screenshot renders Burmese translations as muted blue-grey rather than
  /// pure white, which keeps them secondary to the Japanese sentence while
  /// preserving legibility on the blue translation surface.
  Color get learningDarkBodyForeground => const Color(0xFFAEB8CB);

  /// Dark stat surface.
  Color get statsDarkSurface => const Color(0xFF16161A);

  /// Dark stat elevated surface.
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

  /// Quiz progress track color.
  Color get quizProgressTrack => brightness == Brightness.light
      ? primary.withValues(alpha: 0.15)
      : surfaceContainerHighest;

  /// Whether quiz options use the light-mode leading letter circle treatment.
  bool get usesQuizOptionLetterCircle => brightness == Brightness.light;

  /// Quiz option glass tint.
  Color quizOptionTint({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (brightness == Brightness.light) {
      if (hasAnswered) {
        if (isCorrect) return success;
        if (isSelected) return error;
      }
      return surface;
    }

    if (hasAnswered) {
      if (isCorrect) return success;
      if (isSelected) return error;
    }
    if (isSelected) return primary;
    return fixedWhite;
  }

  /// Quiz option glass tint opacity.
  double quizOptionTintOpacity({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (brightness == Brightness.light) {
      return hasAnswered && (isCorrect || isSelected) ? 0.08 : 1.0;
    }

    if (hasAnswered) return 0.18;
    return isSelected ? 0.15 : 0.08;
  }

  /// Quiz option text color.
  Color quizOptionText({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (!hasAnswered) return onSurface;
    if (isCorrect) return success;
    if (isSelected) return error;
    return onSurface;
  }

  /// Quiz option leading letter circle surface.
  Color get quizOptionLetterCircleSurface => surface;

  /// Quiz option leading letter circle border.
  Color quizOptionLetterCircleBorder({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (hasAnswered && isCorrect) return success.withValues(alpha: 0.6);
    if (hasAnswered && isSelected) return error.withValues(alpha: 0.6);
    return primary.withValues(alpha: 0.4);
  }

  /// Quiz option leading letter color.
  Color quizOptionLetter({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    if (hasAnswered && isCorrect) return success;
    if (hasAnswered && isSelected) return error;
    return primary;
  }

  /// Quiz option idle trailing icon color.
  Color get quizOptionIdleIcon => brightness == Brightness.light
      ? primaryContainer
      : onSurface.withValues(alpha: 0.4);

  /// Quiz option trailing icon size.
  double get quizOptionIconSize => brightness == Brightness.light ? 24 : 28;

  /// Vocabulary quiz question card glass tint.
  Color get vocabularyQuizQuestionTint =>
      brightness == Brightness.light ? surface : primary;

  /// Vocabulary quiz question card glass tint opacity.
  double get vocabularyQuizQuestionTintOpacity =>
      brightness == Brightness.light ? 1.0 : 0.18;

  /// Vocabulary quiz question card border color.
  Color get vocabularyQuizQuestionBorder => brightness == Brightness.light
      ? primary.withValues(alpha: 0.1)
      : fixedWhite.withValues(alpha: 0.22);

  /// Vocabulary quiz main question foreground.
  Color get vocabularyQuizQuestionForeground =>
      brightness == Brightness.light ? primary : onSurface;

  /// Vocabulary quiz embedded meaning panel fill.
  Color get vocabularyQuizMeaningSurface => brightness == Brightness.light
      ? primary.withValues(alpha: 0.1)
      : surface.withValues(alpha: 0.4);

  /// Vocabulary quiz embedded meaning panel border.
  Border? get vocabularyQuizMeaningBorder => brightness == Brightness.light
      ? Border.all(color: primary.withValues(alpha: 0.2))
      : null;

  /// Vocabulary quiz English meaning foreground.
  Color get vocabularyQuizEnglishForeground => brightness == Brightness.light
      ? primary.withValues(alpha: 0.8)
      : onSurface.withValues(alpha: 0.8);
}

extension ThemeDataColorExtension on ThemeData {
  /// Quiz option border color. Uses ThemeData.dividerColor in dark mode to
  /// preserve the previous widget behavior exactly.
  Color quizOptionBorder({
    required bool hasAnswered,
    required bool isCorrect,
    required bool isSelected,
  }) {
    final cs = colorScheme;

    if (cs.brightness == Brightness.light) {
      if (!hasAnswered) {
        return isSelected ? cs.primary : cs.primaryContainer;
      }
      if (isCorrect) return cs.success.withValues(alpha: 0.4);
      if (isSelected) return cs.error.withValues(alpha: 0.4);
      return cs.primaryContainer;
    }

    if (!hasAnswered) {
      return isSelected ? cs.primary : dividerColor;
    }
    if (isCorrect) return cs.success;
    if (isSelected) return cs.error;
    return dividerColor;
  }
}
