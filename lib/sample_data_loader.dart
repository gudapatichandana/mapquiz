import 'quiz_question.dart';
import 'local_storage_service.dart';

class SampleDataLoader {
  static final List<QuizQuestion> sampleQuestions = [
    QuizQuestion(
      id: '1',
      text: 'What is the capital of France?',
      options: ['London', 'Paris', 'Berlin', 'Madrid'],
      answerIndex: 1,
      subject: 'Geography',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      id: '2',
      text: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
      answerIndex: 1,
      subject: 'Science',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      id: '3',
      text: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      answerIndex: 1,
      subject: 'Math',
      difficulty: 'Easy',
    ),
    QuizQuestion(
      id: '4',
      text: 'Who wrote "Romeo and Juliet"?',
      options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
      answerIndex: 1,
      subject: 'Literature',
      difficulty: 'Medium',
    ),
    QuizQuestion(
      id: '5',
      text: 'What is the chemical symbol for Gold?',
      options: ['Go', 'Gd', 'Au', 'Ag'],
      answerIndex: 2,
      subject: 'Science',
      difficulty: 'Medium',
    ),
  ];

  static Future<void> loadSampleData() async {
    final storage = LocalStorageService();
    await storage.init();
    
    final existingQuestions = storage.getQuizQuestions();
    if (existingQuestions.isEmpty) {
      await storage.saveQuizQuestions(sampleQuestions);
    }
  }
}