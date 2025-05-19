import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// App state management class
class AppState extends ChangeNotifier {
  User? _user;
  String _userRole = '';
  bool _isInitialized = false;

  User? get user => _user;
  String get userRole => _userRole;
  bool get isInitialized => _isInitialized;

  void setUser(User? user, String role) {
    _user = user;
    _userRole = role;
    _isInitialized = true;
    notifyListeners();
  }

  // Mock auth for demo purposes
  void setMockUser(String role) {
    // Using null for User but setting role for demo
    _user = null;
    _userRole = role;
    _isInitialized = true;
    notifyListeners();
  }
}