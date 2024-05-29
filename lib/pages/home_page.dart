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
                .map(
                  (company) => CardPage(
                    company: company,
                    job: const Job(
                        description: 'descrição',
                        hours: 'horário',
                        position: 'cargo'),
                    isFront: companies.last == company,
                  )
                )
                .toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LINKEDU',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'LINKEDU',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
        ),
        body: changeBody(selectedIndex),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            rippleColor: Colors.blue,
            hoverColor: Colors.grey,
            haptic: true,
            tabBackgroundColor: Colors.blue.shade200,
            activeColor: Colors.white,
            gap: 10,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            onTabChange: (value) {
              setState(
                () {
                  selectedIndex = value;
                },
              );
            },
            tabs: const [
              GButton(
                icon: Icons.cases_outlined,
                text: 'Vagas',
              ),
              GButton(
                icon: Icons.messenger_outline,
                text: 'Menssagens',
              ),
              GButton(
                icon: Icons.person_outline_outlined,
                text: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
