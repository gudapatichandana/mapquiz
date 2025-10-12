import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'quiz_provider.dart';
import 'auth_provider.dart';
import 'user_progress.dart';
import 'auth_service.dart';
import 'quiz_service.dart';
import 'local_storage_service.dart';
import 'auth_wrapper.dart';
import 'user_model.dart';
import 'quiz_history.dart';
import 'quiz_question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with error handling
  try {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(QuizHistoryAdapter());
    Hive.registerAdapter(QuizAnswerAdapter());
    Hive.registerAdapter(QuizQuestionAdapter());

    // Initialize local storage service
    await LocalStorageService().init();
    
    // Initialize quiz service and populate local questions
    final quizService = QuizService();
    await quizService.populateLocalQuestions();
    
    print('Local storage initialized successfully');
  } catch (e) {
    print('Error initializing local storage: $e');
  }

  runApp(const CSPrepApp());
}

class CSPrepApp extends StatelessWidget {
  const CSPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => UserProgressProvider()),
      ],
      child: MaterialApp(
        title: 'CS Prep',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}