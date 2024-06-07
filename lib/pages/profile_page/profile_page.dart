import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    User? user = _auth.currentUser;

    if (user == null) {
      return const Center(child: Text('Não há usuários logados.'));
    }

    return StreamBuilder(
      stream: _fireStore.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text('Erro ao carregar dados do usuário'),
          );
        }

        var userData = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meu Perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: themeProvider.theme.colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: themeProvider.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          themeProvider.theme.colorScheme.inversePrimary,
                      radius: 72,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          '${userData['image']}',
                          scale: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          userData['name'],
                          style: TextStyle(
                            fontSize: 40,
                            color:
                                themeProvider.theme.colorScheme.inversePrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['email'],
                          style: TextStyle(
                            color:
                                themeProvider.theme.colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: themeProvider.theme.colorScheme.inversePrimary,
                    ),
                    title: Text(
                      'Editar Perfil',
                      style: TextStyle(
                        fontSize: 20,
                        color: themeProvider.theme.colorScheme.inversePrimary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: themeProvider.theme.colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.settings,
                        color: themeProvider.theme.colorScheme.inversePrimary),
                    title: Text(
                      'Configurações',
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              themeProvider.theme.colorScheme.inversePrimary),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: themeProvider.theme.colorScheme.inversePrimary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
