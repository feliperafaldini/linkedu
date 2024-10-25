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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projeto Integrador - Grafos - LINKEDU',
        theme: themeProvider.theme,
        home: const AuthPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/loginpage':
              return _createRoute(const LoginPage());
            case '/registerpage':
              return _createRoute(const RegisterPage());
            case '/recoveraccount':
              return _createRoute(const RecoverAccount());
            case '/homepage':
              return _createRoute(const HomePage());
            default:
              return MaterialPageRoute(
                builder: (context) => const AuthPage(),
              );
          }
        });
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInSine;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
