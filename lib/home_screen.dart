import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'quiz_provider.dart';
import 'auth_provider.dart';
import 'user_progress.dart';
import 'subject_card.dart';
import 'responsive_layout.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isProfileHovering = false;
  bool _isTitleHovering = false;
  
  static const List<Map<String, dynamic>> subjects = [
    {
      'name': 'DSA',
      'fullName': 'Data Structures & Algorithms',
      'icon': Icons.code,
      'color': Color(0xFF3B82F6),
      'image': 'assets/images/dsa.png',
      'duration': '12 min',
      'questions': '5 questions',
    },
    {
      'name': 'DBMS',
      'fullName': 'Database Management System',
      'icon': Icons.storage,
      'color': Color(0xFF10B981),
      'image': 'assets/images/dbms.png',
      'duration': '10 min',
      'questions': '5 questions',
    },
    {
      'name': 'Operating Systems',
      'fullName': 'Operating Systems',
      'icon': Icons.computer,
      'color': Color(0xFF8B5CF6),
      'image': 'assets/images/os.png',
      'duration': '10 min',
      'questions': '5 questions',
    },
    {
      'name': 'Computer Networks',
      'fullName': 'Computer Networks',
      'icon': Icons.network_wifi,
      'color': Color(0xFFF59E0B),
      'image': 'assets/images/network.png',
      'duration': '8 min',
      'questions': '5 questions',
    },
    {
      'name': 'OOP',
      'fullName': 'Object Oriented Programming',
      'icon': Icons.architecture,
      'color': Color(0xFFEF4444),
      'image': 'assets/images/oop.jpg',
      'duration': '8 min',
      'questions': '5 questions',
    },
    {
      'name': 'Aptitude',
      'fullName': 'Quantitative Aptitude',
      'icon': Icons.calculate,
      'color': Color(0xFF06B6D4),
      'image': 'assets/images/aptitude.png',
      'duration': '15 min',
      'questions': '5 questions',
    },
    {
      'name': 'HR',
      'fullName': 'Human Resources',
      'icon': Icons.people,
      'color': Color(0xFFEC4899),
      'image': 'assets/images/hr.png',
      'duration': '15 min',
      'questions': '5 questions',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startQuiz(BuildContext context, String subject) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(subject: subject),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _startDailyQuiz(BuildContext context) async {
    _startQuiz(context, 'Daily Quiz');
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

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
            child: Consumer3<AuthProvider, UserProgressProvider, QuizProvider>(
              builder:
                  (context, authProvider, progressProvider, quizProvider, _) {
                final user = authProvider.user;
                final stats = progressProvider.getProgressStats();

                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Header
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: EdgeInsets.only(
                                bottom: ResponsiveLayout.getSpacing(context),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Profile Picture with scale animation
                                  ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
                                    ),
                                    child: MouseRegion(
                                      onEnter: (_) => setState(() => _isProfileHovering = true),
                                      onExit: (_) => setState(() => _isProfileHovering = false),
                                      child: AnimatedScale(
                                        scale: _isProfileHovering ? 1.08 : 1.0,
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeOutBack,
                                        child: GestureDetector(
                                          onTap: () => _navigateToProfile(context),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: user?.profilePicture != null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: Image.asset(
                                                      user?.profilePicture ?? '',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Icon(
                                                          Icons.person,
                                                          size: 30,
                                                          color: Color(0xFF3B82F6),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Color(0xFF3B82F6),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // User Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Hello, ${user?.name.split(' ').first ?? 'User'}!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFF1F2937),
                                                    fontSize:
                                                        ResponsiveLayout.getFontSize(
                                                            context,
                                                            base: 20),
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Animate(
                                              effects: [
                                                ScaleEffect(duration: 800.ms, curve: Curves.elasticOut),
                                                ShakeEffect(duration: 800.ms),
                                              ],
                                              child: const Text('👋',
                                                  style: TextStyle(fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Ready for today\'s challenge?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xFF6B7280),
                                                fontSize: ResponsiveLayout.getFontSize(
                                                    context,
                                                    base: 14),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Stats Summary
                                  ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.orange.shade100,
                                                Colors.orange.shade200,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.stars,
                                                size: 16,
                                                color: Colors.orange.shade700,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${stats['totalPoints'] ?? 0}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange.shade700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (stats['currentStreak'] != null &&
                                            (stats['currentStreak'] as int) > 0)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.red.shade100,
                                                  Colors.red.shade200,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.withOpacity(0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Animate(
                                                  effects: [
                                                    ScaleEffect(duration: 600.ms, curve: Curves.elasticOut),
                                                  ],
                                                  child: Icon(
                                                    Icons.local_fire_department,
                                                    size: 12,
                                                    color: Colors.red.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${stats['currentStreak']}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // App Title
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 0.8),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: EdgeInsets.only(
                                bottom: ResponsiveLayout.getSpacing(context),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // App Icon - INDEPENDENT HOVER
                                  MouseRegion(
                                    onEnter: (_) => setState(() => _isTitleHovering = true),
                                    onExit: (_) => setState(() => _isTitleHovering = false),
                                    child: AnimatedScale(
                                      scale: _isTitleHovering ? 1.1 : 1.0,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOutBack,
                                      child: ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: _animationController,
                                          curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF3B82F6).withOpacity(0.2),
                                                const Color(0xFF3B82F6).withOpacity(0.4),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF3B82F6).withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.school,
                                            size: ResponsiveLayout.getIconSize(context, base: 32),
                                            color: const Color(0xFF3B82F6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveLayout.getSpacing(context)),
                                  Text(
                                    'CS Prep',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1F2937),
                                          fontSize: ResponsiveLayout.getFontSize(context, base: 28),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Master Computer Science with Smart Quizzes',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: const Color(0xFF6B7280),
                                          fontSize: ResponsiveLayout.getFontSize(context, base: 16),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Daily Quiz Card
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 0.6),
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: ResponsiveLayout.getSpacing(context) * 2,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _startDailyQuiz(context),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Animate(
                                    effects: [
                                      ScaleEffect(
                                        duration: 600.ms,
                                        curve: Curves.elasticOut,
                                        delay: 200.ms,
                                      ),
                                    ],
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF667EEA),
                                            Color(0xFF764BA2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                const Color(0xFF667EEA).withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: _animationController,
                                              curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.today,
                                                color: Colors.white,
                                                size: ResponsiveLayout.getIconSize(context,
                                                    base: 24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  ResponsiveLayout.getSpacing(context)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Daily Quiz',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize:
                                                            ResponsiveLayout.getFontSize(
                                                                context,
                                                                base: 20),
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Mixed questions • 10 min • 5 questions',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            Colors.white.withOpacity(0.9),
                                                        fontSize:
                                                            ResponsiveLayout.getFontSize(
                                                                context,
                                                                base: 14),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: _animationController,
                                              curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: ResponsiveLayout.getIconSize(context,
                                                  base: 24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Section Title
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 0.4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              margin: EdgeInsets.only(
                                bottom: ResponsiveLayout.getSpacing(context),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Choose Your Subject',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1F2937),
                                          fontSize: ResponsiveLayout.getFontSize(context,
                                              base: 22),
                                        ),
                                  ),
                                  const Spacer(),
                                  Animate(
                                    effects: [
                                      ScaleEffect(duration: 800.ms, delay: 300.ms),
                                    ],
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${subjects.length} subjects',
                                        style: const TextStyle(
                                          color: Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Subjects Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount =
                                ResponsiveLayout.getCrossAxisCount(context);
                            final childAspectRatio =
                                ResponsiveLayout.isMobileLayout(context)
                                    ? 1.4
                                    : 1.2;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing:
                                    ResponsiveLayout.getSpacing(context),
                                mainAxisSpacing:
                                    ResponsiveLayout.getSpacing(context),
                              ),
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                final subject = subjects[index];
                                return Animate(
                                  effects: [
                                    FadeEffect(
                                      duration: 600.ms,
                                      delay: (100 * index).ms,
                                    ),
                                    SlideEffect(
                                      duration: 600.ms,
                                      delay: (100 * index).ms,
                                      begin: const Offset(0, 20),
                                    ),
                                    ScaleEffect(
                                      duration: 600.ms,
                                      delay: (100 * index).ms,
                                      begin: const Offset(0.8, 0.8),
                                    ),
                                  ],
                                  child: SubjectCard(
                                    subject: subject,
                                    onTap: () => _startQuiz(context, subject['name']),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: ResponsiveLayout.getSpacing(context) * 2),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}