class UserResponse {
  final String id;
  final String questionId;
  final String? parentQuestionId;  
  final String userId;
  final dynamic answer;
  final DateTime timestamp;

  UserResponse({
    required this.id,
    required this.questionId,
    this.parentQuestionId, 
    required this.userId,
    required this.answer,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      questionId: json['questionId'],
      parentQuestionId: json['parentQuestionId'],
      userId: json['userId'],
      answer: json['answer'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'parentQuestionId': parentQuestionId,
      'userId': userId,
      'answer': answer,
      'timestamp': timestamp.toIso8601String(),
    };
  }



  // Override toString for easier debugging
  @override
  String toString() {
    return 'UserResponse(id: $id, questionId: $questionId, userId: $userId, answer: $answer, timestamp: $timestamp)';
  }

  // You might want to add methods to compare UserResponses or create copies with modifications
  UserResponse copyWith({
    String? id,
    String? questionId,
    String? userId,
    dynamic answer,
    DateTime? timestamp,
  }) {
    return UserResponse(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      answer: answer ?? this.answer,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}