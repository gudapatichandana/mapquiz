import 'package:hive/hive.dart';

part 'quiz_question.g.dart';

@HiveType(typeId: 3)
class QuizQuestion {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String text;
  
  @HiveField(2)
  final List<String> options;
  
  @HiveField(3)
  final int answerIndex;
  
  @HiveField(4)
  final String subject;
  
  @HiveField(5)
  final String difficulty;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.subject,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      answerIndex: (json['answerIndex'] is int ? json['answerIndex'] : int.tryParse(json['answerIndex']?.toString() ?? '0')) ?? 0,
      subject: json['subject']?.toString() ?? 'General',
      difficulty: json['difficulty']?.toString() ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'answerIndex': answerIndex,
      'subject': subject,
      'difficulty': difficulty,
    };
  }

  String get correctAnswer => options.isNotEmpty && answerIndex >= 0 && answerIndex < options.length 
      ? options[answerIndex] 
      : '';
}