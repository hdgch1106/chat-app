import 'package:chat_app/config/helpers/show_alert.dart';
import 'package:chat_app/presentation/providers/register_form_provider.dart';
import 'package:chat_app/presentation/providers/socket_provider.dart';
import 'package:chat_app/presentation/widgets/custom_input.dart';
import 'package:chat_app/presentation/widgets/login_button.dart';
import 'package:chat_app/presentation/widgets/login_labels.dart';
import 'package:chat_app/presentation/widgets/login_logo.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          )),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  /* final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController(); */

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final socket = Provider.of<SocketProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Nombre",
            onChanged: registerForm.onNameChange,
            errorMessage: registerForm.state.isFormPosted
                ? registerForm.state.name.errorMessage
                : null,
          ),
          CustomInput(
              icon: Icons.email_outlined,
              placeholder: "Correo",
              keyboardType: TextInputType.emailAddress,
              onChanged: registerForm.onEmailChange,
              errorMessage: registerForm.state.isFormPosted
                  ? registerForm.state.email.errorMessage
                  : null),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",
            isPassword: true,
            onChanged: registerForm.onPasswordChange,
            errorMessage: registerForm.state.isFormPosted
                ? registerForm.state.password.errorMessage
                : null,
          ),
          const SizedBox(height: 15),
          LoginButton(
            text: "Registrar",
            onPressed: registerForm.state.isPosting == false
                ? () async {
                    await registerForm.onFormSubmit(context);
                    if (auth.state.authStatus == AuthStatus.authenticated) {
                      if (context.mounted) {
                        socket.connect();
                        Navigator.pushReplacementNamed(context, "usuarios");
                      }
                    } else {
                      if (context.mounted) {
                        showAlert(context, "Registro fallido",
                            auth.state.errorMessage);
                      }
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
