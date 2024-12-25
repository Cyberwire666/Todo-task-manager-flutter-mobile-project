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

  runApp(const MyApp());
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
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.user == null ? const LoginScreen() : const HomeScreen();
          },
        ),
        routes: {
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
