import 'package:newapp/models/question.dart';

class Questionnaire {
  final String createdAt;
  final String id;
  final String name;
  final List<Question>? questions;

  Questionnaire({
    required this.createdAt,
    required this.name,
    required this.id,
    required this.questions,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      createdAt: json['createdAt'].toString(),
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}