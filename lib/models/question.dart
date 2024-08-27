class Question {
  final String id;
  final String text;
  final String type;
  final List<String>? options;
  List<Question>? subQuestions;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.subQuestions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options: List<String>.from(json['options'] ?? []),
      subQuestions: (json['subQuestions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'options': options,
      'subQuestions': subQuestions?.map((q) => q.toJson()).toList(),
    };
  }
}