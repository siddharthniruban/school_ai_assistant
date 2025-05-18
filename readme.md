# School AI Assistant

A cross-platform Flutter application that serves as an AI-powered educational assistant for schools. This app contains government syllabus and allows schools to upload additional custom syllabus materials. The core AI feature generates question papers automatically based on selected chapters and classes.

## Features

- Pre-loaded structured government syllabus (class-wise & subject-wise)
- Upload additional syllabus materials
- AI-based question paper generator with various question types and difficulty levels
- Question bank for saving and reusing generated questions

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase project (for authentication, storage, and database)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/school_ai_assistant.git
   cd school_ai_assistant
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up Firebase:
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add Android and iOS apps to your Firebase project
   - Download and add the Firebase configuration files:
     - For Android: `google-services.json` to `android/app/`
     - For iOS: `GoogleService-Info.plist` to `ios/Runner/`
   - Enable Authentication (Email & Password), Firestore Database, and Storage

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── providers/                # State management
  │   └── app_state.dart        # Global application state
  ├── screens/                  # App screens
  │   ├── home_screen.dart      # Main dashboard screen
  │   ├── login_screen.dart     # Authentication screen
  │   ├── syllabus_screen.dart  # View syllabus content
  │   ├── question_generator_screen.dart # Generate question papers
  │   └── upload_screen.dart    # Upload syllabus materials
  └── widgets/                  # Reusable components
      └── dashboard.dart        # Dashboard widget
```

## Usage

### Login

The app supports three different user roles:
- Admin: Full access to all features
- Teacher: Can generate questions and view/upload materials
- Student: Can view syllabus and practice questions (future enhancement)

For demo purposes, you can use the "Demo Login" button to bypass authentication.

### Syllabus Viewing

1. Select class and subject
2. Browse through available chapters
3. Expand chapters to view topics

### Question Generation

1. Select class, subject, and chapter
2. Choose number of questions and question types
3. Set difficulty level
4. Generate questions
5. Review and export as PDF

### Material Upload (Admin/Teacher)

1. Select class and subject
2. Enter chapter name and description
3. Upload PDF, DOC, DOCX, PPT, or PPTX files

## Future Enhancements

- Student login for practice questions
- Performance analytics
- Voice input and narration
- Multilingual support (regional languages)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
