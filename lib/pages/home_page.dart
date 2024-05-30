import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../components/card_provider.dart';
import '../models/job.dart';
import 'card_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  changeBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return buildCards();
      case 1:
        break;
      case 2:
        break;
      default:
    }
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final companies = provider.companies;

    return companies.isEmpty
        ? const Center(
            child: Text('Não há mais vagas disponíveis para você :('))
        : Stack(
            children: companies
                .map((company) => CardPage(
                      company: company,
                      job: const Job(
                          description: 'descrição',
                          hours: 'horário',
                          position: 'cargo'),
                      isFront: companies.last == company,
                    ))
                .toList(),
          );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [
            IconButton(
              onPressed: logout,
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: changeBody(selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              rippleColor: const Color.fromARGB(255, 8, 138, 245),
              hoverColor: Colors.grey,
              haptic: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              tabBackgroundColor: Colors.blue.shade300,
              activeColor: Theme.of(context).colorScheme.primary,
              gap: 10,
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
                  icon: Icons.cases_outlined,
                  text: 'Vagas',
                  iconColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                GButton(
                  icon: Icons.messenger_outline,
                  text: 'Menssagens',
                  iconColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                GButton(
                  icon: Icons.person_outline_outlined,
                  text: 'Perfil',
                  iconColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
