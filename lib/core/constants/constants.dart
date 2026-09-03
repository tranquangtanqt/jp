class Constants {
  // Prevents instantiation and extension
  Constants._();

  static const String selectedBrightnessKey = 'selected_brightness';

  static const double listTileFontSize = 13;

  // Non-critical error libraries that should be logged but not navigate to error screen
  static const nonCriticalErrorLibraries = {
    'image resource service',
  };

  // Non-critical platform error messages (no `library` info available) that should be
  // logged but not navigate to error screen, e.g. google_fonts failing to fetch a font
  // over the network still falls back to a usable text style, so it isn't fatal.
  static const nonCriticalErrorMessages = {
    'failed to load font',
  };

  static const String dateFormatDDMMYYYY = 'dd/MM/yyyy';
}
