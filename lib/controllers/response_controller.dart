import '../models/user_response.dart';
import '../services/firebase_service.dart';

class ResponseController {
  final FirebaseService _firebaseService = FirebaseService();

 Future<void> submitResponses(List<UserResponse> responses,qid,name) async {
    try {
      // Convert the list of UserResponse objects to a list of maps
      List<Map<String, dynamic>> responseMaps = responses.map((response) => response.toJson()).toList();
      await _firebaseService.submitResponses(responseMaps,qid,name);
    } catch (e) {
      print('Error submitting responses: $e');
      rethrow;
    }
  }

  Future<List<UserResponse>> getResponsesForUser(String userId) async {
    try {
      return await _firebaseService.getResponsesForUser(userId);

    } catch (e) {
      print('Error getting responses for user: $e');
      rethrow;
    }
  }

  Future<List<UserResponse>> getResponsesForQuestionnaire(String questionnaireId) async {
    try {
      return await _firebaseService.getResponsesForQuestionnaire(questionnaireId);
   
    } catch (e) {
      print('Error getting responses for questionnaire: $e');
      rethrow;
    }
  }

}