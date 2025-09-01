class AudioItem {
  final String id;
  final String categoryId;
  final String textKey;
  final String text;
  final String icon;
  final String type;
  bool isEnabled;

  AudioItem({
    required this.id,
    required this.categoryId,
    required this.textKey,
    required this.text,
    required this.icon,
    required this.type,
    this.isEnabled = true,
  });

  AudioItem copyWith({
    String? id,
    String? categoryId,
    String? textKey,
    String? text,
    String? icon,
    String? type,
    bool? isEnabled,
  }) {
    return AudioItem(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      textKey: textKey ?? this.textKey,
      text: text ?? this.text,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'textKey': textKey,
      'text': text,
      'icon': icon,
      'type': type,
      'isEnabled': isEnabled,
    };
  }

  factory AudioItem.fromJson(Map<String, dynamic> json) {
    return AudioItem(
      id: json['id'],
      categoryId: json['categoryId'],
      textKey: json['textKey'],
      text: json['text'],
      icon: json['icon'],
      type: json['type'],
      isEnabled: json['isEnabled'] ?? true,
    );
  }
}

class ParentalConfig {
  final List<AudioItem> enabledAudioItems;
  final bool isParentMode;
  final DateTime lastUpdated;
  final String voiceProfile; // 'male' | 'female' | 'child' (legacy)
  final String? selectedVoiceName; // Specific voice name
  final String? selectedVoiceLocale; // Specific voice locale
  final int communicationLevel; // 1: palavras, 2: frases curtas, 3: frases complexas

  ParentalConfig({
    required this.enabledAudioItems,
    this.isParentMode = false,
    required this.lastUpdated,
    this.voiceProfile = 'female',
    this.selectedVoiceName,
    this.selectedVoiceLocale,
    this.communicationLevel = 1,
  });

  ParentalConfig copyWith({
    List<AudioItem>? enabledAudioItems,
    bool? isParentMode,
    DateTime? lastUpdated,
    String? voiceProfile,
    String? selectedVoiceName,
    String? selectedVoiceLocale,
    int? communicationLevel,
  }) {
    return ParentalConfig(
      enabledAudioItems: enabledAudioItems ?? this.enabledAudioItems,
      isParentMode: isParentMode ?? this.isParentMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      voiceProfile: voiceProfile ?? this.voiceProfile,
      selectedVoiceName: selectedVoiceName ?? this.selectedVoiceName,
      selectedVoiceLocale: selectedVoiceLocale ?? this.selectedVoiceLocale,
      communicationLevel: communicationLevel ?? this.communicationLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabledAudioItems': enabledAudioItems.map((item) => item.toJson()).toList(),
      'isParentMode': isParentMode,
      'lastUpdated': lastUpdated.toIso8601String(),
      'voiceProfile': voiceProfile,
      'selectedVoiceName': selectedVoiceName,
      'selectedVoiceLocale': selectedVoiceLocale,
      'communicationLevel': communicationLevel,
    };
  }

  factory ParentalConfig.fromJson(Map<String, dynamic> json) {
    return ParentalConfig(
      enabledAudioItems: (json['enabledAudioItems'] as List)
          .map((item) => AudioItem.fromJson(item))
          .toList(),
      isParentMode: json['isParentMode'] ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      voiceProfile: json['voiceProfile'] ?? 'female',
      selectedVoiceName: json['selectedVoiceName'],
      selectedVoiceLocale: json['selectedVoiceLocale'],
      communicationLevel: json['communicationLevel'] ?? 1,
    );
  }
}
