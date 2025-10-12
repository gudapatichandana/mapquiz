import 'dart:math' as math;
import 'quiz_question.dart';
import 'local_storage_service.dart';

class QuizService {
  final LocalStorageService _storageService = LocalStorageService();
  
  static const Map<String, List<Map<String, dynamic>>> _questionBank = {
    'DSA': [
      {
        'text': 'What is the time complexity of binary search in a sorted array?',
        'options': ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
        'answerIndex': 1,
      },
      {
        'text': 'Which data structure follows LIFO principle?',
        'options': ['Queue', 'Stack', 'Array', 'Linked List'],
        'answerIndex': 1,
      },
      {
        'text': 'What is the worst-case time complexity of QuickSort?',
        'options': ['O(n log n)', 'O(n²)', 'O(n)', 'O(log n)'],
        'answerIndex': 1,
      },
      {
        'text': 'In which traversal method do we visit the root node first?',
        'options': ['Inorder', 'Preorder', 'Postorder', 'Level order'],
        'answerIndex': 1,
      },
      {
        'text': 'What is the space complexity of merge sort?',
        'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
        'answerIndex': 2,
      },
    ],
    'DBMS': [
      {
        'text': 'What does ACID stand for in database management?',
        'options': [
          'Atomicity, Consistency, Isolation, Durability',
          'Accuracy, Completeness, Integrity, Durability',
          'Atomicity, Completeness, Isolation, Delivery',
          'Accuracy, Consistency, Integrity, Delivery'
        ],
        'answerIndex': 0,
      },
      {
        'text': 'Which normal form eliminates transitive dependency?',
        'options': ['1NF', '2NF', '3NF', 'BCNF'],
        'answerIndex': 2,
      },
      {
        'text': 'What is the purpose of indexing in databases?',
        'options': [
          'To increase storage',
          'To improve query performance',
          'To ensure data integrity',
          'To create backups'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Which SQL command is used to remove a table?',
        'options': ['DELETE', 'REMOVE', 'DROP', 'CLEAR'],
        'answerIndex': 2,
      },
      {
        'text': 'What type of relationship exists when one entity relates to multiple entities?',
        'options': ['One-to-One', 'One-to-Many', 'Many-to-Many', 'Many-to-One'],
        'answerIndex': 1,
      },
    ],
    'Operating Systems': [
      {
        'text': 'What is a deadlock in operating systems?',
        'options': [
          'A process that never terminates',
          'A situation where processes wait indefinitely',
          'A memory allocation error',
          'A CPU scheduling algorithm'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Which scheduling algorithm gives the shortest job the highest priority?',
        'options': ['FCFS', 'SJF', 'Round Robin', 'Priority Scheduling'],
        'answerIndex': 1,
      },
      {
        'text': 'What is virtual memory?',
        'options': [
          'Physical RAM only',
          'A memory management technique',
          'Cache memory',
          'Register memory'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'What is the purpose of a semaphore?',
        'options': [
          'File management',
          'Process synchronization',
          'Memory allocation',
          'CPU scheduling'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Which of the following is a page replacement algorithm?',
        'options': ['FCFS', 'LIFO', 'LRU', 'SJF'],
        'answerIndex': 2,
      },
    ],
    'Computer Networks': [
      {
        'text': 'Which layer of the OSI model handles routing?',
        'options': ['Physical', 'Data Link', 'Network', 'Transport'],
        'answerIndex': 2,
      },
      {
        'text': 'What does TCP stand for?',
        'options': [
          'Transfer Control Protocol',
          'Transmission Control Protocol',
          'Transport Control Protocol',
          'Transaction Control Protocol'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Which protocol is used for sending emails?',
        'options': ['HTTP', 'FTP', 'SMTP', 'SNMP'],
        'answerIndex': 2,
      },
      {
        'text': 'What is the default port number for HTTPS?',
        'options': ['80', '443', '21', '25'],
        'answerIndex': 1,
      },
      {
        'text': 'Which device operates at the Network layer?',
        'options': ['Hub', 'Switch', 'Router', 'Bridge'],
        'answerIndex': 2,
      },
    ],
    'OOP': [
      {
        'text': 'Which principle allows a single interface to represent different data types?',
        'options': [
          'Encapsulation',
          'Inheritance',
          'Polymorphism',
          'Abstraction'
        ],
        'answerIndex': 2,
      },
      {
        'text': 'What is the process of hiding internal implementation details?',
        'options': [
          'Inheritance',
          'Encapsulation',
          'Polymorphism',
          'Abstraction'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Which keyword is used to inherit a class in Java?',
        'options': ['inherits', 'extends', 'implements', 'derives'],
        'answerIndex': 1,
      },
      {
        'text': 'What is method overloading?',
        'options': [
          'Same method name, different parameters',
          'Different method name, same parameters',
          'Same method signature in parent and child',
          'None of the above'
        ],
        'answerIndex': 0,
      },
      {
        'text': 'Which access modifier makes a member accessible only within the same class?',
        'options': ['public', 'protected', 'private', 'default'],
        'answerIndex': 2,
      },
    ],
    'Aptitude': [
      {
        'text': 'If a clock shows 3:15, what is the angle between hour and minute hands?',
        'options': ['7.5°', '22.5°', '37.5°', '52.5°'],
        'answerIndex': 0,
      },
      {
        'text': 'A train 100m long traveling at 36 km/hr takes how long to cross a 200m bridge?',
        'options': ['20 seconds', '25 seconds', '30 seconds', '35 seconds'],
        'answerIndex': 2,
      },
      {
        'text': 'If 15 men can complete a work in 20 days, how many days will 25 men take?',
        'options': ['10 days', '12 days', '15 days', '18 days'],
        'answerIndex': 1,
      },
      {
        'text': 'What is the next number in the series: 2, 6, 12, 20, ?',
        'options': ['28', '30', '32', '36'],
        'answerIndex': 1,
      },
      {
        'text': 'A shopkeeper sells an item for ₹120 at 20% profit. What was the cost price?',
        'options': ['₹96', '₹100', '₹105', '₹110'],
        'answerIndex': 1,
      },
    ],
    'HR': [
      {
        'text': 'What is your greatest strength?',
        'options': [
          'Technical skills',
          'Communication',
          'Problem-solving',
          'All of the above'
        ],
        'answerIndex': 3,
      },
      {
        'text': 'How do you handle work pressure?',
        'options': [
          'Avoid it',
          'Prioritize tasks',
          'Work overtime',
          'Delegate everything'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'Why do you want to work for this company?',
        'options': [
          'Good salary',
          'Career growth opportunities',
          'Work-life balance',
          'Company reputation'
        ],
        'answerIndex': 1,
      },
      {
        'text': 'What motivates you at work?',
        'options': [
          'Money only',
          'Recognition',
          'Learning new skills',
          'Fixed schedule'
        ],
        'answerIndex': 2,
      },
      {
        'text': 'How do you handle conflicts with team members?',
        'options': [
          'Ignore them',
          'Report to manager',
          'Discuss openly',
          'Change teams'
        ],
        'answerIndex': 2,
      },
    ],
  };

  Future<List<QuizQuestion>> generateQuiz(String subject) async {
    await _storageService.init();
    
    // Try to get questions from local storage first
    List<QuizQuestion> questions = [];
    
    if (subject.toLowerCase() == 'daily quiz') {
      // For daily quiz, get questions from all subjects
      questions = _storageService.getQuizQuestions();
    } else {
      // Get questions for specific subject
      questions = _storageService.getQuestionsBySubject(subject);
    }
    
    // If no questions found in storage, use the local question bank
    if (questions.isEmpty) {
      questions = _getQuestionsFromLocalBank(subject);
      // Save these questions to local storage for future use
      await _storageService.saveQuizQuestions(questions);
    }
    
    // Shuffle and return questions (limit to 5 for quiz)
    final random = math.Random();
    questions.shuffle(random);
    return questions.take(5).toList();
  }

  List<QuizQuestion> _getQuestionsFromLocalBank(String subject) {
    List<Map<String, dynamic>> questionPool;

    if (subject.toLowerCase() == 'daily quiz') {
      questionPool = [];
      _questionBank.forEach((key, questions) {
        questionPool.addAll(questions);
      });
    } else {
      questionPool = _questionBank[subject] ?? _questionBank['DSA']!;
    }

    return questionPool.asMap().entries.map((entry) {
      final index = entry.key;
      final questionData = entry.value;

      return QuizQuestion(
        id: 'local_q_${DateTime.now().millisecondsSinceEpoch}_$index',
        text: questionData['text'],
        options: List<String>.from(questionData['options']),
        answerIndex: questionData['answerIndex'],
        subject: subject,
        difficulty: 'Medium',
      );
    }).toList();
  }

  // Method to populate local storage with questions (run once during app initialization)
  Future<void> populateLocalQuestions() async {
    try {
      final allQuestions = <QuizQuestion>[];
      
      for (final entry in _questionBank.entries) {
        final subject = entry.key;
        final questions = entry.value;

        for (final question in questions) {
          allQuestions.add(QuizQuestion(
            id: '${subject}_${question['text'].hashCode}',
            text: question['text'],
            options: List<String>.from(question['options']),
            answerIndex: question['answerIndex'],
            subject: subject,
            difficulty: 'Medium',
          ));
        }
      }
      
      await _storageService.saveQuizQuestions(allQuestions);
      print('Questions populated to local storage successfully');
    } catch (e) {
      print('Error populating questions to local storage: $e');
    }
  }

  // Get available subjects
  List<String> getAvailableSubjects() {
    return _questionBank.keys.toList();
  }

  // Get subject-specific questions count
  int getQuestionCountForSubject(String subject) {
    return _questionBank[subject]?.length ?? 0;
  }

  // Get total questions count
  int getTotalQuestionsCount() {
    return _questionBank.values.fold(0, (sum, questions) => sum + questions.length);
  }
}