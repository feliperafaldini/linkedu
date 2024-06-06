import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../services/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  Uint8List? _imageSource;

  void registerUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    progressIndicator(context);

    try {
      await authService.createUserWithEmailandPassword(
        emailController.text,
        passwordController.text,
        firstNameController.text,
        lastNameController.text,
        imageSource: _imageSource,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      displayMessageToUser(
        'Sucesso ao criar cadastro',
        'Seu cadastro foi criado com sucesso',
        // ignore: use_build_context_synchronously
        context,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      displayMessageToUser(
        'Erro ao criar cadastro.',
        'Erro: $e',
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }

  setImage() async {
    Uint8List? fileBytes = await showDialog(
      context: context,
      builder: (context) {
        return galleryOrCameraDialog(context);
      },
    );
    setState(() {
      _imageSource = fileBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // NOME APP
                  Text(
                    'LINKEDU',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Registro de novo usuário',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const Spacer(),

                  // PHOTO UPLOAD
                  CircleAvatar(
                    backgroundImage: _imageSource == null
                        ? null
                        : MemoryImage(_imageSource!),
                    radius: 70,
                    child: IconButton(
                      tooltip: 'Adicionar foto de perfil',
                      onPressed: setImage,
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // TEXTFIELD firstName
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Nome',
                          ),
                          validator: (value) {
                            if (value == null || value.length <= 2) {
                              return 'Nome Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Sobrenome',
                          ),
                          validator: (value) {
                            if (value == null || value.length <= 2) {
                              return 'Sobrenome Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // TEXTFIELD EMAIL
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null ||
                          !value.contains('@') ||
                          !value.contains('.')) {
                        return 'Endereço de email inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // TEXTFIELD SENHA
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Senha',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _obscureText = !_obscureText;
                            },
                          );
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value == null) {
                        return 'Senha inválida';
                      } else if (value.length < 6) {
                        return 'Senhas devem conter ao menos 6 digitos';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // TEXTFIELD CONFIRMAR SENHA
                  TextFormField(
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Confirmação de senha',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _obscureTextConfirm = !_obscureTextConfirm;
                            },
                          );
                        },
                        child: Icon(
                          _obscureTextConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscureTextConfirm,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Confirmação de senha inválida';
                      }
                      return null;
                    },
                  ),

                  const Spacer(),

                  // BOTÃO REGISTER
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(400, 40),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      animationDuration: const Duration(milliseconds: 100),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerUser();
                      }
                    },
                    child: Text(
                      'REGISTRAR',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
