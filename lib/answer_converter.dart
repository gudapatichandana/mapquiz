import 'quiz_history.dart';
import 'quiz_result.dart';

class AnswerConverter {
  static QuizAnswer userAnswerToQuizAnswer(UserAnswer userAnswer) {
    return QuizAnswer(
      questionId: userAnswer.questionId,
      questionText: userAnswer.questionText,
      selectedIndex: userAnswer.selectedIndex,
      correctIndex: userAnswer.correctIndex,
      options: userAnswer.options,
    );
  }

  static List<QuizAnswer> userAnswersToQuizAnswers(List<UserAnswer> userAnswers) {
    return userAnswers.map((userAnswer) => userAnswerToQuizAnswer(userAnswer)).toList();
  }

  static UserAnswer quizAnswerToUserAnswer(QuizAnswer quizAnswer) {
    return UserAnswer(
      questionId: quizAnswer.questionId,
      questionText: quizAnswer.questionText,
      selectedIndex: quizAnswer.selectedIndex,
      correctIndex: quizAnswer.correctIndex,
      options: quizAnswer.options,
    );
  }

  static List<UserAnswer> quizAnswersToUserAnswers(List<QuizAnswer> quizAnswers) {
    return quizAnswers.map((quizAnswer) => quizAnswerToUserAnswer(quizAnswer)).toList();
  }
}