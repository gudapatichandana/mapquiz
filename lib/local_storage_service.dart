import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'quiz_history.dart';
import 'quiz_question.dart';
import 'user_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _quizHistoryBox = 'quiz_history';
  static const String _quizQuestionsBox = 'quiz_questions';
  static const String _appSettingsBox = 'app_settings';
  static const String _userBox = 'users';
  static const String _currentUserKey = 'current_user';

  bool _isInitialized = false;
  Map<String, dynamic> _memoryStorage = {}; // Fallback for web

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      if (kIsWeb) {
        // For web, use memory storage or try to open boxes without path
        await _initializeForWeb();
      } else {
        // For mobile, use regular Hive initialization
        await _initializeForMobile();
      }
      _isInitialized = true;
    } catch (e) {
      print('Error initializing storage: $e');
      // Initialize memory storage as fallback
      _initializeMemoryStorage();
      _isInitialized = true;
    }
  }

  Future<void> _initializeForWeb() async {
    try {
      // Try to open boxes without path (works in newer Hive versions)
      await Hive.openBox<QuizHistory>(_quizHistoryBox);
      await Hive.openBox<QuizQuestion>(_quizQuestionsBox);
      await Hive.openBox<UserModel>(_userBox);
      await Hive.openBox(_appSettingsBox);
    } catch (e) {
      print('Web Hive initialization failed, using memory storage: $e');
      throw e; // Will be caught and use memory storage
    }
  }

  Future<void> _initializeForMobile() async {
    // Mobile initialization remains the same
    await Hive.openBox<QuizHistory>(_quizHistoryBox);
    await Hive.openBox<QuizQuestion>(_quizQuestionsBox);
    await Hive.openBox<UserModel>(_userBox);
    await Hive.openBox(_appSettingsBox);
  }

  void _initializeMemoryStorage() {
    _memoryStorage = {
      _quizHistoryBox: <String, QuizHistory>{},
      _quizQuestionsBox: <String, QuizQuestion>{},
      _userBox: <String, UserModel>{},
      _appSettingsBox: <String, dynamic>{},
    };
  }

  // Helper method to get box or fallback to memory storage
  dynamic _getStorage(String boxName) {
    if (!_isInitialized) throw Exception('Storage not initialized');
    
    if (kIsWeb && !Hive.isBoxOpen(boxName)) {
      return _memoryStorage[boxName] ?? {};
    }
    
    try {
      return Hive.box(boxName);
    } catch (e) {
      return _memoryStorage[boxName] ?? {};
    }
  }

  // User Methods
  Future<void> saveUser(UserModel user) async {
    try {
      final box = _getStorage(_userBox);
      if (box is Box) {
        await box.put(user.id, user);
      } else if (box is Map) {
        box[user.id] = user;
      }
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  UserModel? getUser(String userId) {
    try {
      final box = _getStorage(_userBox);
      if (box is Box) {
        return box.get(userId);
      } else if (box is Map) {
        return box[userId];
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  Future<void> deleteUser(String userId) async {
    try {
      final box = _getStorage(_userBox);
      if (box is Box) {
        await box.delete(userId);
      } else if (box is Map) {
        box.remove(userId);
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Map<String, UserModel> getAllUsers() {
    try {
      final box = _getStorage(_userBox);
      final users = <String, UserModel>{};
      
      if (box is Box) {
        for (var key in box.keys) {
          final user = box.get(key);
          if (user != null) {
            users[key.toString()] = user;
          }
        }
      } else if (box is Map) {
        box.forEach((key, value) {
          if (value is UserModel) {
            users[key.toString()] = value;
          }
        });
      }
      return users;
    } catch (e) {
      print('Error getting all users: $e');
      return {};
    }
  }

  // Current User Management
  Future<void> setCurrentUserId(String userId) async {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        await box.put(_currentUserKey, userId);
      } else if (box is Map) {
        box[_currentUserKey] = userId;
      }
    } catch (e) {
      print('Error setting current user: $e');
    }
  }

  String? getCurrentUserId() {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        return box.get(_currentUserKey);
      } else if (box is Map) {
        return box[_currentUserKey]?.toString();
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }

  Future<void> clearCurrentUser() async {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        await box.delete(_currentUserKey);
      } else if (box is Map) {
        box.remove(_currentUserKey);
      }
    } catch (e) {
      print('Error clearing current user: $e');
    }
  }

  // Quiz History Methods
  Future<void> saveQuizHistory(QuizHistory history) async {
    try {
      final box = _getStorage(_quizHistoryBox);
      if (box is Box) {
        await box.put(history.id, history);
      } else if (box is Map) {
        box[history.id] = history;
      }
    } catch (e) {
      print('Error saving quiz history: $e');
    }
  }

  List<QuizHistory> getQuizHistories() {
    try {
      final box = _getStorage(_quizHistoryBox);
      if (box is Box) {
        return box.values.cast<QuizHistory>().toList();
      } else if (box is Map) {
        return box.values.whereType<QuizHistory>().toList();
      }
    } catch (e) {
      print('Error getting quiz histories: $e');
    }
    return [];
  }

  // ADDED: Get user quiz history
  Future<List<QuizHistory>> getUserQuizHistory(String userId) async {
    try {
      final allHistory = getQuizHistories();
      
      // Filter by user ID (assuming quiz ID contains user ID)
      final userHistory = allHistory.where((quiz) => 
        quiz.id.contains(userId)
      ).toList();
      
      // Sort by completion date (newest first)
      userHistory.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      
      return userHistory;
    } catch (e) {
      print('Error getting user quiz history: $e');
      return [];
    }
  }

  Future<void> deleteQuizHistory(String id) async {
    try {
      final box = _getStorage(_quizHistoryBox);
      if (box is Box) {
        await box.delete(id);
      } else if (box is Map) {
        box.remove(id);
      }
    } catch (e) {
      print('Error deleting quiz history: $e');
    }
  }

  // Quiz Questions Methods
  Future<void> saveQuizQuestions(List<QuizQuestion> questions) async {
    try {
      final box = _getStorage(_quizQuestionsBox);
      for (var question in questions) {
        if (box is Box) {
          await box.put(question.id, question);
        } else if (box is Map) {
          box[question.id] = question;
        }
      }
    } catch (e) {
      print('Error saving quiz questions: $e');
    }
  }

  // ADDED: Get all quiz questions
  List<QuizQuestion> getQuizQuestions() {
    try {
      final box = _getStorage(_quizQuestionsBox);
      if (box is Box) {
        return box.values.cast<QuizQuestion>().toList();
      } else if (box is Map) {
        return box.values.whereType<QuizQuestion>().toList();
      }
    } catch (e) {
      print('Error getting quiz questions: $e');
    }
    return [];
  }

  // ADDED: Get questions by subject
  List<QuizQuestion> getQuestionsBySubject(String subject) {
    try {
      final allQuestions = getQuizQuestions();
      return allQuestions.where((q) => q.subject == subject).toList();
    } catch (e) {
      print('Error getting questions by subject: $e');
      return [];
    }
  }

  // ADDED: Get questions by difficulty
  List<QuizQuestion> getQuestionsByDifficulty(String difficulty) {
    try {
      final allQuestions = getQuizQuestions();
      return allQuestions.where((q) => q.difficulty == difficulty).toList();
    } catch (e) {
      print('Error getting questions by difficulty: $e');
      return [];
    }
  }

  // App Settings Methods
  Future<void> setString(String key, String value) async {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        await box.put(key, value);
      } else if (box is Map) {
        box[key] = value;
      }
    } catch (e) {
      print('Error setting string: $e');
    }
  }

  String getString(String key, {String defaultValue = ''}) {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        return box.get(key, defaultValue: defaultValue) as String;
      } else if (box is Map) {
        return (box[key] as String?) ?? defaultValue;
      }
    } catch (e) {
      print('Error getting string: $e');
    }
    return defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        await box.put(key, value);
      } else if (box is Map) {
        box[key] = value;
      }
    } catch (e) {
      print('Error setting bool: $e');
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        return box.get(key, defaultValue: defaultValue) as bool;
      } else if (box is Map) {
        return (box[key] as bool?) ?? defaultValue;
      }
    } catch (e) {
      print('Error getting bool: $e');
    }
    return defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        await box.put(key, value);
      } else if (box is Map) {
        box[key] = value;
      }
    } catch (e) {
      print('Error setting int: $e');
    }
  }

  int getInt(String key, {int defaultValue = 0}) {
    try {
      final box = _getStorage(_appSettingsBox);
      if (box is Box) {
        return box.get(key, defaultValue: defaultValue) as int;
      } else if (box is Map) {
        return (box[key] as int?) ?? defaultValue;
      }
    } catch (e) {
      print('Error getting int: $e');
    }
    return defaultValue;
  }

  // Data Management
  Future<void> clearAllData() async {
    try {
      if (kIsWeb && _memoryStorage.isNotEmpty) {
        _initializeMemoryStorage();
        return;
      }

      final userBox = _getStorage(_userBox);
      final historyBox = _getStorage(_quizHistoryBox);
      final questionsBox = _getStorage(_quizQuestionsBox);
      final settingsBox = _getStorage(_appSettingsBox);

      if (userBox is Box) await userBox.clear();
      if (historyBox is Box) await historyBox.clear();
      if (questionsBox is Box) await questionsBox.clear();
      if (settingsBox is Box) await settingsBox.clear();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Backup and Restore
  Future<Map<String, dynamic>> exportUserData(String userId) async {
    try {
      final user = getUser(userId);
      final quizHistory = await getUserQuizHistory(userId);
      
      return {
        'user': user?.toJson(),
        'quiz_history': quizHistory.map((q) => q.toJson()).toList(),
        'export_date': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      print('Error exporting user data: $e');
      return {};
    }
  }

  Future<void> importUserData(Map<String, dynamic> data) async {
    try {
      final userData = data['user'];
      final quizHistoryData = data['quiz_history'];
      
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await saveUser(user);
      }
      
      if (quizHistoryData != null) {
        for (final quizData in quizHistoryData) {
          final quiz = QuizHistory.fromJson(quizData);
          await saveQuizHistory(quiz);
        }
      }
    } catch (e) {
      print('Error importing user data: $e');
    }
  }

  Future<void> close() async {
    try {
      if (!kIsWeb) {
        await Hive.close();
      }
      _isInitialized = false;
    } catch (e) {
      print('Error closing storage: $e');
    }
  }
}