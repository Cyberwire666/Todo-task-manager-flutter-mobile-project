import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart'; // Navigate to HomeScreen after successful registration

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controller for email input
  final TextEditingController _passwordController = TextEditingController(); // Controller for password input
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey to manage the form validation state
  bool _isLoading = false; // Tracks whether the registration is in progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'), // Title of the screen
        centerTitle: true, // Centers the title in the AppBar
        elevation: 0, // Removes shadow effect from AppBar
        backgroundColor: Colors.greenAccent, // AppBar background color
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0), // Padding for the container
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.lightGreen], // Gradient background for the screen
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners for the card
              ),
              elevation: 8, // Adds shadow around the card
              child: Padding(
                padding: const EdgeInsets.all(25.0), // Padding inside the card
                child: Form(
                  key: _formKey, // Attach the form key to the form for validation
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Uses minimal vertical space
                    children: [
                      const Text(
                        'Register', // Register heading
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 20), // Space between widgets
                      TextFormField(
                        controller: _emailController, // Manages the email input field
                        decoration: InputDecoration(
                          labelText: 'Email', // Label for the email field
                          prefixIcon: const Icon(Icons.email, color: Colors.green), // Icon for email input field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners for the input field
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress, // Forces the email keyboard layout
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email'; // Validation for empty email
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address'; // Validation for valid email format
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20), // Space between email and password fields
                      TextFormField(
                        controller: _passwordController, // Manages the password input field
                        decoration: InputDecoration(
                          labelText: 'Password', // Label for the password field
                          prefixIcon: const Icon(Icons.lock, color: Colors.green), // Icon for password input field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners for the input field
                          ),
                        ),
                        obscureText: true, // Hides the password input text
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password'; // Validation for empty password
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters'; // Validation for minimum password length
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30), // Space before the "Create Account" button
                      _isLoading
                          ? const CircularProgressIndicator() // Shows loading spinner while registering
                          : SizedBox(
                              width: double.infinity, // Make the button take full width
                              child: ElevatedButton(
                                onPressed: _register, // Trigger registration process when button is pressed
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent, // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15), // Button padding
                                ),
                                child: const Text(
                                  'Create Account', // Button text
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20), // Space between button and "Already have an account?" text
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Navigate back to the login screen when clicked
                        },
                        child: const Text(
                          'Already have an account? Login', // Text to prompt user to login
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
      ),
    );
  }

  // Function to handle registration logic
  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Set loading state while registering
      });

      try {
        // Attempt to register the user via AuthService
        await context.read<AuthService>().register(
              _emailController.text.trim(), // Email from the input field
              _passwordController.text.trim(), // Password from the input field
            );

        // Redirect to HomeScreen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (e) {
        // Handle errors during registration
        setState(() {
          _isLoading = false; // Reset loading state
        });
        // Show an error message in case of failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }
}
