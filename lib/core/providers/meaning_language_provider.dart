import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for meaning language preference
enum MeaningLanguage {
  burmese('Burmese Only'),
  english('English Only');

  final String label;
  const MeaningLanguage(this.label);
}

/// Provider for meaning language preference
/// Default is Burmese
final meaningLanguageProvider = StateProvider<MeaningLanguage>((ref) {
  return MeaningLanguage.burmese;
});
