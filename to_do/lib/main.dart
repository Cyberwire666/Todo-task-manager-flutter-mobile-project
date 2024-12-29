import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'package:provider/provider.dart'; // State management with Provider
import 'screens/login_screen.dart'; // Screen for user login
import 'screens/register_screen.dart'; // Screen for user registration
import 'screens/home_screen.dart'; // Home screen after login
import 'services/auth_service.dart'; // AuthService for user authentication
import 'services/task_service.dart'; // TaskService for task management
import 'constants.dart'; // App constants (e.g., app title, configurations)

// Main function to initialize Firebase and run the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is ready for asynchronous operations
  try {
    // Initialize Firebase with configuration
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAX2Qir931uqy-OTNqFE942pztDfdYsPc0", // Firebase API key
        authDomain: "todo-3f99c.firebaseapp.com", // Firebase authentication domain
        projectId: "todo-3f99c", // Firebase project ID
        storageBucket: "todo-3f99c.appspot.com", // Firebase storage bucket
        messagingSenderId: "803147037603", // Firebase messaging sender ID
        appId: "1:803147037603:web:ecefe9f5d16fbae10df816", // Firebase app ID
      ),
    );
  } catch (e) {
    // If Firebase initialization fails, show fallback UI
    runApp(const ErrorApp());
    return;
  }

  // Run the main app if Firebase initialization succeeds
  runApp(const MyApp());
}

// Widget shown when Firebase initialization fails
class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides debug banner
      title: 'Initialization Error', // App title for this fallback
      home: Scaffold(
        body: Center(
          // Error message displayed to the user
          child: Text(
            'Failed to initialize Firebase. Please try again later.',
            style: TextStyle(fontSize: 18, color: Colors.red), // Styling the error text
            textAlign: TextAlign.center, // Center align the text
          ),
        ),
      ),
    );
  }
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provides global services like AuthService and TaskService
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()), // AuthService for authentication logic
        ChangeNotifierProvider(create: (_) => TaskService()), // TaskService for task management
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hides debug banner
        title: Constants.appTitle, // App title from constants
        initialRoute: '/', // Set the initial route of the app
        routes: {
          '/': (context) => Consumer<AuthService>(
                // Determines the initial screen based on user's login state
                builder: (context, authService, _) {
                  return authService.user == null 
                      ? const LoginScreen() // Show LoginScreen if user is not logged in
                      : const HomeScreen(); // Show HomeScreen if user is logged in
                },
              ),
          '/register': (context) => const RegisterScreen(), // Route to the RegisterScreen
          '/home': (context) => const HomeScreen(), // Explicit route to the HomeScreen
        },
      ),
    );
  }
}
