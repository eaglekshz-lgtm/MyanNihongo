# MyanNihongo - Burmese to Japanese Learning App

A Flutter mobile application designed to help Burmese speakers learn Japanese through interactive vocabulary cards and quizzes. The app follows Clean Architecture principles and uses modern Flutter development practices.

## Features

### 🎴 Vocabulary Learning
- **Swipeable Cards**: Learn Japanese vocabulary with intuitive swipe gestures
- **JLPT Level Support**: Filter vocabulary by JLPT levels (N5 to N1)
- **Bilingual Display**: Shows Burmese, English, Japanese script, and romaji readings
- **Progress Tracking**: Track which cards you've mastered

### 📝 Quiz System
- **Multiple Choice Quizzes**: Test your knowledge with multiple-choice questions
- **Customizable Settings**: Choose JLPT level and number of questions
- **Instant Feedback**: Get immediate feedback on your answers
- **Detailed Results**: View comprehensive quiz results with scores and percentages

### 📊 Progress Tracking
- **Overall Statistics**: Track total words learned and quizzes completed
- **Level-based Progress**: Monitor progress across different JLPT levels
- **Performance Metrics**: View success rates and improvement trends

### 🎨 Modern UI/UX
- **Material Design 3**: Modern and beautiful user interface
- **Smooth Animations**: Engaging transitions and animations
- **Dark Mode Support**: Comfortable viewing in any lighting condition
- **Responsive Design**: Works great on all screen sizes

## Architecture

The app follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── error/          # Error handling (exceptions, failures)
│   ├── theme/          # App theming
│   └── utils/          # Utility functions
├── features/
│   ├── vocabulary/
│   │   ├── domain/     # Entities and business logic
│   │   ├── data/       # Data sources, models, repositories
│   │   └── presentation/  # UI, widgets, providers
│   └── quiz/
│       ├── domain/     # Quiz entities
│       ├── data/       # Quiz data layer
│       └── presentation/  # Quiz UI components
└── main.dart
```

### Key Technologies

- **Flutter 3.x**: Cross-platform mobile development
- **Riverpod**: State management
- **Hive**: Local database for offline caching
- **Dio**: HTTP client for API communication
- **Equatable**: Value equality for entities
- **Material Design 3**: Modern UI components

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/myan_nihongo.git
   cd myan_nihongo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (for Hive adapters and JSON serialization)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure Details

### Domain Layer
Contains business entities and business logic rules:
- `VocabularyItem`: Represents a vocabulary word with Burmese, English, and Japanese translations
- `UserProgress`: Tracks user's learning progress
- `QuizQuestion`: Represents quiz questions
- `QuizAnswer`: Stores user's quiz answers

### Data Layer
Handles data sources and repository implementations:
- **API Data Source**: Fetches vocabulary from remote server
- **Local Data Source**: Caches data using Hive for offline access
- **Models**: Data transfer objects with JSON serialization

### Presentation Layer
Contains UI components and state management:
- **Pages**: Full-screen views (Home, Vocabulary Learning, Quiz Setup, Quiz, Results, Progress)
- **Widgets**: Reusable UI components (Vocabulary Cards, Quiz Question Cards)
- **Providers**: Riverpod state notifiers for business logic

## State Management

The app uses **Riverpod** for state management with the following providers:

- `vocabularyProvider`: Manages vocabulary data and loading states
- `quizProvider`: Handles quiz generation and question management

## Local Storage

**Hive** is used for local data persistence:
- `vocabulary_box`: Stores cached vocabulary items
- `user_progress_box`: Tracks user learning progress
- `app_preferences_box`: Stores app settings and preferences

## API Integration

The app is designed to work with a backend API (currently using mock data):

### Expected API Endpoints:
- `GET /api/vocabulary` - Fetch all vocabulary
- `GET /api/vocabulary/{level}` - Fetch vocabulary by JLPT level
- `GET /api/quiz/generate` - Generate quiz questions

## Development

### Running Tests
```bash
flutter test
```

### Code Generation
When you modify Hive models or add JSON serialization:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
```bash
flutter analyze
```

### Build for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Customization

### Theming
Modify colors and styles in `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF1565C0);
static const Color secondaryColor = Color(0xFFFF7043);
```

### Constants
Update app constants in `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  static const String appName = 'MyanNihongo';
  static const String vocabularyBoxName = 'vocabulary_box';
  // ... more constants
}
```

## Roadmap

- [ ] Implement actual API integration
- [ ] Add user authentication
- [ ] Implement spaced repetition algorithm
- [ ] Add audio pronunciation
- [ ] Create flashcard study mode
- [ ] Add social features (leaderboards, sharing)
- [ ] Implement push notifications for study reminders
- [ ] Add more JLPT vocabulary data

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Japanese language data based on JLPT vocabulary lists
- Burmese language support powered by Unicode standards
- Inspired by language learning apps like Duolingo and Anki

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Note**: This app currently uses mock data. To use with a real backend, update the API endpoints in the data source implementations.
# MyanNihongo
