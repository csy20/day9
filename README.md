# Digital Recipe Card App 🍳

A modern Flutter application for managing and organizing your favorite recipes with persistent local storage.

## Features ✨

### Core Functionality
- **Recipe Management**: Create, read, update, and delete recipes
- **Favorite System**: Mark recipes as favorites with persistent storage
- **Onboarding Flow**: First-time user experience with completion tracking
- **Local Storage**: All data persisted using SharedPreferences
- **Sample Data**: Pre-loaded with 3 sample recipes for immediate use

### User Interface
- **Modern Material Design**: Clean, intuitive UI following Material 3 guidelines
- **Recipe Cards**: Beautiful cards with images, ratings, and favorite indicators
- **Detail Views**: Comprehensive recipe details with ingredients and instructions
- **Responsive Design**: Works across different screen sizes

### Technical Features
- **State Management**: Riverpod for efficient state management
- **Persistent Storage**: SharedPreferences for local data storage
- **Image Support**: Network image loading with fallback placeholders
- **Navigation**: Smooth navigation between screens
- **Error Handling**: Graceful error handling and user feedback

## Getting Started 🚀

### Prerequisites
- Flutter SDK (>= 3.32.4)
- Dart SDK (>= 3.8.1)
- Android Studio / VS Code
- Android SDK / iOS SDK (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd day9
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── recipe.dart          # Recipe data model
├── providers/
│   └── recipe_provider.dart # State management with Riverpod
├── services/
│   └── shared_preferences_service.dart # Local storage service
└── widgets/
    ├── add_recipe_screen.dart      # Add new recipes
    ├── favorite_recipes_screen.dart # View favorite recipes
    ├── onboarding_screen.dart      # First-time user onboarding
    ├── recipe_card.dart            # Recipe display component
    ├── recipe_detail_screen.dart   # Detailed recipe view
    └── recipe_list_screen.dart     # Main recipe list
```

## Dependencies 📦

```yaml
dependencies:
  flutter: sdk: flutter
  flutter_riverpod: ^2.6.1     # State management
  shared_preferences: ^2.2.2   # Local storage
  cupertino_icons: ^1.0.8      # iOS-style icons

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0        # Code linting
```

## Data Storage 💾

The app uses SharedPreferences for local data persistence:

- **Recipes**: Stored as JSON strings in a list
- **Favorites**: Stored as a list of recipe IDs
- **Onboarding**: Boolean flag for completion status
- **User Preferences**: Extensible storage for app settings

## Sample Data 📝

The app includes 3 pre-loaded sample recipes:
1. **Classic Spaghetti Carbonara** - Traditional Italian pasta
2. **Chocolate Chip Cookies** - Soft and chewy cookies
3. **Grilled Salmon with Lemon** - Healthy grilled fish

## Git Workflow 🔄

### Useful Git Commands

```bash
# Check status
git status
# or use alias
git st

# View commit history
git log --oneline
# or use pretty alias
git lg

# Create a new branch
git checkout -b feature/new-feature
# or use alias
git co -b feature/new-feature

# Commit changes
git add .
git commit -m "Add new feature"
# or use alias
git ci -m "Add new feature"

# View branches
git branch
# or use alias
git br
```

### Git Aliases Set Up
- `git st` → `git status`
- `git co` → `git checkout`
- `git br` → `git branch`
- `git ci` → `git commit`
- `git lg` → Pretty formatted log with graph

## Development Guidelines 🛠️

### Code Style
- Follow Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
- Use descriptive commit messages
- Include the type of change (feat, fix, docs, etc.)
- Reference issues when applicable

### Branch Naming
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git co -b feature/amazing-feature`)
3. Commit your changes (`git ci -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting 🔧

### Common Issues

1. **Dependencies not found**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **iOS build issues**
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Riverpod for state management
- Material Design for UI guidelines
- Unsplash for sample recipe images

---

**Built with ❤️ using Flutter**
