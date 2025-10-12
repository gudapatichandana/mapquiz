# CS Prep - Computer Science Quiz Application

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

A comprehensive offline quiz application for Computer Science students to prepare for technical interviews and exams. Built with Flutter, featuring beautiful animations, progress tracking, and achievement systems.

## ✨ Features

### 🎯 Core Features

- **7 Subject Areas**: DSA, DBMS, Operating Systems, Computer Networks, OOP, Aptitude, and HR
- **Daily Quiz**: Mixed questions from all subjects
- **Offline First**: Works completely offline with local data storage
- **Progress Tracking**: Track your performance across subjects
- **Achievement System**: Unlock badges and rewards
- **Streak Tracking**: Maintain daily quiz streaks

### 📊 Progress & Analytics

- Real-time score tracking
- Subject-wise performance charts
- Average score calculations
- Time spent analytics
- Quiz history with detailed reviews

### 🎨 UI/UX Features

- Beautiful gradient backgrounds
- Smooth animations and transitions
- Responsive design (Mobile, Tablet, Desktop)
- Interactive hover effects
- Custom subject cards with images
- Progress indicators and timers

### 👤 User Management

- Local authentication system
- Multiple user accounts
- Profile customization
- Achievement badges
- Streak counters

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/cs-prep.git
cd cs-prep
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate Hive adapters**

```bash
flutter packages pub run build_runner build
```

4. **Run the app**

```bash
flutter run
```

## 📦 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # UI Components
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0
  flutter_spinkit: ^5.2.0
  fl_chart: ^0.65.0

  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.1
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  flutter_lints: ^3.0.0
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── user_model.dart           # User data model
│   ├── quiz_question.dart        # Question model
│   ├── quiz_history.dart         # Quiz history model
│   └── quiz_result.dart          # Quiz result model
├── providers/
│   ├── auth_provider.dart        # Authentication state
│   ├── quiz_provider.dart        # Quiz state management
│   └── user_progress.dart        # User progress tracking
├── services/
│   ├── auth_service.dart         # Authentication logic
│   ├── quiz_service.dart         # Quiz generation
│   └── local_storage_service.dart # Hive operations
├── screens/
│   ├── auth_wrapper.dart         # Auth state handler
│   ├── login_screen.dart         # Login page
│   ├── signup_screen.dart        # Registration page
│   ├── home_screen.dart          # Main dashboard
│   ├── quiz_screen.dart          # Quiz interface
│   ├── result_screen.dart        # Results display
│   └── profile_screen.dart       # User profile
├── widgets/
│   ├── subject_card.dart         # Subject selection cards
│   ├── question_card.dart        # Question display
│   ├── progress_card.dart        # Progress indicators
│   └── achievement_badge.dart    # Achievement display
├── utils/
│   ├── constants.dart            # App constants
│   ├── responsive_layout.dart    # Responsive utilities
│   └── sample_data_loader.dart   # Sample data
└── assets/
    └── images/                   # Subject images
```

## 🎮 How to Use

### First Time Setup

1. Launch the app
2. Create an account (works offline)
3. Choose your name and email
4. Start taking quizzes!

### Taking a Quiz

1. Select a subject from the home screen
2. Answer 5 questions within the time limit
3. Review your answers after submission
4. Earn points and unlock achievements

### Tracking Progress

1. View your profile from the home screen
2. Check your stats and achievements
3. Review previous quiz attempts
4. Track your learning streak

## 🏆 Achievement System

### Available Achievements

- **First Steps**: Complete your first quiz
- **Week Warrior**: 7-day streak
- **Monthly Master**: 30-day streak
- **Point Collector**: Earn 1000 points
- **Point Master**: Earn 5000 points
- **Quiz Novice**: Complete 10 quizzes
- **Quiz Expert**: Complete 50 quizzes
- **Perfectionist**: Score 100% on 5 quizzes
- **Subject Mastery**: Excel in specific subjects

## 📊 Scoring System

### Base Points: 100

**Accuracy Bonuses:**

- 90%+ accuracy: +50 points
- 80%+ accuracy: +25 points

**Speed Bonus:**

- Complete in <80% of time: +25 points

**Perfect Score:**

- 100% accuracy: +100 bonus points

## 🎨 Customization

### Adding New Subjects

1. Edit `quiz_service.dart`
2. Add questions to `_questionBank`
3. Update `SubjectConstants` in `constants.dart`
4. Add subject icon and color

### Modifying UI Theme

Edit `main.dart` theme configuration:

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
  ),
  // ... other theme properties
)
```

## 🔧 Configuration

### Quiz Settings

Edit `constants.dart` to modify:

- Question count per quiz
- Time limits
- Point thresholds
- Achievement requirements

### Storage Settings

Configure Hive boxes in `local_storage_service.dart`:

- User data
- Quiz history
- Questions bank
- App settings

## 🌐 Responsive Design

The app supports three layout modes:

- **Mobile**: < 600px width
- **Tablet**: 600px - 1200px width
- **Desktop**: > 1200px width

Layouts automatically adjust based on screen size.

## 🐛 Troubleshooting

### Common Issues

**Build errors after cloning:**

```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Hive initialization errors:**

- Ensure `hive_flutter` is properly initialized in `main.dart`
- Check that all adapters are registered

**Questions not loading:**

- Verify `populateLocalQuestions()` is called in `main.dart`
- Check local storage initialization

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow Flutter/Dart style guidelines
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- All contributors and testers
- Open source community

## 📧 Contact

For questions or feedback:

- Create an issue on GitHub
- Email: gudapatichandana53@gmail.com

## 🗺️ Roadmap

### Version 2.0 (Planned)

- [ ] Cloud sync support
- [ ] Multiplayer quiz battles
- [ ] Leaderboards
- [ ] More subjects (Web Dev, Mobile Dev)
- [ ] Custom quiz creation
- [ ] Study notes integration
- [ ] Social sharing features
- [ ] Dark mode
- [ ] Multiple language support

### Version 1.1 (Current)

- [x] Offline functionality
- [x] 7 subjects
- [x] Achievement system
- [x] Progress tracking
- [x] Responsive design

## 📈 Stats

- **Total Questions**: 35+ across 7 subjects
- **Achievements**: 15 unique badges
- **Languages**: English
- **Platform Support**: Android, iOS, Web

---

**Star ⭐ this repository if you find it helpful!**
