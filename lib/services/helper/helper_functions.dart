import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

void progressIndicator(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void displayMessageToUser(String title, String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: Theme.of(context).colorScheme.primary,
      showCloseIcon: true,
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      content: Row(
        children: [
          Text(title),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    ),
  );
}

void descriptionPopUp(context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Center(
          child: Text('Descrição da vaga'),
        ),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}

Future galleryOrCameraDialog(BuildContext context) async {
  final authProvider =Provider.of<AuthService>(context, listen: false); 
  FirebaseAuth auth = FirebaseAuth.instance;

  ImagePicker imagePicker = ImagePicker();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Text(
            'Escolha o meio de upload da imagem:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SizedBox(
          height: 80,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          XFile? file = await imagePicker.pickImage(
                            source: ImageSource.camera,
                          );
                          

                          if (file != null) {
                            File filePath = File(file.path);

                            String imageUrl = await authProvider.uploadUserImage(auth.currentUser!, filePath);

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, imageUrl);
                            
                          }
                        },
                        icon: const Icon(Icons.photo_camera_outlined),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (file != null) {
                            File filePath = File(file.path);

                            String imageUrl = await authProvider.uploadUserImage(auth.currentUser!, filePath);

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, imageUrl);

                            
                          }
                        },
                        icon: const Icon(Icons.photo),
                      ),
                      Text(
                        'Galeria',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Fechar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void logoutMessage(BuildContext context) {
  final authService = Provider.of<AuthService>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Logout',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        content: Text(
          'Deseja realmente sair?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              authService.signOut();
              Navigator.pop(context);
            },
            child: Text(
              'Sair',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
