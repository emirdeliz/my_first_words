class CommunicationItem {
  final String id;
  final String categoryId;
  final String textKey;
  final String text;
  final String icon;
  final String type;
  final bool isEnabled;

  CommunicationItem({
    required this.id,
    required this.categoryId,
    required this.textKey,
    required this.text,
    required this.icon,
    required this.type,
    this.isEnabled = true,
  });

  factory CommunicationItem.fromJson(Map<String, dynamic> json) {
    return CommunicationItem(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      textKey: json['textKey'] ?? '',
      text: json['text'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? '',
      isEnabled: json['isEnabled'] ?? true,
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

  CommunicationItem copyWith({
    String? id,
    String? categoryId,
    String? textKey,
    String? text,
    String? icon,
    String? type,
    bool? isEnabled,
  }) {
    return CommunicationItem(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      textKey: textKey ?? this.textKey,
      text: text ?? this.text,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
