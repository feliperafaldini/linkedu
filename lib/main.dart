// Imports flutter
import 'package:flutter/material.dart';

// Imports developer
import 'dart:developer';

// Imports http
import 'package:http/http.dart' as http;

// Imports firebase
import 'package:linkedu/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// Imports provider package
import 'package:provider/provider.dart';

// Imports providers
import 'provider/auth_provider.dart';
import 'provider/theme_provider.dart';
import 'provider/card_provider.dart';

// Imports auth
import 'services/auth/auth.dart';

// Imports pages
import 'pages/home_page.dart';
import 'pages/login_register/login_page.dart';
import 'pages/login_register/recover_account_page.dart';
import 'pages/login_register/register_page.dart';

// Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // mainSync();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Integrador - Grafos - LINKEDU',
      theme: themeProvider.theme,
      home: const AuthPage(),
      routes: {
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/recoveraccount': (context) => const RecoverAccount(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }

  // Sync function
  Future<void> mainSync() async {
    final response = await http.get(Uri.parse('http://localhost:3000/sync'));
    if (response.statusCode == 200) {
      log(response.body);
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
  }
}
