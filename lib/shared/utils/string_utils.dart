/// String utility extensions
extension StringNormalization on String {
  /// Converts full-width numbers (０-９) to half-width numbers (0-9).
  /// Also removes commas.
  String normalizeNumbers() {
    return replaceAllMapped(RegExp(r'[０-９]'), (match) {
      return String.fromCharCode(match.group(0)!.codeUnitAt(0) - 0xFEE0);
    }).replaceAll(',', '');
  }
}
