import 'package:flutter/material.dart';

import 'package:linkedu/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'services/auth/auth.dart';
import 'provider/card_provider.dart';
import 'pages/home_page.dart';
import 'pages/login_register/login_page.dart';
import 'pages/login_register/recover_account.dart';
import 'pages/login_register/register_page.dart';
import 'theme/dark_mode.dart';
import 'theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projeto Integrador - LINKEDU',
        theme: lightMode,
        darkTheme: darkMode,
        home: const AuthPage(),
        routes: {
          '/loginpage': (context) => const LoginPage(),
          '/registerpage': (context) => const RegisterPage(),
          '/recoveraccount': (context) => const RecoverAccount(),
          '/homepage': (context) => const HomePage(),
        },
      ),
    );
  }
}
