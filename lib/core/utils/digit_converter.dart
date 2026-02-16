/// Converts Arabic-Eastern digits (٠١٢٣٤٥٦٧٨٩) to Western digits (0123456789).
///
/// Use this extension on any formatted string to ensure digits are always
/// displayed in Western format, regardless of the app locale.
extension WesternDigits on String {
  /// Replaces any Arabic-Eastern numerals with their Western equivalents.
  String get w {
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var result = this;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(eastern[i], western[i]);
    }
    return result;
  }
}
