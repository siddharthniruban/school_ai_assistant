import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:school_ai_assistant/providers/app_state.dart';
import 'package:school_ai_assistant/screens/login_screen.dart';
import 'package:school_ai_assistant/screens/home_screen.dart';

// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization is optional for demo mode
  // Uncomment for production with proper Firebase setup
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
    // App will continue in demo mode
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School AI Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          // Return login screen if user is not set or role is empty
          return (appState.user == null && appState.userRole.isEmpty)
              ? LoginScreen()
              : HomeScreen();
        },
      ),
    );
  }
}