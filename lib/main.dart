// Imports flutter
import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Integrador - LINKEDU',
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
}
