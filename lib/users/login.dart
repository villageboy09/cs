// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:cropsync/users/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cropsync/users/auth_provider.dart' as custom_auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  
  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Perform login
      final authProvider = Provider.of<custom_auth.AuthProvider>(context, listen: false);
      await authProvider.signIn(email, password);
      
      // Get sidebar provider
      final sidebarProvider = Provider.of<SidebarProvider>(context, listen: false);
      
      // Update user data in sidebar provider
      await sidebarProvider.updateUserData();
      
      // Close loading indicator
      Navigator.pop(context);

      // Verify that user data was fetched
      print('Login successful - Current user: ${FirebaseAuth.instance.currentUser?.uid}');
      print('Sidebar provider state - Name: ${sidebarProvider.userName}, Image: ${sidebarProvider.profileImagePath}');

      // Navigate to home screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/', // Your home route
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Close loading indicator if it's showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      setState(() {
        if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password. Please try again.';
        } else if (e.code == 'user-not-found') {
          _errorMessage = 'No user found with this email.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'The email address is not valid.';
        } else {
          _errorMessage = 'Login failed: ${e.message}';
        }
      });
      print('Login error: ${e.code} - ${e.message}'); // Debug log
    } catch (e) {
      // Close loading indicator if it's showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
      print('Unexpected error during login: $e'); // Debug log
    }
  }
  // Method to show the forgot password modal
  void _showForgotPasswordDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Forgot Password',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      Navigator.pop(context); // Close the modal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset email sent!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Send Reset Email'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Lottie.asset('assets/farmer.json', height: 150),
                  const SizedBox(height: 20),
                  Text(
                    'User Login',
                    style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: GoogleFonts.poppins()),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Sign up', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _showForgotPasswordDialog, // Show forgot password dialog
                    child: Text('Forgot Password?', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}