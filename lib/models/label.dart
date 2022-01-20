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

  static Label fromJson(Map<String, Object?> json) => Label(
        id: json[LabelField.id] as int,
        title: json[LabelField.title].toString(),
      );

  Map<String, Object?> toJson() => {
        LabelField.id: id,
        LabelField.title: title,
      };

  Label copy({int? id, String? title}) => Label(
        id: id ?? this.id,
        title: title ?? this.title,
      );
}
