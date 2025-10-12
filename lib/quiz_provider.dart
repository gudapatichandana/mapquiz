import 'package:flutter/material.dart';
import 'dart:async';
import 'quiz_question.dart';
import 'quiz_result.dart';
import 'quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _quizService = QuizService();

  List<QuizQuestion> _questions = [];
  List<int> _userAnswers = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _error;
  Timer? _timer;
  Duration _timeRemaining = const Duration(minutes: 10);
  Duration _totalTime = const Duration(minutes: 10);
  bool _quizCompleted = false;
  String _currentSubject = '';

  // Getters
  List<QuizQuestion> get questions => _questions;
  List<int> get userAnswers => _userAnswers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Duration get timeRemaining => _timeRemaining;
  Duration get totalTime => _totalTime;
  bool get quizCompleted => _quizCompleted;
  String get currentSubject => _currentSubject;

  QuizQuestion? get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }

  bool get hasNextQuestion => _currentQuestionIndex < _questions.length - 1;
  bool get hasPreviousQuestion => _currentQuestionIndex > 0;

  int get progress => _questions.isEmpty ? 0 : _currentQuestionIndex + 1;
  double get progressPercentage => _questions.isEmpty
      ? 0.0
      : (_currentQuestionIndex + 1) / _questions.length;

  Future<void> startQuiz(String subject) async {
    _isLoading = true;
    _error = null;
    _currentSubject = subject;
    notifyListeners();

    try {
      _questions = await _quizService.generateQuiz(subject);
      _userAnswers = List.filled(_questions.length, -1);
      _currentQuestionIndex = 0;
      _quizCompleted = false;

      // Set timer based on subject
      final minutes = _getTimerMinutes(subject);
      _totalTime = Duration(minutes: minutes);
      _timeRemaining = _totalTime;

      _startTimer();
    } catch (e) {
      _error = 'Failed to load quiz: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _getTimerMinutes(String subject) {
    switch (subject.toLowerCase()) {
      case 'aptitude':
      case 'hr':
        return 15;
      case 'dsa':
      case 'algorithms':
        return 12;
      case 'dbms':
      case 'database':
        return 10;
      case 'operating systems':
      case 'os':
        return 10;
      case 'computer networks':
      case 'networking':
        return 8;
      case 'oop':
      case 'object oriented':
        return 8;
      case 'daily quiz':
        return 10;
      default:
        return 10;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds > 0) {
        _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
        notifyListeners();
      } else {
        _completeQuiz();
      }
    });
  }

  void answerQuestion(int answerIndex) {
    if (_currentQuestionIndex < _userAnswers.length) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      _completeQuiz();
    }
  }

  void previousQuestion() {
    if (hasPreviousQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void _completeQuiz() {
    _timer?.cancel();
    _quizCompleted = true;
    notifyListeners();
  }

  void submitQuiz() {
    _completeQuiz();
  }

  QuizResult getResult() {
    int correctAnswers = 0;
    List<UserAnswer> userAnswerDetails = [];

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = i < _userAnswers.length ? _userAnswers[i] : -1;

      if (userAnswer == question.answerIndex) {
        correctAnswers++;
      }

      userAnswerDetails.add(UserAnswer(
        questionId: question.id,
        questionText: question.text,
        selectedIndex: userAnswer,
        correctIndex: question.answerIndex,
        options: question.options,
      ));
    }

    final timeTaken = Duration(
      seconds: _totalTime.inSeconds - _timeRemaining.inSeconds,
    );

    return QuizResult(
      quizId: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      subject: _currentSubject,
      score: correctAnswers,
      totalQuestions: _questions.length,
      timeTaken: timeTaken,
      totalTime: _totalTime,
      userAnswers: userAnswerDetails,
      completedAt: DateTime.now(),
    );
  }

  void resetQuiz() {
    try {
      _timer?.cancel();
      _timer = null;

      _questions.clear();
      _userAnswers.clear();
      _currentQuestionIndex = 0;
      _quizCompleted = false;
      _error = null;
      _currentSubject = '';
      _timeRemaining = const Duration(minutes: 10);
      _totalTime = const Duration(minutes: 10);
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error during quiz reset: $e');
      _timer?.cancel();
      _timer = null;
      _quizCompleted = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}