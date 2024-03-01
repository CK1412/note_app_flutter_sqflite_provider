const String labelTable = 'Label';

class LabelField {
  static const String id = '_id';
  static const String title = 'title';
}

class Label {
  final int? id;
  final String title;

  Label({
    this.id,
    required this.title,
  });

  factory Label.fromJson(Map<String, dynamic> map) {
    return Label(
      id: map[LabelField.id] as int,
      title: map[LabelField.title] as String,
    );
  }

  Map<String, Object?> toJson() => {
        LabelField.id: id,
        LabelField.title: title,
      };

  Label copy({int? id, String? title}) => Label(
        id: id ?? this.id,
        title: title ?? this.title,
      );
}
