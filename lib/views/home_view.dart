import 'package:flutter/material.dart';
import 'package:newapp/models/questionnaire.dart';
import 'package:newapp/views/questionnaire_list.dart';
import 'questionnaire_creation_screen.dart';
import 'answering_screen.dart';
import 'report_screen.dart';
import '../controllers/questionnaire_controller.dart';
import '../models/question.dart';

class HomeScreen extends StatelessWidget {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    'Create Questionnaire ⁉️',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionnaireCreationScreen()),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    'Questionnaire List 📋',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _navigateToAllQuestionnaireScreen(context),
                ),
              ),
              
            
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAllQuestionnaireScreen(BuildContext context) async {
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
      List<Questionnaire> questionnaires =
          await _questionnaireController.getQuestionnaireList();

      // Hide loading indicator
      Navigator.pop(context);

      if (questionnaires.isNotEmpty) {
        // Navigate to AnsweringScreen with fetched questions
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuestionnaireListScreen(questionnaires: questionnaires),
            ));
      } else {
        // Show an error message if no questionnaire is available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No questionnaires available. Please create one first.')),
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
