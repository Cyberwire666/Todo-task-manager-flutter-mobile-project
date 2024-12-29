import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Text controllers to manage user input for email and password
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Title of the screen
        centerTitle: true, // Centers the title
        backgroundColor: Colors.greenAccent, // AppBar background color
        elevation: 0, // Removes shadow for a flat AppBar
      ),
      body: SingleChildScrollView(
        // Allows scrolling if content overflows the screen
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.lightGreen], // Background gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), // Padding for screen
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Card shape with rounded corners
              elevation: 8, // Shadow around the Card
              child: Padding(
                padding: const EdgeInsets.all(25.0), // Padding inside the Card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Uses minimal vertical space
                  children: [
                    const Text(
                      'Welcome Back', // Welcome message
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent, // Text color
                      ),
                    ),
                    const SizedBox(height: 20), // Space between widgets
                    TextField(
                      controller: emailController, // Controller for email input
                      decoration: InputDecoration(
                        labelText: 'Email', // Label for email input field
                        prefixIcon: const Icon(Icons.email, color: Colors.green), // Icon before the input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the input field
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress, // Forces email format input
                    ),
                    const SizedBox(height: 20), // Space between email and password fields
                    TextField(
                      controller: passwordController, // Controller for password input
                      decoration: InputDecoration(
                        labelText: 'Password', // Label for password input field
                        prefixIcon: const Icon(Icons.lock, color: Colors.green), // Icon before the input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the input field
                        ),
                      ),
                      obscureText: true, // Hides the password text input
                    ),
                    const SizedBox(height: 30), // Space before the login button
                    SizedBox(
                      width: double.infinity, // Makes the button take the full width
                      child: ElevatedButton(
                        onPressed: () {
                          final String email = emailController.text.trim(); // Get email text input
                          final String password = passwordController.text.trim(); // Get password text input

                          // Call the login function from AuthService
                          context.read<AuthService>().login(email, password).then((_) {
                            Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen after successful login
                          }).catchError((e) {
                            // Show error message if login fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login failed: $e")),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding for button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                          ),
                        ),
                        child: const Text(
                          'Login', // Button text
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Space before the "Register" link
                    GestureDetector(
                      // Detects a tap on the text and navigates to the registration screen
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Don’t have an account? Register', // Text prompting user to register
                        style: TextStyle(
                          color: Colors.greenAccent, // Text color
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
