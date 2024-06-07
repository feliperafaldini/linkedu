import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

import '../provider/card_provider.dart';
import '../models/job.dart';
import '../provider/theme_provider.dart';
import '../services/helper/helper_functions.dart';

import 'card_page/card_page.dart';
import 'messages_chat/message_page.dart';
import 'profile_page/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  var messageIcon = Ionicons.mail_outline;

  changeBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        messageIcon = Ionicons.mail_outline;
        return buildCards(context);
      case 1:
        messageIcon = Ionicons.mail_open_outline;
        return buildMessages(context);
      case 2:
        messageIcon = Ionicons.mail_outline;
        return buildProfile(context);
      default:
        messageIcon = Ionicons.mail_outline;
        return buildCards(context);
    }
  }

  Widget buildCards(context) {
    final provider = Provider.of<CardProvider>(context);
    final companies = provider.companies;

    return companies.isEmpty
        ? const Center(
            child: Text('Não há mais vagas disponíveis para você :('),
          )
        : Stack(
            children: companies
                .map(
                  (company) => CardPage(
                    company: company,
                    job: const Job(
                        description: 'descrição',
                        hours: 'horário',
                        position: 'cargo'),
                    isFront: companies.last == company,
                  ),
                )
                .toList(),
          );
  }

  Widget buildMessages(context) {
    return const MessagePage();
  }

  Widget buildProfile(context) {
    return const ProfilePage();
  }

  void logout() {
    logoutMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LINKEDU',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'LINKEDU',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2,
              color: themeProvider.theme.colorScheme.inversePrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor: themeProvider.theme.colorScheme.surface,
          actions: [
            Switch(
              value: themeProvider.isDark,
              onChanged: (value) {
                setState(() {
                  themeProvider.toggleTheme();
                });
              },
            ),
            IconButton(
              onPressed: logout,
              tooltip: 'Logout',
              hoverColor: themeProvider.theme.colorScheme.primary,
              icon: Icon(
                Icons.logout,
                color: themeProvider.theme.colorScheme.inversePrimary,
                size: 32,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: themeProvider.theme.colorScheme.surface,
          ),
          child: changeBody(selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: themeProvider.theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              rippleColor: const Color.fromARGB(255, 8, 138, 245),
              hoverColor: Colors.grey,
              haptic: true,
              backgroundColor: themeProvider.theme.colorScheme.surface,
              tabBackgroundColor: themeProvider.theme.colorScheme.tertiary,
              activeColor: themeProvider.theme.colorScheme.primary,
              gap: 10,
              iconSize: 30,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              onTabChange: (value) {
                setState(
                  () {
                    selectedIndex = value;
                  },
                );
              },
              tabs: [
                GButton(
                  icon: Ionicons.briefcase_outline,
                  text: 'Vagas',
                  iconColor: themeProvider.theme.colorScheme.inversePrimary,
                ),
                GButton(
                  icon: messageIcon,
                  text: 'Menssagens',
                  iconColor: themeProvider.theme.colorScheme.inversePrimary,
                ),
                GButton(
                  icon: Ionicons.person_circle_outline,
                  text: 'Perfil',
                  iconColor: themeProvider.theme.colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
