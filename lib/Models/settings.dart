class Settings {
  final String languageCode;
  final bool enableSound;

  Settings({
    required this.languageCode,
    required this.enableSound,
  });

  Settings copyWith({
    String? languageCode,
    bool? enableSound,
  }) {
    return Settings(
      languageCode: languageCode ?? this.languageCode,
      enableSound: enableSound ?? this.enableSound,
    );
  }

  Map<String, dynamic> toJson() => {
    'languageCode': languageCode,
    'enableSound': enableSound,
  };

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    languageCode: json['languageCode'] ?? 'en',
    enableSound: json['enableSound'] ?? true,
  );
}
