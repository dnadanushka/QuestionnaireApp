import 'package:flutter/material.dart';
import '../models/question.dart';
import '../controllers/response_controller.dart';

import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/user_response.dart';
import '../controllers/response_controller.dart';
import 'widgets/multichoice_widget.dart';
import 'widgets/single_choice_widget.dart';
import 'widgets/text_input_widget.dart';

class AnsweringScreen extends StatefulWidget {
  final List<Question> questions;
  final String qid;

  const AnsweringScreen({Key? key, required this.questions, required this.qid}) : super(key: key);

  @override
  _AnsweringScreenState createState() => _AnsweringScreenState();
}

class _AnsweringScreenState extends State<AnsweringScreen> {
  final ResponseController _controller = ResponseController();
  final Map<String, UserResponse> _responses = {};
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Answer Questionnaire')),
      body: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.questions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Enter your name here',
        filled: true,
        fillColor: Colors.grey[200],
      ),
              ),
            );
          }
          return _buildQuestionWidget(widget.questions[index-1]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitResponses,
        child: Icon(Icons.send),
      ),
    );
  }

  /// Builds a widget for a single question, with its answer widget and
  /// sub questions.
  ///
  /// If [parentId] is not null, it will be used to determine the left margin
  /// of the card.
  ///
  /// The answer widget is determined by the type of the question.
  ///
  /// The sub questions are displayed recursively, with their own answer widget
  /// and sub questions.
  ///
  /// Returns a [Card] widget with the question text and the answer widget.
  Widget _buildQuestionWidget(Question question, {String? parentId}) {
    return Card(
      margin: EdgeInsets.all(8).copyWith(left: parentId != null ? 32 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              question.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildAnswerWidget(question, parentId),
          if (question.subQuestions != null && question.subQuestions!.isNotEmpty)
            ...question.subQuestions!.map((subQuestion) => _buildQuestionWidget(subQuestion, parentId: question.id)),
        ],
      ),
    );
  }

  /// Builds a widget for answering a question based on its type.
  ///
  /// It takes a [Question] object and an optional [parentId] as parameters.
  /// The [parentId] is used to determine the parent question of the current question.
  /// 
  /// Returns a widget that allows the user to answer the question. The type of the widget
  /// depends on the type of the question. It can be a [SingleChoiceWidget], a [MultipleChoiceWidget],
  /// or a [TextInputWidget].
  Widget _buildAnswerWidget(Question question, String? parentId) {
    switch (question.type) {
      case 'single_choice':
        return SingleChoiceWidget(
          options: question.options!,
          onSelected: (value) => _onAnswered(question.id, value, parentId),
        );
      case 'multiple_choice':
        return MultipleChoiceWidget(
          options: question.options!,
          onChanged: (value) => _onAnswered(question.id, value, parentId),
        );
      default:
        return TextInputWidget(
          onChanged: (value) => _onAnswered(question.id, value, parentId),
        );
    
    }
  }
  /// Handles the response to a question.
///
/// It takes a [questionId], an [answer], and an optional [parentId] as parameters.
/// The [questionId] is used to identify the question being answered.
/// The [answer] is the user's response to the question.
/// The [parentId] is used to determine the parent question of the current question, if any.
///
/// Updates the [_responses] map with the user's response.
void _onAnswered(String questionId, dynamic answer, String? parentId) {
  setState(() {
    _responses[questionId] = UserResponse(
      id: DateTime.now().toString(),
      questionId: questionId,
      parentQuestionId: parentId,
      userId: 'id', 
      answer: answer,
    );
  });
}

/// Submits the user's responses to the controller.
///
/// This function takes no parameters and returns no value. It uses the `_responses` map to 
/// compile a list of valid `UserResponse` objects, which are then submitted to the controller.
/// If the submission is successful, a success message is displayed and the current screen is popped.
/// If an error occurs during submission, an error message is displayed.
void _submitResponses() async {
  try {
    List<UserResponse> responses = _responses.values
        .where((response) => response is UserResponse)
        .map((response) => response as UserResponse)
        .toList();
    
    if (responses.isEmpty) {
      throw Exception('No valid responses to submit');
    }

    await _controller.submitResponses(responses,widget.qid,_nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Responses submitted successfully')),
    );
    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting responses: $e')),
    );
  }
}
}





