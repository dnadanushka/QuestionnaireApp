import 'package:flutter/material.dart';
import '../models/question.dart';
import '../controllers/questionnaire_controller.dart';
import 'widgets/question_dialog.dart';

class QuestionnaireCreationScreen extends StatefulWidget {
  @override
  _QuestionnaireCreationScreenState createState() =>
      _QuestionnaireCreationScreenState();
}

class _QuestionnaireCreationScreenState
    extends State<QuestionnaireCreationScreen> {
  final QuestionnaireController _controller = QuestionnaireController();
  final TextEditingController _nameController = TextEditingController();
  List<Question> _questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Questionnaire'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveQuestionnaire,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _questions.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? Padding(
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
                )
              : _buildQuestionTile(_questions[index - 1], index - 1);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addQuestion(null),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuestionTile(Question question, int index,
      {bool isSubQuestion = false}) {
    return Card(
      margin: EdgeInsets.all(8).copyWith(left: isSubQuestion ? 32 : 8),
      child: Column(
        children: [
          ListTile(
            iconColor: Colors.purple,
            title: Text(question.text),
            subtitle: Text(question.type),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _editQuestion(index, isSubQuestion: isSubQuestion),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _deleteQuestion(index, isSubQuestion: isSubQuestion),
                ),
                if (!isSubQuestion)
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () => _addQuestion(index),
                  ),
              ],
            ),
          ),
          if (question.subQuestions != null &&
              question.subQuestions!.isNotEmpty)
            Column(
              children: question.subQuestions!.asMap().entries.map((entry) {
                return _buildQuestionTile(entry.value, entry.key,
                    isSubQuestion: true);
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _addQuestion(int? parentIndex) async {
    final result = await showDialog<Question>(
      context: context,
      builder: (context) => QuestionDialog(),
    );
    if (result != null) {
      setState(() {
        if (parentIndex == null) {
          _questions.add(result);
        } else {
          _questions[parentIndex].subQuestions ??= [];
          _questions[parentIndex].subQuestions!.add(result);
        }
      });
    }
  }

  void _editQuestion(int index, {bool isSubQuestion = false}) async {
    Question questionToEdit = isSubQuestion
        ? _questions[index].subQuestions![index]
        : _questions[index];
    final result = await showDialog<Question>(
      context: context,
      builder: (context) => QuestionDialog(question: questionToEdit),
    );
    if (result != null) {
      setState(() {
        if (isSubQuestion) {
          _questions[index].subQuestions![index] = result;
        } else {
          _questions[index] = result;
        }
      });
    }
  }

  void _deleteQuestion(int index, {bool isSubQuestion = false}) {
    setState(() {
      if (isSubQuestion) {
        _questions[index].subQuestions!.removeAt(index);
      } else {
        _questions.removeAt(index);
      }
    });
  }

  void _saveQuestionnaire() async {
    try {
      await _controller.createQuestionnaire(_questions, _nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questionnaire saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving questionnaire: $e')),
      );
    }
  }
}

