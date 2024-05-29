import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'components/cardprovider.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'pages/recoveraccount.dart';
import 'pages/registerpage.dart';
import 'theme/dark_mode.dart';
import 'theme/light_mode.dart';
// import 'pages/intropage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projeto Integrador - LINKEDU',
        theme: lightMode,
        darkTheme: darkMode,
        home: const LoginPage(),
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
