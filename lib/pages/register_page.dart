import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:chat_app/widgets/login_labels.dart';
import 'package:chat_app/widgets/login_logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LoginLogo(title: "Registro"),
                  const _Form(),
                  const LoginLabels(
                      label1: "¿Ya tienes una cuenta?",
                      label2: "Ingresar con tu cuenta",
                      ruta: "login"),
                  Container(
                    margin: const EdgeInsets.only(bottom: 35),
                    child: const Text(
                      "Términos y condiciones de uso",
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Nombre",
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: "Correo",
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",
            textController: passController,
            isPassword: true,
          ),
          const SizedBox(height: 15),
          LoginButton(text: "Registrar", onPressed: () {}),
        ],
      ),
    );
  }
}
