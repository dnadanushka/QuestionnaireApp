import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/models/questionnaire.dart';
import '../models/question.dart';
import '../models/user_response.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new questionnaire in the Firestore database.
  Future<void> createQuestionnaire(
      List<Question> questions, String name) async {
    try {
      await _firestore.collection('questionnaires').add({
        'questions': questions.map((q) => q.toJson()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'name': name,
      });
    } catch (e) {
      print('Error creating questionnaire: $e');
      rethrow;
    }
  }

  /// Retrieves a stream of questionnaires from the Firestore database. getQuestionnaires() {
  Future<List<Questionnaire>> getAllQuestionnaires() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('questionnaires')
          .orderBy('createdAt', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
       
        List<Questionnaire> questionnaireList = querySnapshot.docs.map((q) {
         Map<String, dynamic> json = q.data() as Map<String, dynamic>;
         json.addAll({'id':q.id});
          return Questionnaire.fromJson(json);
        }).toList();
        return questionnaireList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting All questionnaire: $e');
      rethrow;
    }
  }

  /// Submits a list of responses to the Firestore database.
  Future<void> submitResponses(List<Map<String, dynamic>> responses,String qid,String name) async {
    try {
      // Create a new document in the 'responses' collection with all the responses
      await _firestore.collection('responses').add({
        'responses': responses,
        'qid': qid,
        'name': name,
        'submittedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error submitting responses to Firebase: $e');
      rethrow;
    }
  }

  /// Retrieves a list of responses for a user from the Firestore database.
  Future<List<UserResponse>> getResponsesForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('responses')
          .where('responses.userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.expand((doc) {
        List<dynamic> responsesList = doc['responses'];
        return responsesList.map((r) => UserResponse.fromJson(r));
      }).toList();
    } catch (e) {
      print('Error getting responses for user from Firebase: $e');
      rethrow;
    }
  }

  /// Retrieves a list of responses for a questionnaire from the Firestore database.
  Future<List<UserResponse>> getResponsesForQuestionnaire(
      String questionnaireId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('responses')
          .where('qid', isEqualTo: questionnaireId)
          .get();

      return querySnapshot.docs.expand((doc) {
        List<dynamic> responsesList = doc['responses'];
        return responsesList.map((r) => UserResponse.fromJson(r));
      }).toList();
    } catch (e) {
      print('Error getting responses for questionnaire from Firebase: $e');
      rethrow;
    }
  }

  /// Retrieves the latest questionnaire from the Firestore database.
  Future<List<Question>> getLatestQuestionnaire() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('questionnaires')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        List<dynamic> questionsList = data['questions'];
        return questionsList.map((q) => Question.fromJson(q)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting latest questionnaire: $e');
      rethrow;
    }
  }
}
