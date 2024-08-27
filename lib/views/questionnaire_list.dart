import 'package:flutter/material.dart';
import 'package:newapp/controllers/questionnaire_controller.dart';
import 'package:newapp/controllers/response_controller.dart';
import 'package:newapp/models/questionnaire.dart';
import 'package:newapp/models/user_response.dart';
import 'package:newapp/views/answering_screen.dart';
import 'package:newapp/views/report_screen.dart';

class QuestionnaireListScreen extends StatefulWidget {
  final List<Questionnaire> questionnaires;

  const QuestionnaireListScreen({Key? key, required this.questionnaires})
      : super(key: key);

  @override
  _QuestionnaireListScreenState createState() =>
      _QuestionnaireListScreenState();
}

class _QuestionnaireListScreenState extends State<QuestionnaireListScreen> {
  final QuestionnaireController _controller = QuestionnaireController();
  final ResponseController _responseController = ResponseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Answer Questionnaire')),
      body: ListView.builder(
        itemCount: widget.questionnaires.length,
        itemBuilder: (context, index) {
          return ListTile(
            iconColor: Colors.purple,
            title: Text(widget.questionnaires[index].name == ''
                ? 'Untitled Questionnaire'
                : widget.questionnaires[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.question_answer),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnsweringScreen(
                            questions: widget.questionnaires[index].questions!,
                            qid: widget.questionnaires[index].id),
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.insights),
                  onPressed: () => _navigateReportScreen(
                      context, widget.questionnaires[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Navigate to the ReportScreen with the given questionnaire and its responses.
  ///
  /// Shows a loading indicator while fetching the responses.
  ///
  /// If the fetching is successful and there are responses available, navigates to the ReportScreen.
  /// If there are no responses available, shows an error message.
  ///
  /// If there is an error while fetching the responses, shows an error message.
  void _navigateReportScreen(BuildContext context, Questionnaire quizz) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Fetch questionnaire data
      List<UserResponse> userResponses =
          await _responseController.getResponsesForQuestionnaire(quizz.id);

      // Hide loading indicator
      Navigator.pop(context);

      if (userResponses.isNotEmpty) {
        // Navigate to AnsweringScreen with fetched questions
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReportScreen(quiz: quizz, responseList: userResponses),
            ));
      } else {
        // Show an error message if no questionnaire is available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('No Responses available. Please create one first.')),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching questionnaire: $e')),
      );
    }
  }
}
