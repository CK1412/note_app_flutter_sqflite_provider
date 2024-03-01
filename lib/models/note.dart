import 'package:flutter/material.dart';

const String noteTable = 'Note';

class NoteField {
  static const String id = '_id';
  static const String title = 'title';
  static const String content = 'content';
  static const String imagePaths = 'imagePaths';
  static const String bgColor = 'bgColor';
  static const String createdTime = 'createdTime';
  static const String label = 'label';
}

class Note {
  final int id;
  final String title;
  final String content;
  final String label;
  final List<String> imagePaths;
  final Color bgColor;
  final DateTime createdTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.label,
    required this.imagePaths,
    required this.bgColor,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json[NoteField.id] as int,
        title: json[NoteField.title].toString(),
        content: json[NoteField.content].toString(),
        createdTime: DateTime.parse(json[NoteField.createdTime].toString()),
        label: json[NoteField.label].toString(),
        imagePaths: json[NoteField.imagePaths].toString().isEmpty
            ? []
            : json[NoteField.imagePaths].toString().split('||'),
        bgColor: Color(json[NoteField.bgColor] as int),
      );

  Map<String, Object?> toJson() => {
        NoteField.id: id,
        NoteField.title: title,
        NoteField.content: content,
        NoteField.label: label,
        NoteField.bgColor: bgColor.value,
        NoteField.imagePaths: imagePaths.isEmpty ? '' : imagePaths.join('||'),
        NoteField.createdTime: createdTime.toIso8601String(),
      };

  Note copy({
    int? id,
    String? title,
    String? content,
    String? label,
    List<String>? imagePaths,
    Color? bgColor,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdTime: createdTime ?? this.createdTime,
        label: label ?? this.label,
        imagePaths: imagePaths ?? this.imagePaths,
        bgColor: bgColor ?? this.bgColor,
      );
}
