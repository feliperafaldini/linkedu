import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/theme_provider.dart';

void progressIndicator(BuildContext context) {
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
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: themeProvider.theme.colorScheme.primary,
      showCloseIcon: true,
      duration: const Duration(seconds: 2),
      backgroundColor: themeProvider.theme.colorScheme.inverseSurface,
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

void descriptionPopUp(BuildContext context, String text) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: themeProvider.theme.colorScheme.surface,
        title: Center(
          child: Text(
            'Descrição da vaga',
            style: TextStyle(
              color: themeProvider.theme.colorScheme.inversePrimary,
            ),
          ),
        ),
        content: Text(
          text,
          style: TextStyle(
            color: themeProvider.theme.colorScheme.inversePrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(
                color: themeProvider.theme.colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<Uint8List?> cameraUpload() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

  if (file != null) return await file.readAsBytes();
  return null;
}

Future<Uint8List?> galleryUpload() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

  if (file != null) return await file.readAsBytes();
  return null;
}

galleryOrCameraDialog(context) {
  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.surface,
    title: const Center(
      child: Text('Escolha o meio de envio da imagem:'),
    ),
    content: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
                  await imagePicker.pickImage(source: ImageSource.camera);

              if (file != null) {
                Uint8List fileBytes = await file.readAsBytes();
                if (context.mounted) Navigator.pop(context, fileBytes);
              }
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined),
                Text('Camera'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
                  await imagePicker.pickImage(source: ImageSource.gallery);

              if (file != null) {
                Uint8List fileBytes = await file.readAsBytes();

                if (context.mounted) Navigator.pop(context, fileBytes);
              }
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_album_outlined),
                Text('Galeria'),
              ],
            ),
          )
        ],
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
    ],
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
