import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/task_service.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAX2Qir931uqy-OTNqFE942pztDfdYsPc0",
        authDomain: "todo-3f99c.firebaseapp.com",
        projectId: "todo-3f99c",
        storageBucket: "todo-3f99c.appspot.com",
        messagingSenderId: "803147037603",
        appId: "1:803147037603:web:ecefe9f5d16fbae10df816",
      ),
    );
  } catch (e) {
    runApp(const ErrorApp());
    return;
  }

  runApp(const MyApp());
}

// Fallback widget for Firebase initialization failure
class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Initialization Error',
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize Firebase. Please try again later.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appTitle,
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => Consumer<AuthService>(
                builder: (context, authService, _) {
                  // Show HomeScreen if user is logged in, otherwise LoginScreen
                  return authService.user == null ? const LoginScreen() : const HomeScreen();
                },
              ),
          '/register': (context) => const RegisterScreen(), // Register Route
          '/home': (context) => const HomeScreen(),        // Add the missing Home route
        },
      ),
    );
  }
}
