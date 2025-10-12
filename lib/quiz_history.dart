import 'package:hive/hive.dart';

part 'quiz_history.g.dart';

@HiveType(typeId: 1)
class QuizHistory {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String subject;
  
  @HiveField(2)
  final int score;
  
  @HiveField(3)
  final int totalQuestions;
  
  @HiveField(4)
  final Duration timeTaken;
  
  @HiveField(5)
  final Duration totalTime;
  
  @HiveField(6)
  final DateTime completedAt;
  
  @HiveField(7)
  final String difficulty;
  
  @HiveField(8)
  final int pointsEarned;
  
  @HiveField(9)
  final List<QuizAnswer> answers;

  QuizHistory({
    required this.id,
    required this.subject,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.totalTime,
    required this.completedAt,
    this.difficulty = 'Medium',
    this.pointsEarned = 0,
    List<QuizAnswer>? answers,
  }) : answers = answers ?? [];

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  String get performance {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 80) return 'Very Good';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Fair';
    if (percentage >= 50) return 'Needs Improvement';
    return 'Poor';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'score': score,
      'total_questions': totalQuestions,
      'time_taken': timeTaken.inSeconds,
      'total_time': totalTime.inSeconds,
      'completed_at': completedAt.millisecondsSinceEpoch,
      'difficulty': difficulty,
      'points_earned': pointsEarned,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      score: (json['score'] is int ? json['score'] : int.tryParse(json['score']?.toString() ?? '0')) ?? 0,
      totalQuestions: (json['total_questions'] is int ? json['total_questions'] : int.tryParse(json['total_questions']?.toString() ?? '0')) ?? 0,
      timeTaken: Duration(seconds: (json['time_taken'] is int ? json['time_taken'] : int.tryParse(json['time_taken']?.toString() ?? '0')) ?? 0),
      totalTime: Duration(seconds: (json['total_time'] is int ? json['total_time'] : int.tryParse(json['total_time']?.toString() ?? '0')) ?? 0),
      completedAt: _parseDateTime(json['completed_at']),
      difficulty: json['difficulty']?.toString() ?? 'Medium',
      pointsEarned: (json['points_earned'] is int ? json['points_earned'] : int.tryParse(json['points_earned']?.toString() ?? '0')) ?? 0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => QuizAnswer.fromJson(a))
              .toList() ??
          [],
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
}

@HiveType(typeId: 2)
class QuizAnswer {
  @HiveField(0)
  final String questionId;
  
  @HiveField(1)
  final String questionText;
  
  @HiveField(2)
  final int selectedIndex;
  
  @HiveField(3)
  final int correctIndex;
  
  @HiveField(4)
  final List<String> options;
  
  @HiveField(5)
  final bool isCorrect;

  QuizAnswer({
    required this.questionId,
    required this.questionText,
    required this.selectedIndex,
    required this.correctIndex,
    required this.options,
  }) : isCorrect = selectedIndex == correctIndex;

  String get selectedAnswer =>
      selectedIndex >= 0 && selectedIndex < options.length
          ? options[selectedIndex]
          : 'Not answered';

  String get correctAnswer => correctIndex >= 0 && correctIndex < options.length
      ? options[correctIndex]
      : 'Unknown';

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_text': questionText,
      'selected_index': selectedIndex,
      'correct_index': correctIndex,
      'options': options,
      'is_correct': isCorrect,
    };
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      questionId: json['question_id']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      selectedIndex: (json['selected_index'] is int ? json['selected_index'] : int.tryParse(json['selected_index']?.toString() ?? '-1')) ?? -1,
      correctIndex: (json['correct_index'] is int ? json['correct_index'] : int.tryParse(json['correct_index']?.toString() ?? '0')) ?? 0,
      options: List<String>.from(json['options'] ?? []),
    );
  }
}