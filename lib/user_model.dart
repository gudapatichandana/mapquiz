import 'package:hive/hive.dart';
import 'quiz_history.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String email;
  
  @HiveField(2)
  String name;
  
  @HiveField(3)
  int totalPoints;
  
  @HiveField(4)
  int quizzesCompleted;
  
  @HiveField(5)
  List<QuizHistory> quizHistory;
  
  @HiveField(6)
  Map<String, int> subjectScores;
  
  @HiveField(7)
  List<String> achievements;
  
  @HiveField(8)
  DateTime createdAt;
  
  @HiveField(9)
  DateTime lastLoginAt;
  
  @HiveField(10)
  String? profilePicture;
  
  @HiveField(11)
  int currentStreak;
  
  @HiveField(12)
  int bestStreak;
  
  @HiveField(13)
  DateTime? lastQuizDate;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.totalPoints = 0,
    this.quizzesCompleted = 0,
    List<QuizHistory>? quizHistory,
    Map<String, int>? subjectScores,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    this.profilePicture,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastQuizDate,
  })  : quizHistory = quizHistory ?? [],
        subjectScores = subjectScores ?? {},
        achievements = achievements ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastLoginAt = lastLoginAt ?? DateTime.now();

  // Calculate average score
  double get averageScore {
    if (quizHistory.isEmpty) return 0.0;

    int totalScore = quizHistory.fold(0, (sum, quiz) => sum + quiz.score);
    int totalQuestions =
        quizHistory.fold(0, (sum, quiz) => sum + quiz.totalQuestions);

    return totalQuestions > 0 ? (totalScore / totalQuestions) * 100 : 0.0;
  }

  // Get best score for a specific subject
  double getBestScore(String subject) {
    final subjectQuizzes = quizHistory.where((quiz) => quiz.subject == subject);
    if (subjectQuizzes.isEmpty) return 0.0;

    return subjectQuizzes
        .map((quiz) => quiz.percentage)
        .reduce((a, b) => a > b ? a : b);
  }

  // Get total time spent on quizzes
  Duration get totalTimeSpent {
    return quizHistory.fold(
      Duration.zero,
      (total, quiz) => total + quiz.timeTaken,
    );
  }

  // Check if user has achievement
  bool hasAchievement(String achievementId) {
    return achievements.contains(achievementId);
  }

  // Add achievement
  void addAchievement(String achievementId) {
    if (!hasAchievement(achievementId)) {
      achievements.add(achievementId);
    }
  }

  // Update streak based on quiz date
  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastQuizDate != null) {
      final lastDate = DateTime(
        lastQuizDate!.year,
        lastQuizDate!.month,
        lastQuizDate!.day,
      );

      final daysDifference = today.difference(lastDate).inDays;

      if (daysDifference == 1) {
        // Consecutive day
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else if (daysDifference > 1) {
        // Streak broken
        currentStreak = 1;
      }
      // If same day, don't change streak
    } else {
      // First quiz
      currentStreak = 1;
      bestStreak = 1;
    }

    lastQuizDate = now;
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'total_points': totalPoints,
      'quizzes_completed': quizzesCompleted,
      'quiz_history': quizHistory.map((q) => q.toJson()).toList(),
      'subject_scores': subjectScores,
      'achievements': achievements,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_login_at': lastLoginAt.millisecondsSinceEpoch,
      'profile_picture': profilePicture,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
      'last_quiz_date': lastQuizDate?.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      totalPoints: json['total_points'] ?? 0,
      quizzesCompleted: json['quizzes_completed'] ?? 0,
      quizHistory: (json['quiz_history'] as List<dynamic>?)
              ?.map((q) => QuizHistory.fromJson(q))
              .toList() ??
          [],
      subjectScores: Map<String, int>.from(json['subject_scores'] ?? {}),
      achievements: List<String>.from(json['achievements'] ?? []),
      createdAt: _parseDateTime(json['created_at']),
      lastLoginAt: _parseDateTime(json['last_login_at']),
      profilePicture: json['profile_picture'],
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
      lastQuizDate: json['last_quiz_date'] != null 
          ? _parseDateTime(json['last_quiz_date']) 
          : null,
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  // Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    int? totalPoints,
    int? quizzesCompleted,
    List<QuizHistory>? quizHistory,
    Map<String, int>? subjectScores,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? profilePicture,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastQuizDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      totalPoints: totalPoints ?? this.totalPoints,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      quizHistory: quizHistory ?? List<QuizHistory>.from(this.quizHistory),
      subjectScores: subjectScores ?? Map<String, int>.from(this.subjectScores),
      achievements: achievements ?? List<String>.from(this.achievements),
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profilePicture: profilePicture ?? this.profilePicture,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastQuizDate: lastQuizDate ?? this.lastQuizDate,
    );
  }
}