import 'package:flutter/material.dart';
import 'user_model.dart';
import 'quiz_history.dart';
import 'quiz_result.dart';
import 'local_storage_service.dart';
import 'constants.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class UserProgressProvider with ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  final Uuid _uuid = const Uuid();

  UserModel? _currentUser;
  List<QuizHistory> _recentQuizzes = [];
  Map<String, List<QuizHistory>> _subjectHistory = {};

  // Getters
  UserModel? get currentUser => _currentUser;
  List<QuizHistory> get recentQuizzes => _recentQuizzes;
  Map<String, List<QuizHistory>> get subjectHistory => _subjectHistory;

  // Initialize with user
  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    await _storageService.init();
    
    // Load user's quiz history from local storage
    _recentQuizzes = await _storageService.getUserQuizHistory(user.id);
    _recentQuizzes.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    _loadUserProgress();
    notifyListeners();
  }

  // Load user progress from storage
  void _loadUserProgress() {
    if (_currentUser == null) return;

    _recentQuizzes = List<QuizHistory>.from(_currentUser!.quizHistory)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    // Group by subject
    _subjectHistory.clear();
    for (final quiz in _currentUser!.quizHistory) {
      if (!_subjectHistory.containsKey(quiz.subject)) {
        _subjectHistory[quiz.subject] = [];
      }
      _subjectHistory[quiz.subject]!.add(quiz);
    }

    // Sort each subject's history
    _subjectHistory.forEach((subject, quizzes) {
      quizzes.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    });
  }

  // Add quiz result and update user progress
  Future<void> addQuizResult(QuizResult result) async {
    if (_currentUser == null) return;

    try {
      // Calculate points first
      final pointsEarned = _calculatePoints(result);
      
      // Convert QuizResult to QuizHistory using the toQuizHistory method
      final quizHistory = result.toQuizHistory(pointsEarned: pointsEarned);

      // Check if this quiz already exists in user's history
      final existingQuizIndex = _currentUser!.quizHistory.indexWhere(
        (quiz) => quiz.id == quizHistory.id
      );

      if (existingQuizIndex != -1) {
        print('Quiz ${quizHistory.id} already exists in user history, skipping');
        return;
      }

      // Save to local storage
      await _storageService.saveQuizHistory(quizHistory);

      // Update user progress
      final updatedUser = _currentUser!.copyWith(
        quizzesCompleted: _currentUser!.quizzesCompleted + 1,
        totalPoints: _currentUser!.totalPoints + pointsEarned,
        quizHistory: [..._currentUser!.quizHistory, quizHistory],
      );

      // Update subject scores
      final subjectScores = Map<String, int>.from(updatedUser.subjectScores);
      subjectScores[result.subject] = (subjectScores[result.subject] ?? 0) + result.score;
      updatedUser.subjectScores = subjectScores;

      // Update streak
      updatedUser.updateStreak();

      // Check for new achievements
      _checkAchievements(updatedUser);

      // Save updated user
      await _storageService.saveUser(updatedUser);
      _currentUser = updatedUser;

      // Update recent quizzes - ensure no duplicates
      final newRecentQuizzes = [quizHistory, ..._recentQuizzes];
      final seenIds = <String>{};
      _recentQuizzes = newRecentQuizzes.where((quiz) {
        if (seenIds.contains(quiz.id)) {
          return false;
        } else {
          seenIds.add(quiz.id);
          return true;
        }
      }).take(10).toList();

      // Reload progress
      _loadUserProgress();
      
      notifyListeners();
    } catch (e) {
      print('Error adding quiz result: $e');
    }
  }

  // Calculate points based on quiz performance
  int _calculatePoints(QuizResult result) {
    int basePoints = 10; // Base points

    // Bonus for accuracy
    if (result.percentage >= 90) {
      basePoints += 20;
    } else if (result.percentage >= 80) {
      basePoints += 15;
    } else if (result.percentage >= 70) {
      basePoints += 10;
    }

    // Bonus for speed (completed in less than 80% of total time)
    final timePercentage = (result.timeTaken.inSeconds / result.totalTime.inSeconds) * 100;
    if (timePercentage <= 80) {
      basePoints += 5;
    }

    // Perfect score bonus
    if (result.percentage == 100) {
      basePoints += 10;
    }

    return basePoints;
  }

  // Check and unlock achievements
  void _checkAchievements(UserModel user) {
    final achievements = <String>[];

    // First quiz achievement
    if (user.quizzesCompleted == 1 &&
        !user.hasAchievement('first_quiz')) {
      achievements.add('first_quiz');
    }

    // Quiz streak achievements
    if (user.currentStreak >= 7 &&
        !user.hasAchievement('week_streak')) {
      achievements.add('week_streak');
    }
    if (user.currentStreak >= 30 &&
        !user.hasAchievement('month_streak')) {
      achievements.add('month_streak');
    }

    // Points achievements
    if (user.totalPoints >= 1000 &&
        !user.hasAchievement('points_1000')) {
      achievements.add('points_1000');
    }
    if (user.totalPoints >= 5000 &&
        !user.hasAchievement('points_5000')) {
      achievements.add('points_5000');
    }

    // Quiz count achievements
    if (user.quizzesCompleted >= 10 &&
        !user.hasAchievement('quiz_master_10')) {
      achievements.add('quiz_master_10');
    }
    if (user.quizzesCompleted >= 50 &&
        !user.hasAchievement('quiz_master_50')) {
      achievements.add('quiz_master_50');
    }

    // Subject mastery achievements
    for (final entry in user.subjectScores.entries) {
      final subject = entry.key.toLowerCase().replaceAll(' ', '_');
      final achievementId = '${subject}_master';
      if (entry.value >= 4 && !user.hasAchievement(achievementId)) {
        achievements.add(achievementId);
      }
    }

    // Perfect score achievement
    final perfectQuizzes = user.quizHistory.where((quiz) => quiz.percentage == 100);
    if (perfectQuizzes.length >= 5 && !user.hasAchievement('perfectionist')) {
      achievements.add('perfectionist');
    }

    // Add new achievements
    for (final achievement in achievements) {
      user.addAchievement(achievement);
    }
  }

  // Get progress statistics
  Map<String, dynamic> getProgressStats() {
    if (_currentUser == null) return {};

    final user = _currentUser!;
    
    // Calculate subject performance
    final subjectPerformance = <String, double>{};
    final subjectQuizzes = <String, List<QuizHistory>>{};
    
    for (final quiz in user.quizHistory) {
      subjectQuizzes.putIfAbsent(quiz.subject, () => []).add(quiz);
    }
    
    for (final entry in subjectQuizzes.entries) {
      if (entry.value.isNotEmpty) {
        final totalPercentage = entry.value.fold(0.0, (sum, quiz) => sum + quiz.percentage);
        final averageScore = totalPercentage / entry.value.length;
        subjectPerformance[entry.key] = averageScore;
      }
    }

    return {
      'totalPoints': user.totalPoints,
      'quizzesCompleted': user.quizzesCompleted,
      'averageScore': user.averageScore,
      'currentStreak': user.currentStreak,
      'bestStreak': user.bestStreak,
      'subjectPerformance': subjectPerformance,
    };
  }

  // Get subject-specific statistics
  Map<String, dynamic> getSubjectStats(String subject) {
    final quizzes = _subjectHistory[subject] ?? [];
    if (quizzes.isEmpty) return {};

    final averageScore = quizzes.fold(0.0, (sum, quiz) => sum + quiz.percentage) / quizzes.length;
    final bestScore = quizzes.map((quiz) => quiz.percentage).reduce((a, b) => a > b ? a : b);
    final totalTime = quizzes.fold(Duration.zero, (sum, quiz) => sum + quiz.timeTaken);
    final totalPoints = quizzes.fold(0, (sum, quiz) => sum + quiz.pointsEarned);

    return {
      'averageScore': averageScore,
      'bestScore': bestScore,
      'totalQuizzes': quizzes.length,
      'totalTime': totalTime,
      'totalPoints': totalPoints,
      'recentQuizzes': quizzes.take(5).toList(),
    };
  }

  // Clear user progress
  void clearUser() {
    _currentUser = null;
    _recentQuizzes.clear();
    _subjectHistory.clear();
    notifyListeners();
  }
}