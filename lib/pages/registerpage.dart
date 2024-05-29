import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // NOME APP
                  Text(
                    'LINKEDU',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TEXTFIELD USERNAME
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Nome de usuário'),
                    validator: (value) {
                      if (value == null || value.length <= 5) {
                        return 'Usuário inválido';
                      }
                      return null;
                    },
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

                  const SizedBox(height: 15),

                  // BOTÃO LOGIN
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      animationDuration: const Duration(milliseconds: 100),
                      elevation: 1,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, '/loginpage');
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
