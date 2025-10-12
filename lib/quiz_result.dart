import 'quiz_history.dart';
class QuizResult {
  final String quizId;
  final String subject;
  final int score;
  final int totalQuestions;
  final Duration timeTaken;
  final Duration totalTime;
  final List<UserAnswer> userAnswers;
  final DateTime completedAt;

  QuizResult({
    required this.quizId,
    required this.subject,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.totalTime,
    required this.userAnswers,
    required this.completedAt,
  });

  double get percentage => totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  // Convert to QuizHistory
  QuizHistory toQuizHistory({int pointsEarned = 0}) {
    return QuizHistory(
      id: quizId,
      subject: subject,
      score: score,
      totalQuestions: totalQuestions,
      timeTaken: timeTaken,
      totalTime: totalTime,
      completedAt: completedAt,
      difficulty: 'Medium',
      pointsEarned: pointsEarned,
      answers: userAnswers.map((userAnswer) => 
        QuizAnswer(
          questionId: userAnswer.questionId,
          questionText: userAnswer.questionText,
          selectedIndex: userAnswer.selectedIndex,
          correctIndex: userAnswer.correctIndex,
          options: userAnswer.options,
        )
      ).toList(),
    );
  }
}

class UserAnswer {
  final String questionId;
  final String questionText;
  final int selectedIndex;
  final int correctIndex;
  final List<String> options;

  UserAnswer({
    required this.questionId,
    required this.questionText,
    required this.selectedIndex,
    required this.correctIndex,
    required this.options,
  });

  bool get isCorrect => selectedIndex == correctIndex;
  
  String get selectedAnswer =>
      selectedIndex >= 0 && selectedIndex < options.length
          ? options[selectedIndex]
          : 'Not answered';

  String get correctAnswer => correctIndex >= 0 && correctIndex < options.length
      ? options[correctIndex]
      : 'Unknown';
}