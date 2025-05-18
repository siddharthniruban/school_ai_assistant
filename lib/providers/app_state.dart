import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// App state management class
class AppState extends ChangeNotifier {
  User? _user;
  String _userRole = '';
  
  User? get user => _user;
  String get userRole => _userRole;
  
  void setUser(User? user, String role) {
    _user = user;
    _userRole = role;
    notifyListeners();
  }
}
