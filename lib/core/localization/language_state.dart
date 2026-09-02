class LanguageState {
  final String languageCode; // 'en', 'hi', 'mr'
  final Map<String, String> dynamicTranslations;

  const LanguageState({
    required this.languageCode,
    required this.dynamicTranslations,
  });

  factory LanguageState.initial() {
    return const LanguageState(
      languageCode: 'en',
      dynamicTranslations: {},
    );
  }

  LanguageState copyWith({
    String? languageCode,
    Map<String, String>? dynamicTranslations,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
      dynamicTranslations: dynamicTranslations ?? this.dynamicTranslations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageState &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode &&
          dynamicTranslations == other.dynamicTranslations;

  @override
  int get hashCode => languageCode.hashCode ^ dynamicTranslations.hashCode;
}
