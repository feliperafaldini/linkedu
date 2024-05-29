import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlue],
            center: Alignment.center,
            radius: 1,
          ),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
                child: Text(
                  'Bem Vindo ao LINKEDU!',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Text(
                  'Uma plataforma desenvolvida pelos alunos do terceiro semestre de engenharia da computação da UNISO para facilitar a busca de estágios para os alunos de todos os cursos!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
