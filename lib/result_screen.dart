import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz_provider.dart';
import 'user_progress.dart';
import 'auth_provider.dart';
import 'responsive_layout.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _progressUpdated = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    // Update user progress when result screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUserProgress();
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _updateUserProgress() async {
    if (_progressUpdated) return;

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userProgressProvider = Provider.of<UserProgressProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (quizProvider.quizCompleted && authProvider.isAuthenticated && !_progressUpdated) {
      final result = quizProvider.getResult();
      
      // Add a small delay to ensure we don't save duplicates
      await Future.delayed(const Duration(milliseconds: 100));
      
      await userProgressProvider.addQuizResult(result);

      // Update user in auth provider
      final updatedUser = userProgressProvider.currentUser;
      if (updatedUser != null) {
        authProvider.updateUser(updatedUser);
      }

      if (_isMounted) {
        setState(() {
          _progressUpdated = true;
        });
      }

      if (_isMounted) {
        _showAchievementNotifications(result);
      }
    }
  }

  void _showAchievementNotifications(dynamic result) {
    final userProgressProvider = Provider.of<UserProgressProvider>(context, listen: false);
    final user = userProgressProvider.currentUser;

    if (user == null) return;

    // Check if this was the user's first quiz
    if (user.quizzesCompleted == 1) {
      _showAchievementSnackBar(
          '🎉 First Quiz Complete!', 'Welcome to CS Prep!');
    }

    // Check for perfect score
    if (result.percentage == 100) {
      _showAchievementSnackBar('🏆 Perfect Score!', 'Outstanding performance!');
    }

    // Check for streak milestones
    if (user.currentStreak == 7) {
      _showAchievementSnackBar('🔥 Week Streak!', '7 days in a row!');
    }

    // Check for point milestones
    if (user.totalPoints >= 1000 &&
        user.totalPoints - _calculatePoints(result) < 1000) {
      _showAchievementSnackBar('💎 1000 Points!', 'You\'re on fire!');
    }
  }

  void _showAchievementSnackBar(String title, String message) {
    if (!_isMounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  int _calculatePoints(dynamic result) {
    int basePoints = 100;

    // Bonus for accuracy
    if (result.percentage >= 90) {
      basePoints += 50;
    } else if (result.percentage >= 80) {
      basePoints += 25;
    }

    // Bonus for speed (completed in less than 80% of total time)
    final timePercentage = (result.timeTaken.inSeconds / result.totalTime.inSeconds) * 100;
    if (timePercentage <= 80) {
      basePoints += 25;
    }

    // Perfect score bonus
    if (result.percentage == 100) {
      basePoints += 100;
    }

    return basePoints;
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final result = quizProvider.getResult();
    final pointsEarned = _calculatePoints(result);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0F9FF),
              Color(0xFFE0F2FE),
              Color(0xFFFEFBFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: ResponsiveLayout.getPadding(context),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Results Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Success Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: result.percentage >= 70
                              ? Colors.green.shade100
                              : result.percentage >= 50
                                  ? Colors.orange.shade100
                                  : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          result.percentage >= 70
                              ? Icons.celebration
                              : result.percentage >= 50
                                  ? Icons.emoji_people
                                  : Icons.refresh,
                          size: ResponsiveLayout.getIconSize(context, base: 48),
                          color: result.percentage >= 70
                              ? Colors.green.shade600
                              : result.percentage >= 50
                                  ? Colors.orange.shade600
                                  : Colors.red.shade600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        result.percentage >= 70
                            ? 'Excellent!'
                            : result.percentage >= 50
                                ? 'Good Job!'
                                : 'Keep Practicing!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveLayout.getFontSize(context,
                                  base: 24),
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        result.subject,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: const Color(0xFF6B7280),
                              fontSize: ResponsiveLayout.getFontSize(context,
                                  base: 16),
                            ),
                      ),

                      const SizedBox(height: 24),

                      // Score Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${result.score}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3B82F6),
                                  fontSize: ResponsiveLayout.getFontSize(
                                      context,
                                      base: 48),
                                ),
                          ),
                          Text(
                            '/${result.totalQuestions}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF6B7280),
                                  fontSize: ResponsiveLayout.getFontSize(
                                      context,
                                      base: 32),
                                ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${result.percentage.toStringAsFixed(1)}% • Grade ${result.grade}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: result.percentage >= 70
                                  ? Colors.green.shade600
                                  : result.percentage >= 50
                                      ? Colors.orange.shade600
                                      : Colors.red.shade600,
                              fontSize: ResponsiveLayout.getFontSize(context,
                                  base: 18),
                            ),
                      ),

                      const SizedBox(height: 16),

                      // Points Earned
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.stars,
                              color: Colors.orange.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+$pointsEarned Points Earned!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveLayout.getSpacing(context) * 2),

                // Performance Metrics
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveLayout.getFontSize(context,
                                  base: 18),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              'Time Taken',
                              '${result.timeTaken.inMinutes}:${(result.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
                              Icons.timer,
                              Colors.blue,
                            ),
                          ),
                          SizedBox(width: ResponsiveLayout.getSpacing(context)),
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              'Accuracy',
                              '${result.percentage.toStringAsFixed(0)}%',
                              Icons.trending_up,
                              result.percentage >= 70
                                  ? Colors.green
                                  : result.percentage >= 50
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              'Correct',
                              '${result.score}',
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ),
                          SizedBox(width: ResponsiveLayout.getSpacing(context)),
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              'Incorrect',
                              '${result.totalQuestions - result.score}',
                              Icons.cancel,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveLayout.getSpacing(context) * 2),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            final quizProvider = Provider.of<QuizProvider>(
                                context,
                                listen: false);
                            quizProvider.resetQuiz();

                            if (!context.mounted) return;

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizScreen(subject: result.subject),
                              ),
                            );
                          } catch (e) {
                            debugPrint('Retry navigation error: $e');
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry Quiz'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: ResponsiveLayout.getSpacing(context)),
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            final quizProvider = Provider.of<QuizProvider>(
                                context,
                                listen: false);

                            // Reset quiz state first
                            quizProvider.resetQuiz();

                            // Add a small delay to ensure state is properly updated
                            await Future.delayed(
                                const Duration(milliseconds: 100));

                            // Check if context is still mounted before navigation
                            if (!context.mounted) return;

                            // Navigate to home and clear all previous routes
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            debugPrint('Home navigation error: $e');
                            // Fallback navigation - try to pop to first route
                            if (context.mounted) {
                              try {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              } catch (fallbackError) {
                                debugPrint(
                                    'Fallback navigation error: $fallbackError');
                                // Last resort - push replacement
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Back to Home'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      SizedBox(height: ResponsiveLayout.getSpacing(context)),
                      TextButton(
                        onPressed: () {
                          _showAnswerReview(context, result);
                        },
                        child: const Text('Review Answers'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveLayout.getIconSize(context, base: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: ResponsiveLayout.getFontSize(context, base: 18),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: ResponsiveLayout.getFontSize(context, base: 12),
                ),
          ),
        ],
      ),
    );
  }

  void _showAnswerReview(BuildContext context, dynamic result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Answer Review',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: result.userAnswers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final answer = result.userAnswers[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: answer.isCorrect
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: answer.isCorrect
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: answer.isCorrect
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Q${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                answer.isCorrect
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: answer.isCorrect
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            answer.questionText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (!answer.isCorrect) ...[
                            Text(
                              'Your answer: ${answer.selectedAnswer}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            'Correct answer: ${answer.correctAnswer}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}