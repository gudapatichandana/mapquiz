import 'package:flutter/material.dart';

class QuizConstants {
  // Points calculation
  static const int basePoints = 100;
  static const int excellentBonus = 50; // 90%+ accuracy
  static const int goodBonus = 25; // 80%+ accuracy
  static const int speedBonus = 25; // Completed in <80% of time
  static const int perfectBonus = 100; // 100% accuracy

  // Quiz settings
  static const int defaultQuizDuration = 10; // minutes
  static const int defaultQuestionCount = 5;

  // Achievement thresholds
  static const Map<String, int> pointThresholds = {
    'bronze': 500,
    'silver': 1000,
    'gold': 2500,
    'platinum': 5000,
    'diamond': 10000,
  };

  static const Map<String, int> streakThresholds = {
    'week': 7,
    'month': 30,
    'quarter': 90,
  };

  static const Map<String, int> quizCountThresholds = {
    'beginner': 10,
    'intermediate': 50,
    'advanced': 100,
    'expert': 250,
    'master': 500,
  };
}

class AchievementConstants {
  static List<Map<String, dynamic>> getAllAchievements() {
    return [
      {
        'id': 'first_quiz',
        'title': 'First Steps',
        'description': 'Complete your first quiz',
        'icon': Icons.play_arrow,
        'color': Colors.green,
      },
      {
        'id': 'week_streak',
        'title': 'Week Warrior',
        'description': 'Take quizzes for 7 consecutive days',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
      {
        'id': 'month_streak',
        'title': 'Monthly Master',
        'description': 'Take quizzes for 30 consecutive days',
        'icon': Icons.whatshot,
        'color': Colors.red,
      },
      {
        'id': 'points_1000',
        'title': 'Point Collector',
        'description': 'Earn 1000 points',
        'icon': Icons.stars,
        'color': Colors.purple,
      },
      {
        'id': 'points_5000',
        'title': 'Point Master',
        'description': 'Earn 5000 points',
        'icon': Icons.star_border,
        'color': Colors.indigo,
      },
      {
        'id': 'quiz_master_10',
        'title': 'Quiz Novice',
        'description': 'Complete 10 quizzes',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'id': 'quiz_master_50',
        'title': 'Quiz Expert',
        'description': 'Complete 50 quizzes',
        'icon': Icons.school,
        'color': Colors.cyan,
      },
      {
        'id': 'perfectionist',
        'title': 'Perfectionist',
        'description': 'Score 100% on 5 different quizzes',
        'icon': Icons.radio_button_checked,
        'color': Colors.amber,
      },
      {
        'id': 'dsa_master',
        'title': 'DSA Master',
        'description': 'Score 4/5 or better on DSA quiz',
        'icon': Icons.code,
        'color': const Color(0xFF3B82F6),
      },
      {
        'id': 'dbms_master',
        'title': 'Database Expert',
        'description': 'Score 4/5 or better on DBMS quiz',
        'icon': Icons.storage,
        'color': const Color(0xFF10B981),
      },
      {
        'id': 'operating_systems_master',
        'title': 'OS Specialist',
        'description': 'Score 4/5 or better on OS quiz',
        'icon': Icons.computer,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'id': 'computer_networks_master',
        'title': 'Network Guru',
        'description': 'Score 4/5 or better on Networks quiz',
        'icon': Icons.network_wifi,
        'color': const Color(0xFFF59E0B),
      },
      {
        'id': 'oop_master',
        'title': 'OOP Champion',
        'description': 'Score 4/5 or better on OOP quiz',
        'icon': Icons.architecture,
        'color': const Color(0xFFEF4444),
      },
      {
        'id': 'aptitude_master',
        'title': 'Math Wizard',
        'description': 'Score 4/5 or better on Aptitude quiz',
        'icon': Icons.calculate,
        'color': const Color(0xFF06B6D4),
      },
      {
        'id': 'hr_master',
        'title': 'People Person',
        'description': 'Score 4/5 or better on HR quiz',
        'icon': Icons.people,
        'color': const Color(0xFFEC4899),
      },
    ];
  }

  static Map<String, dynamic>? getAchievement(String id) {
    try {
      return getAllAchievements()
          .firstWhere((achievement) => achievement['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static List<Map<String, dynamic>> getUnlockedAchievements(
      List<String> userAchievements) {
    return getAllAchievements()
        .where((achievement) => userAchievements.contains(achievement['id']))
        .toList();
  }

  static List<Map<String, dynamic>> getLockedAchievements(
      List<String> userAchievements) {
    return getAllAchievements()
        .where((achievement) => !userAchievements.contains(achievement['id']))
        .toList();
  }
}

class SubjectConstants {
  static const Map<String, Color> subjectColors = {
    'DSA': Color(0xFF3B82F6),
    'DBMS': Color(0xFF10B981),
    'Operating Systems': Color(0xFF8B5CF6),
    'Computer Networks': Color(0xFFF59E0B),
    'OOP': Color(0xFFEF4444),
    'Aptitude': Color(0xFF06B6D4),
    'HR': Color(0xFFEC4899),
    'Daily Quiz': Color(0xFF667EEA),
  };

  static const Map<String, IconData> subjectIcons = {
    'DSA': Icons.code,
    'DBMS': Icons.storage,
    'Operating Systems': Icons.computer,
    'Computer Networks': Icons.network_wifi,
    'OOP': Icons.architecture,
    'Aptitude': Icons.calculate,
    'HR': Icons.people,
    'Daily Quiz': Icons.today,
  };

  static const Map<String, int> subjectDurations = {
    'DSA': 12,
    'DBMS': 10,
    'Operating Systems': 10,
    'Computer Networks': 8,
    'OOP': 8,
    'Aptitude': 15,
    'HR': 15,
    'Daily Quiz': 10,
  };

  static Color getSubjectColor(String subject) {
    return subjectColors[subject] ?? Colors.grey;
  }

  static IconData getSubjectIcon(String subject) {
    return subjectIcons[subject] ?? Icons.quiz;
  }

  static int getSubjectDuration(String subject) {
    return subjectDurations[subject] ?? 10;
  }
}

class AppConstants {
  static const String appName = 'CS Prep';
  static const String appDescription = 'Master Computer Science with Smart Quizzes';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String authTokenKey = 'auth_token';

  // Validation constants
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}