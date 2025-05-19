import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school_ai_assistant/providers/app_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'Teacher';

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Try to use Firebase Auth if available
        try {
          final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          Provider.of<AppState>(context, listen: false).setUser(
            userCredential.user,
            _selectedRole,
          );
        } catch (firebaseError) {
          // Firebase auth failed or not available, use demo mode
          print("Firebase auth failed: $firebaseError");

          // For demo purposes only - use mock authentication
          Provider.of<AppState>(context, listen: false).setMockUser(_selectedRole);

          // Show success message for demo mode
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Demo login successful as $_selectedRole')),
          );
        }
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.school,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'School AI Assistant',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: ['Admin', 'Teacher', 'Student'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // Demo login button for easier testing
                TextButton(
                  onPressed: () {
                    // For demo purposes - uses the mock authentication
                    Provider.of<AppState>(context, listen: false).setMockUser(_selectedRole);
                  },
                  child: Text('Demo Login (No Authentication)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}