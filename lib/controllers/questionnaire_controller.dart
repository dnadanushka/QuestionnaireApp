import 'package:newapp/models/questionnaire.dart';

import '../models/question.dart';
import '../services/firebase_service.dart';

class QuestionnaireController {
  final FirebaseService _firebaseService = FirebaseService();

  /// Creates a new questionnaire in the Firestore database.
  ///
  /// Parameters:
  ///   questions (List<Question>): A list of questions to be added to the questionnaire.
  ///
  /// Returns:
  ///   Future<void>: A future that completes when the questionnaire has been successfully created.
  ///
  /// Throws:
  ///   Exception: If an error occurs while creating the questionnaire.
  Future<void> createQuestionnaire(List<Question> questions, String name) async {
    await _firebaseService.createQuestionnaire(questions,name);
  }

    Future<List<Questionnaire>> getQuestionnaireList() async {
    try {
      return await _firebaseService.getAllQuestionnaires();
    } catch (e) {
      print('Error getting latest questionnaire: $e');
      rethrow;
    }
  }

     Future<List<Question>> getLatestQuestionnaire() async {
    try {
      return await _firebaseService.getLatestQuestionnaire();
    } catch (e) {
      print('Error getting latest questionnaire: $e');
      rethrow;
    }
  }
}