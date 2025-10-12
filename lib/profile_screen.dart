import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'user_progress.dart';
import 'responsive_layout.dart';
import 'constants.dart';
import 'progress_card.dart';
import 'achievement_badge.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'quiz_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Consumer2<AuthProvider, UserProgressProvider>(
              builder: (context, authProvider, progressProvider, _) {
                final user = authProvider.user;
                final stats = progressProvider.getProgressStats();

                if (user == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'User not found',
                        style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with back button
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showSettingsDialog(context),
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // User Profile Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          // Profile Picture
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: user.profilePicture != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      user.profilePicture!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Color(0xFF3B82F6),
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Color(0xFF3B82F6),
                                  ),
                          ),

                          const SizedBox(height: 16),

                          // User Name
                          Text(
                            user.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          // User Email
                          Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF6B7280),
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Member Since
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Member since ${DateFormat('MMM yyyy').format(user.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Progress Overview
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
                            'Progress Overview',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              ProgressCard(
                                title: 'Total Points',
                                value: '${stats['totalPoints'] ?? 0}',
                                icon: Icons.stars,
                                color: Colors.orange,
                              ),
                              ProgressCard(
                                title: 'Quizzes Completed',
                                value: '${stats['quizzesCompleted'] ?? 0}',
                                icon: Icons.quiz,
                                color: Colors.blue,
                              ),
                              ProgressCard(
                                title: 'Average Score',
                                value:
                                    '${(stats['averageScore'] ?? 0).toStringAsFixed(1)}%',
                                icon: Icons.trending_up,
                                color: Colors.green,
                              ),
                              ProgressCard(
                                title: 'Current Streak',
                                value: '${stats['currentStreak'] ?? 0} days',
                                icon: Icons.local_fire_department,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Subject Performance Chart
                    if (stats['subjectPerformance'] != null && 
                        (stats['subjectPerformance'] as Map<String, dynamic>).isNotEmpty) ...[
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
                              'Subject Performance',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: _buildSubjectChart(
                                  stats['subjectPerformance'] as Map<String, double>),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Achievements Section
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Achievements',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ??
                                    const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${user.achievements.length} unlocked',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildAchievementsGrid(user.achievements),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent Activity
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
                            'Recent Activity',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ??
                                const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentActivity(
                              progressProvider.recentQuizzes.take(5).toList()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectChart(Map<String, double> subjectPerformance) {
    final data = subjectPerformance.entries.map((entry) {
      return BarChartGroupData(
        x: subjectPerformance.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: _getSubjectColor(entry.key),
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final subject = subjectPerformance.keys.elementAt(groupIndex);
              return BarTooltipItem(
                '$subject\n${rod.toY.toStringAsFixed(1)}%',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final subjects = subjectPerformance.keys.toList();
                if (value.toInt() < subjects.length) {
                  final subject = subjects[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subject.length > 6
                          ? '${subject.substring(0, 6)}...'
                          : subject,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data,
        gridData: const FlGridData(show: false),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'dsa':
        return const Color(0xFF3B82F6);
      case 'dbms':
        return const Color(0xFF10B981);
      case 'operating systems':
        return const Color(0xFF8B5CF6);
      case 'computer networks':
        return const Color(0xFFF59E0B);
      case 'oop':
        return const Color(0xFFEF4444);
      case 'aptitude':
        return const Color(0xFF06B6D4);
      case 'hr':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildAchievementsGrid(List<String> achievements) {
    final allAchievements = AchievementConstants.getAllAchievements();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allAchievements.length,
      itemBuilder: (context, index) {
        final achievement = allAchievements[index];
        final isUnlocked = achievements.contains(achievement['id']);

        return AchievementBadge(
          achievement: achievement,
          isUnlocked: isUnlocked,
        );
      },
    );
  }

  Widget _buildRecentActivity(List<QuizHistory> recentQuizzes) {
    // Remove duplicates using a more comprehensive check
    final seenQuizzes = <String>{};
    final uniqueQuizzes = recentQuizzes.where((quiz) {
      // Create a unique key using subject, score, and completed time (within 1 minute)
      final uniqueKey = '${quiz.subject}_${quiz.score}_${quiz.completedAt.millisecondsSinceEpoch ~/ 60000}';
      
      if (seenQuizzes.contains(uniqueKey)) {
        return false;
      } else {
        seenQuizzes.add(uniqueKey);
        return true;
      }
    }).toList();

    if (uniqueQuizzes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No recent activity',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      );
    }

    // Sort by completion date (newest first)
    uniqueQuizzes.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: uniqueQuizzes.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final quiz = uniqueQuizzes[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSubjectColor(quiz.subject).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.quiz,
              color: _getSubjectColor(quiz.subject),
              size: 20,
            ),
          ),
          title: Text(
            quiz.subject,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '${quiz.score}/${quiz.totalQuestions} • ${quiz.percentage.toStringAsFixed(1)}%',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Review Button
              IconButton(
                icon: const Icon(Icons.remove_red_eye, size: 20),
                onPressed: () => _showQuizReview(context, quiz),
                tooltip: 'Review Quiz',
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMM dd').format(quiz.completedAt),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: quiz.percentage >= 70
                          ? Colors.green.shade100
                          : quiz.percentage >= 50
                              ? Colors.orange.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quiz.grade,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: quiz.percentage >= 70
                            ? Colors.green.shade700
                            : quiz.percentage >= 50
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuizReview(BuildContext context, QuizHistory quiz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
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
                'Quiz Review - ${quiz.subject}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: ${quiz.score}/${quiz.totalQuestions} (${quiz.percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
              ),
              const SizedBox(height: 16),
              // Quiz Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReviewStat('Grade', quiz.grade, Icons.grade),
                    _buildReviewStat('Performance', quiz.performance, Icons.assessment),
                    _buildReviewStat('Time', '${quiz.timeTaken.inMinutes}m', Icons.timer),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: quiz.answers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final answer = quiz.answers[index];
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
                              const Spacer(),
                              Text(
                                answer.isCorrect ? 'Correct' : 'Incorrect',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: answer.isCorrect
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
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
                          const SizedBox(height: 8),
                          // Options list
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: answer.options.asMap().entries.map((optionEntry) {
                              final optionIndex = optionEntry.key;
                              final optionText = optionEntry.value;
                              final isSelected = optionIndex == answer.selectedIndex;
                              final isCorrect = optionIndex == answer.correctIndex;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? Colors.green.shade100
                                      : isSelected
                                          ? Colors.red.shade100
                                          : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isCorrect
                                        ? Colors.green.shade300
                                        : isSelected
                                            ? Colors.red.shade300
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${String.fromCharCode(65 + optionIndex)}. ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCorrect
                                            ? Colors.green.shade700
                                            : isSelected
                                                ? Colors.red.shade700
                                                : Colors.grey.shade700,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        optionText,
                                        style: TextStyle(
                                          color: isCorrect
                                              ? Colors.green.shade700
                                              : isSelected
                                                  ? Colors.red.shade700
                                                  : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    if (isCorrect)
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.green.shade700,
                                      ),
                                    if (isSelected && !isCorrect)
                                      Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red.shade700,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Close Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.of(context).pop();
                _showEditProfileDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.of(context).pop();
                _showSignOutDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController();
    final user = context.read<AuthProvider>().user;

    if (user != null) {
      nameController.text = user.name;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                final success =
                    await context.read<AuthProvider>().updateProfile(
                          name: nameController.text.trim(),
                        );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Profile updated!'
                          : 'Failed to update profile'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              context.read<UserProgressProvider>().clearUser();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}